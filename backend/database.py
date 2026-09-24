import json
import os
import uuid
import copy
from typing import Dict, Any, List, Optional
import pymongo
from pymongo import MongoClient
from pymongo.errors import ServerSelectionTimeoutError, ConnectionFailure
from config import settings

DATA_DIR = os.path.join(os.path.dirname(__file__), "data")
STORE_FILE = os.path.join(DATA_DIR, "interviewx_db.json")

class MockInsertResult:
    def __init__(self, inserted_id):
        self.inserted_id = inserted_id

class MockUpdateResult:
    def __init__(self, matched_count=1, modified_count=1):
        self.matched_count = matched_count
        self.modified_count = modified_count

class MockDeleteResult:
    def __init__(self, deleted_count=1):
        self.deleted_count = deleted_count

class LocalCollection:
    def __init__(self, name: str, db_store: 'LocalDocumentStore'):
        self.name = name
        self.db = db_store

    def _matches(self, doc: dict, query: dict) -> bool:
        if not query:
            return True
        for k, v in query.items():
            if k == "$or" and isinstance(v, list):
                if not any(self._matches(doc, cond) for cond in v):
                    return False
                continue
            if k == "$and" and isinstance(v, list):
                if not all(self._matches(doc, cond) for cond in v):
                    return False
                continue
            if isinstance(v, dict):
                # Simple operator support
                doc_val = doc.get(k)
                if "$in" in v:
                    if doc_val not in v["$in"]:
                        return False
                if "$ne" in v:
                    if doc_val == v["$ne"]:
                        return False
                if "$gt" in v:
                    if not (doc_val is not None and doc_val > v["$gt"]):
                        return False
                if "$gte" in v:
                    if not (doc_val is not None and doc_val >= v["$gte"]):
                        return False
                if "$lt" in v:
                    if not (doc_val is not None and doc_val < v["$lt"]):
                        return False
                if "$lte" in v:
                    if not (doc_val is not None and doc_val <= v["$lte"]):
                        return False
            else:
                if doc.get(k) != v:
                    return False
        return True

    def find_one(self, query: dict = None, sort=None) -> Optional[dict]:
        query = query or {}
        docs = self.find(query, sort=sort)
        return docs[0] if docs else None

    def find(self, query: dict = None, sort=None, limit: int = 0) -> List[dict]:
        query = query or {}
        items = self.db._data.get(self.name, [])
        matches = [copy.deepcopy(doc) for doc in items if self._matches(doc, query)]
        
        if sort:
            for field, order in reversed(sort if isinstance(sort, list) else [sort]):
                matches.sort(key=lambda d: d.get(field, 0), reverse=(order == -1 or order == pymongo.DESCENDING))
                
        if limit > 0:
            matches = matches[:limit]
            
        return matches

    def insert_one(self, doc: dict) -> MockInsertResult:
        doc_copy = copy.deepcopy(doc)
        if "_id" not in doc_copy:
            doc_copy["_id"] = str(uuid.uuid4())
        elif isinstance(doc_copy["_id"], uuid.UUID):
            doc_copy["_id"] = str(doc_copy["_id"])
            
        if self.name not in self.db._data:
            self.db._data[self.name] = []
            
        self.db._data[self.name].append(doc_copy)
        self.db._save()
        return MockInsertResult(doc_copy["_id"])

    def update_one(self, query: dict, update: dict) -> MockUpdateResult:
        items = self.db._data.get(self.name, [])
        matched = 0
        modified = 0
        for doc in items:
            if self._matches(doc, query):
                matched += 1
                if "$set" in update:
                    for k, v in update["$set"].items():
                        doc[k] = copy.deepcopy(v)
                    modified += 1
                elif "$push" in update:
                    for k, v in update["$push"].items():
                        if k not in doc or not isinstance(doc[k], list):
                            doc[k] = []
                        doc[k].append(copy.deepcopy(v))
                    modified += 1
                else:
                    # direct update
                    for k, v in update.items():
                        doc[k] = copy.deepcopy(v)
                    modified += 1
                break
        if modified > 0:
            self.db._save()
        return MockUpdateResult(matched, modified)

    def delete_one(self, query: dict) -> MockDeleteResult:
        items = self.db._data.get(self.name, [])
        for idx, doc in enumerate(items):
            if self._matches(doc, query):
                items.pop(idx)
                self.db._save()
                return MockDeleteResult(1)
        return MockDeleteResult(0)

    def count_documents(self, query: dict = None) -> int:
        return len(self.find(query or {}))

class LocalDocumentStore:
    def __init__(self, filepath: str):
        self.filepath = filepath
        self._data: Dict[str, List[dict]] = {}
        self._load()

    def _load(self):
        os.makedirs(os.path.dirname(self.filepath), exist_ok=True)
        if os.path.exists(self.filepath):
            try:
                with open(self.filepath, "r", encoding="utf-8") as f:
                    self._data = json.load(f)
            except Exception as e:
                print(f"[DB] Error loading local DB store: {e}")
                self._data = {}
        else:
            self._data = {}

    def _save(self):
        try:
            with open(self.filepath, "w", encoding="utf-8") as f:
                json.dump(self._data, f, indent=2, default=str)
        except Exception as e:
            print(f"[DB] Error saving local DB store: {e}")

    def __getitem__(self, collection_name: str) -> LocalCollection:
        return LocalCollection(collection_name, self)

# Global DB manager
class DatabaseManager:
    def __init__(self):
        self.client: Optional[MongoClient] = None
        self.db = None
        self.is_mongo = False
        self.local_store = LocalDocumentStore(STORE_FILE)
        self.init_connection()

    def init_connection(self):
        try:
            print(f"[DB] Checking MongoDB connection at {settings.MONGO_URI}...")
            client = MongoClient(settings.MONGO_URI, serverSelectionTimeoutMS=1500)
            client.admin.command('ping')
            self.client = client
            self.db = client[settings.DB_NAME]
            self.is_mongo = True
            print("[DB] Connected successfully to MongoDB server.")
        except (ServerSelectionTimeoutError, ConnectionFailure, Exception) as e:
            print(f"[DB] MongoDB server unavailable ({e}). Using persistent local document store at {STORE_FILE}.")
            self.is_mongo = False
            self.db = self.local_store

    def get_collection(self, name: str):
        return self.db[name]

    def status(self) -> dict:
        return {
            "engine": "MongoDB" if self.is_mongo else "PersistentDocumentStore",
            "connected": True,
            "storage_path": None if self.is_mongo else STORE_FILE
        }

db_manager = DatabaseManager()

def get_db():
    return db_manager.db

def get_collection(name: str):
    return db_manager.get_collection(name)
