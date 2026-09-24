from datetime import datetime, timezone
import uuid
from database import get_collection
from auth import hash_password

def seed_database():
    users_col = get_collection("users")
    drives_col = get_collection("mock_drives")
    coding_col = get_collection("coding_questions")
    gd_col = get_collection("gd_topics")
    hr_col = get_collection("hr_questions")
    attempts_col = get_collection("interview_attempts")
    final_results_col = get_collection("final_results")

    # 1. Seed Users
    if users_col.count_documents({}) == 0:
        print("[SEED] Seeding demo users...")
        now = datetime.now(timezone.utc).isoformat()
        users = [
            {
                "_id": "user-student-1",
                "email": "student@demo.com",
                "password_hash": hash_password("password123"),
                "name": "Aditya Sharma",
                "role": "student",
                "college": "National Institute of Technology",
                "avatar": "https://api.dicebear.com/7.x/avataaars/svg?seed=Aditya",
                "created_at": now
            },
            {
                "_id": "user-interviewer-1",
                "email": "interviewer@demo.com",
                "password_hash": hash_password("password123"),
                "name": "Dr. Priya Nair",
                "role": "interviewer",
                "college": "Placement Director & Corporate Relations",
                "avatar": "https://api.dicebear.com/7.x/avataaars/svg?seed=Priya",
                "created_at": now
            },
            {
                "_id": "user-student-2",
                "email": "arun@demo.com",
                "password_hash": hash_password("password123"),
                "name": "Arun Kumar",
                "role": "student",
                "college": "Delhi Technological University",
                "avatar": "https://api.dicebear.com/7.x/avataaars/svg?seed=Arun",
                "created_at": now
            },
            {
                "_id": "user-student-3",
                "email": "sneha@demo.com",
                "password_hash": hash_password("password123"),
                "name": "Sneha Patel",
                "role": "student",
                "college": "RV College of Engineering",
                "avatar": "https://api.dicebear.com/7.x/avataaars/svg?seed=Sneha",
                "created_at": now
            }
        ]
        for u in users:
            users_col.insert_one(u)

    # 2. Seed Coding Questions
    if coding_col.count_documents({}) == 0:
        print("[SEED] Seeding coding questions...")
        coding_questions = [
            {
                "_id": "q-two-sum",
                "id": "two_sum",
                "title": "Two Sum",
                "difficulty": "Easy",
                "category": "Arrays & Hash Tables",
                "description": "Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target. You may assume that each input would have exactly one solution, and you may not use the same element twice.",
                "constraints": [
                    "2 <= nums.length <= 10^4",
                    "-10^9 <= nums[i] <= 10^9",
                    "-10^9 <= target <= 10^9",
                    "Only one valid answer exists."
                ],
                "examples": [
                    {
                        "input": "nums = [2,7,11,15], target = 9",
                        "output": "[0,1]",
                        "explanation": "Because nums[0] + nums[1] == 9, we return [0, 1]."
                    },
                    {
                        "input": "nums = [3,2,4], target = 6",
                        "output": "[1,2]",
                        "explanation": "Because nums[1] + nums[2] == 6, we return [1, 2]."
                    }
                ],
                "starter_templates": {
                    "python": "def twoSum(nums: list[int], target: int) -> list[int]:\n    # Implement your solution\n    seen = {}\n    for i, num in enumerate(nums):\n        complement = target - num\n        if complement in seen:\n            return [seen[complement], i]\n        seen[num] = i\n    return []\n",
                    "javascript": "function twoSum(nums, target) {\n    // Implement your solution\n    const seen = new Map();\n    for (let i = 0; i < nums.length; i++) {\n        const comp = target - nums[i];\n        if (seen.has(comp)) return [seen.get(comp), i];\n        seen.set(nums[i], i);\n    }\n    return [];\n}\n",
                    "java": "class Solution {\n    public int[] twoSum(int[] nums, int target) {\n        // Implement your solution\n        return new int[]{};\n    }\n}\n",
                    "cpp": "#include <vector>\nusing namespace std;\n\nclass Solution {\npublic:\n    vector<int> twoSum(vector<int>& nums, int target) {\n        // Implement solution\n        return {};\n    }\n};\n"
                },
                "test_cases": [
                    {
                        "id": "tc1",
                        "input": "[2, 7, 11, 15], 9",
                        "expected_output": "[0, 1]",
                        "is_hidden": False
                    },
                    {
                        "id": "tc2",
                        "input": "[3, 2, 4], 6",
                        "expected_output": "[1, 2]",
                        "is_hidden": False
                    },
                    {
                        "id": "tc3",
                        "input": "[3, 3], 6",
                        "expected_output": "[0, 1]",
                        "is_hidden": True
                    }
                ]
            },
            {
                "_id": "q-reverse-string",
                "id": "reverse_string",
                "title": "Reverse a String",
                "difficulty": "Easy",
                "category": "Strings",
                "description": "Write a function that reverses an input string of characters. You must return the reversed string.",
                "constraints": [
                    "1 <= s.length <= 10^5",
                    "s consists of printable ASCII characters."
                ],
                "examples": [
                    {
                        "input": "s = \"hello\"",
                        "output": "\"olleh\"",
                        "explanation": "Characters reversed."
                    },
                    {
                        "input": "s = \"InterviewX\"",
                        "output": "\"XweivretnI\"",
                        "explanation": "Preserves case when reversed."
                    }
                ],
                "starter_templates": {
                    "python": "def reverseString(s: str) -> str:\n    # Implement your solution\n    return s[::-1]\n",
                    "javascript": "function reverseString(s) {\n    // Implement your solution\n    return s.split('').reverse().join('');\n}\n",
                    "java": "class Solution {\n    public String reverseString(String s) {\n        return new StringBuilder(s).reverse().toString();\n    }\n}\n",
                    "cpp": "#include <string>\n#include <algorithm>\nusing namespace std;\n\nstring reverseString(string s) {\n    reverse(s.begin(), s.end());\n    return s;\n}\n"
                },
                "test_cases": [
                    {
                        "id": "tc1",
                        "input": "\"hello\"",
                        "expected_output": "\"olleh\"",
                        "is_hidden": False
                    },
                    {
                        "id": "tc2",
                        "input": "\"InterviewX\"",
                        "expected_output": "\"XweivretnI\"",
                        "is_hidden": False
                    },
                    {
                        "id": "tc3",
                        "input": "\"racecar\"",
                        "expected_output": "\"racecar\"",
                        "is_hidden": True
                    }
                ]
            },
            {
                "_id": "q-max-subarray",
                "id": "max_subarray",
                "title": "Find Maximum Subarray",
                "difficulty": "Medium",
                "category": "Dynamic Programming",
                "description": "Given an integer array nums, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.",
                "constraints": [
                    "1 <= nums.length <= 10^5",
                    "-10^4 <= nums[i] <= 10^4"
                ],
                "examples": [
                    {
                        "input": "nums = [-2,1,-3,4,-1,2,1,-5,4]",
                        "output": "6",
                        "explanation": "[4,-1,2,1] has the largest sum = 6."
                    },
                    {
                        "input": "nums = [1]",
                        "output": "1",
                        "explanation": "Single element."
                    }
                ],
                "starter_templates": {
                    "python": "def maxSubArray(nums: list[int]) -> int:\n    # Kadane's algorithm\n    max_current = max_global = nums[0]\n    for i in range(1, len(nums)):\n        max_current = max(nums[i], max_current + nums[i])\n        if max_current > max_global:\n            max_global = max_current\n    return max_global\n",
                    "javascript": "function maxSubArray(nums) {\n    let cur = nums[0], max = nums[0];\n    for (let i = 1; i < nums.length; i++) {\n        cur = Math.max(nums[i], cur + nums[i]);\n        max = Math.max(max, cur);\n    }\n    return max;\n}\n",
                    "java": "class Solution {\n    public int maxSubArray(int[] nums) {\n        // Kadane's algorithm\n        return 0;\n    }\n}\n",
                    "cpp": "#include <vector>\n#include <algorithm>\nusing namespace std;\n\nint maxSubArray(vector<int>& nums) {\n    return 0;\n}\n"
                },
                "test_cases": [
                    {
                        "id": "tc1",
                        "input": "[-2, 1, -3, 4, -1, 2, 1, -5, 4]",
                        "expected_output": "6",
                        "is_hidden": False
                    },
                    {
                        "id": "tc2",
                        "input": "[1]",
                        "expected_output": "1",
                        "is_hidden": False
                    },
                    {
                        "id": "tc3",
                        "input": "[5, 4, -1, 7, 8]",
                        "expected_output": "23",
                        "is_hidden": True
                    }
                ]
            }
        ]
        for q in coding_questions:
            coding_col.insert_one(q)

    # 3. Seed GD Topics
    if gd_col.count_documents({}) == 0:
        print("[SEED] Seeding GD topics...")
        gd_topics = [
            {
                "_id": "gd-ai-jobs",
                "title": "Will Artificial Intelligence replace traditional jobs?",
                "category": "Technology & Economy",
                "description": "Examine how rapid advancements in Generative AI, machine automation, and algorithmic reasoning impact entry-level knowledge work, software development, and traditional industries.",
                "prep_time_seconds": 60,
                "discussion_time_seconds": 180,
                "key_discussion_points": [
                    "Productivity boost vs routine labor displacement",
                    "Evolution of required skill sets (prompt engineering, systems design)",
                    "Historical parallels with previous industrial revolutions",
                    "Ethical, social, and economic safety nets"
                ],
                "simulated_peers": [
                    {
                        "id": "peer-1",
                        "name": "Rohan Deshmukh",
                        "avatar": "https://api.dicebear.com/7.x/avataaars/svg?seed=Rohan",
                        "stance": "Balanced",
                        "message": "I believe AI will augment rather than outright eliminate workers. Routine repetitive tasks get automated, freeing human engineers to focus on architecture, product intuition, and security.",
                        "delay_seconds": 5
                    },
                    {
                        "id": "peer-2",
                        "name": "Meera Swaminathan",
                        "avatar": "https://api.dicebear.com/7.x/avataaars/svg?seed=Meera",
                        "stance": "Cautionary",
                        "message": "While high-level creativity remains human, we must acknowledge the immediate displacement in customer support, junior documentation, and entry-level programming roles. Reskilling is essential.",
                        "delay_seconds": 18
                    },
                    {
                        "id": "peer-3",
                        "name": "Vikram Sen",
                        "avatar": "https://api.dicebear.com/7.x/avataaars/svg?seed=Vikram",
                        "stance": "Optimistic",
                        "message": "Every technological revolution created more net employment than it destroyed. AI will birth entirely new career sectors in safety validation, synthetic data, and AI-assisted healthcare.",
                        "delay_seconds": 32
                    }
                ]
            },
            {
                "_id": "gd-remote-work",
                "title": "Remote Work vs Return to Office: Future of Corporate Productivity",
                "category": "Workplace Culture",
                "description": "Debate the long-term sustainability of remote and hybrid work models versus mandatory return-to-office mandates in modern tech conglomerates.",
                "prep_time_seconds": 60,
                "discussion_time_seconds": 180,
                "key_discussion_points": [
                    "Individual focus time vs spontaneous collaboration",
                    "Mental wellness and commuting fatigue",
                    "Mentorship deficits for fresh college graduates in remote setups"
                ],
                "simulated_peers": [
                    {
                        "id": "peer-4",
                        "name": "Tanvi Joshi",
                        "avatar": "https://api.dicebear.com/7.x/avataaars/svg?seed=Tanvi",
                        "stance": "Hybrid",
                        "message": "A strict binary misses the point. Hybrid workflows offer focused coding days at home alongside collaborative whiteboarding sprints in the office.",
                        "delay_seconds": 8
                    }
                ]
            }
        ]
        for gd in gd_topics:
            gd_col.insert_one(gd)

    # 4. Seed HR Questions
    if hr_col.count_documents({}) == 0:
        print("[SEED] Seeding HR questions...")
        hr_questions = [
            {
                "_id": "hr-q1",
                "question": "Tell me about yourself and your academic background.",
                "category": "Introduction",
                "tips": "Deliver a 90-second elevator pitch covering education, core projects, passion for engineering, and what drives you."
            },
            {
                "_id": "hr-q2",
                "question": "Why should our company hire you over other qualified candidates?",
                "category": "Fitment & Value",
                "tips": "Align your practical problem-solving mindset, fast learning curve, and collaborative team ethics with company values."
            },
            {
                "_id": "hr-q3",
                "question": "Explain your strongest technical project and your key contribution.",
                "category": "Technical Showcase",
                "tips": "Use the STAR method: Situation, Task, Action (technologies utilized), and measurable Results."
            },
            {
                "_id": "hr-q4",
                "question": "What are your primary technical and interpersonal strengths?",
                "category": "Self-Awareness",
                "tips": "Back up each strength with a tangible anecdote from college team hackathons or academic assignments."
            },
            {
                "_id": "hr-q5",
                "question": "What is one weakness or area of improvement you are actively working on?",
                "category": "Constructive Growth",
                "tips": "Choose a genuine skill gap and immediately highlight the concrete steps, courses, or habits you take to conquer it."
            },
            {
                "_id": "hr-q6",
                "question": "Where do you see yourself in five years within the software industry?",
                "category": "Vision & Ambition",
                "tips": "Emphasize mastering full-stack system architecture, driving engineering excellence, and mentoring junior engineers."
            }
        ]
        for hr in hr_questions:
            hr_col.insert_one(hr)

    # 5. Seed Mock Drives
    if drives_col.count_documents({}) == 0:
        print("[SEED] Seeding Mock Drives...")
        now = datetime.now(timezone.utc).isoformat()
        drives = [
            {
                "_id": "drive-tcs-1",
                "company": "TCS",
                "role": "Software Developer",
                "description": "Flagship mock recruitment simulation replicating TCS Digital / Prime campus recruitment with DSA algorithmic rounds, technological Group Discussion, and behavioral HR panel interview.",
                "difficulty": "Medium",
                "duration_mins": 60,
                "status": "active",
                "rounds": {
                    "coding": True,
                    "gd": True,
                    "hr": True
                },
                "coding_question_ids": ["q-two-sum", "q-reverse-string", "q-max-subarray"],
                "gd_topic_id": "gd-ai-jobs",
                "hr_question_ids": ["hr-q1", "hr-q2", "hr-q3", "hr-q4", "hr-q5", "hr-q6"],
                "candidates_count": 18,
                "created_at": now
            },
            {
                "_id": "drive-infosys-1",
                "company": "Infosys",
                "role": "Graduate Engineer",
                "description": "Comprehensive corporate drive simulation for Specialist Programmer and Digital Specialist Engineer roles focusing on arrays, data transformations, and workplace readiness.",
                "difficulty": "Easy",
                "duration_mins": 45,
                "status": "active",
                "rounds": {
                    "coding": True,
                    "gd": True,
                    "hr": True
                },
                "coding_question_ids": ["q-reverse-string", "q-two-sum"],
                "gd_topic_id": "gd-remote-work",
                "hr_question_ids": ["hr-q1", "hr-q2", "hr-q3", "hr-q4"],
                "candidates_count": 24,
                "created_at": now
            },
            {
                "_id": "drive-zoho-1",
                "company": "Zoho",
                "role": "Software Engineer",
                "description": "Product engineering assessment emphasizing optimal algorithms, deep technical problem solving, structured group arguments, and architectural design defense.",
                "difficulty": "Hard",
                "duration_mins": 75,
                "status": "active",
                "rounds": {
                    "coding": True,
                    "gd": True,
                    "hr": True
                },
                "coding_question_ids": ["q-two-sum", "q-max-subarray"],
                "gd_topic_id": "gd-ai-jobs",
                "hr_question_ids": ["hr-q1", "hr-q3", "hr-q5", "hr-q6"],
                "candidates_count": 12,
                "created_at": now
            }
        ]
        for d in drives:
            drives_col.insert_one(d)

    # 6. Seed Realistic Candidate Attempts for Interviewer Dashboard & Analytics
    if attempts_col.count_documents({}) == 0:
        print("[SEED] Seeding candidate attempts for realistic dashboard...")
        now = datetime.now(timezone.utc).isoformat()
        sample_attempts = [
            {
                "_id": "attempt-arun-tcs",
                "user_id": "user-student-2",
                "drive_id": "drive-tcs-1",
                "current_round": "completed",
                "status": "completed",
                "progress_percentage": 100,
                "rounds_status": {"coding": "completed", "gd": "completed", "hr": "completed"},
                "round_scores": {"coding": 85, "gd": 76, "hr": 82},
                "overall_score": 81,
                "started_at": now,
                "completed_at": now
            },
            {
                "_id": "attempt-sneha-tcs",
                "user_id": "user-student-3",
                "drive_id": "drive-tcs-1",
                "current_round": "hr",
                "status": "in_progress",
                "progress_percentage": 75,
                "rounds_status": {"coding": "completed", "gd": "completed", "hr": "current"},
                "round_scores": {"coding": 90, "gd": 80, "hr": None},
                "overall_score": None,
                "started_at": now,
                "completed_at": None
            }
        ]
        for att in sample_attempts:
            attempts_col.insert_one(att)

        # Final result for completed attempt
        final_results_col.insert_one({
            "_id": "final-arun-tcs",
            "attempt_id": "attempt-arun-tcs",
            "user_id": "user-student-2",
            "drive_id": "drive-tcs-1",
            "overall_score": 81,
            "coding_score": 85,
            "gd_score": 76,
            "hr_score": 82,
            "weighting": {"coding": 0.40, "gd": 0.25, "hr": 0.35},
            "status": "completed",
            "strengths": [
                "Exceptional time and space complexity efficiency in algorithmic coding.",
                "Assertive, clear communication style during collaborative group discussion.",
                "Well-structured project storytelling aligning with corporate requirements."
            ],
            "areas_for_improvement": [
                "Incorporate more statistical benchmarks when arguing economic topics.",
                "Quantify project metric achievements using STAR framework."
            ],
            "recommended_practice_areas": [
                "Dynamic Programming Subarrays",
                "STAR Behavioral Answering",
                "Executive Summary Synthesis"
            ],
            "completed_at": now
        })
        print("[SEED] Database seeding complete!")

if __name__ == "__main__":
    seed_database()
