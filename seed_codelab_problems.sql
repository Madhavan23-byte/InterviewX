-- ========================================================
-- InterviewX CodeLab Striver Roadmap Problem Seed Script
-- Total Problems: 137
-- ========================================================
USE interviewx;

INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (1, 1, 'Largest Element in an Array', 'Arrays', 'Easy Array Problems', 'Easy', 'Given an array of integers nums, find the largest element in the array.', 'Input: nums = [2, 5, 1, 3, 0]
Output: 5
Explanation: 5 is the maximum element.', '1 <= nums.length <= 10^5
-10^9 <= nums[i] <= 10^9', 'Iterate and keep track of max element.', 'public class Solution {
    public int largestElement(int[] nums) {
        int max = nums[0];
        for (int x : nums) if (x > max) max = x;
        return max;
    }
}', 'class Solution:
    def largestElement(self, nums: list[int]) -> int:
        return max(nums)', 'class Solution {
public:
    int largestElement(vector<int>& nums) {
        return *max_element(nums.begin(), nums.end());
    }
};', 'function largestElement(nums) {
    return Math.max(...nums);
}', 'public class Solution {
    public int largestElement(int[] nums) {
        int max = nums[0];
        for (int x : nums) if (x > max) max = x;
        return max;
    }
}', '[{"input": "[2, 5, 1, 3, 0]", "expected": "5", "sample": true}, {"input": "[8, 10, 5, 7, 9]", "expected": "10", "sample": true}]', 'Arrays,Math', 'https://takeuforward.org/data-structure/find-the-largest-element-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (2, 2, 'Second Largest Element in an Array', 'Arrays', 'Easy Array Problems', 'Easy', 'Given an array nums, find the second largest and second smallest element without sorting.', 'Input: nums = [1, 2, 4, 7, 7, 5]
Output: 5
Explanation: Largest is 7, second largest is 5.', '2 <= nums.length <= 10^5
-10^9 <= nums[i] <= 10^9', 'Track max and second_max in a single traversal.', 'public class Solution {
    public int secondLargest(int[] nums) {
        int max = Integer.MIN_VALUE, second = Integer.MIN_VALUE;
        for (int x : nums) {
            if (x > max) { second = max; max = x; }
            else if (x > second && x != max) second = x;
        }
        return second == Integer.MIN_VALUE ? -1 : second;
    }
}', 'class Solution:
    def secondLargest(self, nums: list[int]) -> int:
        pass', 'class Solution {
public:
    int secondLargest(vector<int>& nums) {
        
    }
};', 'function secondLargest(nums) {
    
}', 'public class Solution {
    public int secondLargest(int[] nums) {
        int max = Integer.MIN_VALUE, second = Integer.MIN_VALUE;
        for (int x : nums) {
            if (x > max) { second = max; max = x; }
            else if (x > second && x != max) second = x;
        }
        return second == Integer.MIN_VALUE ? -1 : second;
    }
}', '[{"input": "[1, 2, 4, 7, 7, 5]", "expected": "5", "sample": true}, {"input": "[10, 10, 10]", "expected": "-1", "sample": true}]', 'Arrays', 'https://takeuforward.org/data-structure/find-second-smallest-and-second-largest-element-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (3, 3, 'Check if Array is Sorted', 'Arrays', 'Easy Array Problems', 'Easy', 'Given an array nums, check if it is sorted in non-decreasing order.', 'Input: nums = [1, 2, 3, 4, 5]
Output: true', '1 <= nums.length <= 10^5', 'Check if nums[i] <= nums[i+1] for all i.', 'public class Solution {
    public boolean isSorted(int[] nums) {
        for (int i = 0; i < nums.length - 1; i++) if (nums[i] > nums[i+1]) return false;
        return true;
    }
}', 'class Solution:
    def isSorted(self, nums: list[int]) -> bool:
        return all(nums[i] <= nums[i+1] for i in range(len(nums)-1))', 'class Solution {
public:
    bool isSorted(vector<int>& nums) {
        
    }
};', 'function isSorted(nums) {
    
}', 'public class Solution {
    public boolean isSorted(int[] nums) {
        for (int i = 0; i < nums.length - 1; i++) if (nums[i] > nums[i+1]) return false;
        return true;
    }
}', '[{"input": "[1, 2, 3, 4, 5]", "expected": "true", "sample": true}, {"input": "[5, 4, 6, 7, 8]", "expected": "false", "sample": true}]', 'Arrays', 'https://takeuforward.org/data-structure/check-if-an-array-is-sorted/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (4, 4, 'Remove Duplicates from Sorted Array', 'Arrays', 'Easy Array Problems', 'Easy', 'Given a sorted integer array nums, remove duplicates in-place such that each unique element appears once. Return k, the number of unique elements.', 'Input: nums = [1, 1, 2]
Output: 2, nums = [1, 2, _]', '1 <= nums.length <= 3 * 10^4', 'Two pointers: i marks the last unique element, j scans forward.', 'public class Solution {
    public int removeDuplicates(int[] nums) {
        if (nums.length == 0) return 0;
        int i = 0;
        for (int j = 1; j < nums.length; j++) {
            if (nums[j] != nums[i]) nums[++i] = nums[j];
        }
        return i + 1;
    }
}', 'class Solution:
    def removeDuplicates(self, nums: list[int]) -> int:
        pass', 'class Solution {
public:
    int removeDuplicates(vector<int>& nums) {
        
    }
};', 'function removeDuplicates(nums) {
    
}', 'public class Solution {
    public int removeDuplicates(int[] nums) {
        int i = 0;
        for (int j = 1; j < nums.length; j++) if (nums[j] != nums[i]) nums[++i] = nums[j];
        return i + 1;
    }
}', '[{"input": "[1, 1, 2]", "expected": "2", "sample": true}, {"input": "[0,0,1,1,1,2,2,3,3,4]", "expected": "5", "sample": true}]', 'Arrays,Two Pointers', 'https://takeuforward.org/data-structure/remove-duplicates-in-place-from-sorted-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (5, 5, 'Left Rotate Array by One', 'Arrays', 'Easy Array Problems', 'Easy', 'Given an array nums, rotate it to the left by one position.', 'Input: nums = [1, 2, 3, 4, 5]
Output: [2, 3, 4, 5, 1]', '1 <= nums.length <= 10^5', 'Store first element, shift all elements left, place first element at end.', 'public class Solution {
    public void rotateOne(int[] nums) {
        int temp = nums[0];
        for (int i = 1; i < nums.length; i++) nums[i - 1] = nums[i];
        nums[nums.length - 1] = temp;
    }
}', 'class Solution:
    def rotateOne(self, nums: list[int]) -> None:
        pass', 'class Solution {
public:
    void rotateOne(vector<int>& nums) {}
};', 'function rotateOne(nums) {}', 'public class Solution {
    public void rotateOne(int[] nums) {
        int temp = nums[0];
        for (int i = 1; i < nums.length; i++) nums[i - 1] = nums[i];
        nums[nums.length - 1] = temp;
    }
}', '[{"input": "[1, 2, 3, 4, 5]", "expected": "[2, 3, 4, 5, 1]", "sample": true}]', 'Arrays', 'https://takeuforward.org/data-structure/left-rotate-the-array-by-one/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (6, 6, 'Rotate Array by K Places', 'Arrays', 'Easy Array Problems', 'Medium', 'Rotate an integer array nums to the right by k steps.', 'Input: nums = [1,2,3,4,5,6,7], k = 3
Output: [5,6,7,1,2,3,4]', '1 <= nums.length <= 10^5
0 <= k <= 10^5', 'Reverse 0 to n-1, then 0 to k-1, then k to n-1.', 'public class Solution {
    public void rotate(int[] nums, int k) {
        int n = nums.length; k %= n;
        reverse(nums, 0, n - 1);
        reverse(nums, 0, k - 1);
        reverse(nums, k, n - 1);
    }
    private void reverse(int[] a, int l, int r) {
        while (l < r) { int t = a[l]; a[l++] = a[r]; a[r--] = t; }
    }
}', 'class Solution:
    def rotate(self, nums: list[int], k: int) -> None:
        pass', 'class Solution {
public:
    void rotate(vector<int>& nums, int k) {}
};', 'function rotate(nums, k) {}', 'public class Solution {
    public void rotate(int[] nums, int k) {
        int n = nums.length; k %= n;
        reverse(nums, 0, n - 1);
        reverse(nums, 0, k - 1);
        reverse(nums, k, n - 1);
    }
    private void reverse(int[] a, int l, int r) {
        while (l < r) { int t = a[l]; a[l++] = a[r]; a[r--] = t; }
    }
}', '[{"input": "[1,2,3,4,5,6,7], 3", "expected": "[5,6,7,1,2,3,4]", "sample": true}]', 'Arrays,Two Pointers', 'https://takeuforward.org/data-structure/rotate-array-by-k-elements/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (7, 7, 'Move Zeroes to End', 'Arrays', 'Easy Array Problems', 'Easy', 'Move all zeroes in array nums to end while maintaining relative order of non-zero elements.', 'Input: nums = [0,1,0,3,12]
Output: [1,3,12,0,0]', '1 <= nums.length <= 10^4', 'Find first zero pointer j, then swap with any non-zero i > j.', 'public class Solution {
    public void moveZeroes(int[] nums) {
        int j = 0;
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] != 0) {
                int t = nums[j]; nums[j++] = nums[i]; nums[i] = t;
            }
        }
    }
}', 'class Solution:
    def moveZeroes(self, nums: list[int]) -> None:
        pass', 'class Solution {
public:
    void moveZeroes(vector<int>& nums) {}
};', 'function moveZeroes(nums) {}', 'public class Solution {
    public void moveZeroes(int[] nums) {
        int j = 0;
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] != 0) {
                int t = nums[j]; nums[j++] = nums[i]; nums[i] = t;
            }
        }
    }
}', '[{"input": "[0,1,0,3,12]", "expected": "[1,3,12,0,0]", "sample": true}]', 'Arrays,Two Pointers', 'https://takeuforward.org/data-structure/move-all-zeros-to-the-end-of-the-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (8, 8, 'Linear Search', 'Arrays', 'Easy Array Problems', 'Easy', 'Given an array nums and key k, find the first 0-based index of k, or -1 if not found.', 'Input: nums = [1, 2, 3, 4, 5], k = 3
Output: 2', '1 <= nums.length <= 10^5', 'Loop and compare each element.', 'public class Solution {
    public int linearSearch(int[] nums, int k) {
        for (int i = 0; i < nums.length; i++) if (nums[i] == k) return i;
        return -1;
    }
}', 'class Solution:
    def linearSearch(self, nums: list[int], k: int) -> int:
        return nums.index(k) if k in nums else -1', 'class Solution {
public:
    int linearSearch(vector<int>& nums, int k) {
        for (int i = 0; i < nums.size(); i++) if (nums[i] == k) return i;
        return -1;
    }
};', 'function linearSearch(nums, k) {
    return nums.indexOf(k);
}', 'public class Solution {
    public int linearSearch(int[] nums, int k) {
        for (int i = 0; i < nums.length; i++) if (nums[i] == k) return i;
        return -1;
    }
}', '[{"input": "[1, 2, 3, 4, 5], 3", "expected": "2", "sample": true}, {"input": "[5, 4, 3, 2, 1], 6", "expected": "-1", "sample": true}]', 'Arrays', 'https://takeuforward.org/data-structure/linear-search-in-c/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (9, 9, 'Find Union of Two Sorted Arrays', 'Arrays', 'Easy Array Problems', 'Medium', 'Given two sorted arrays nums1 and nums2, return their union as a sorted list of unique elements.', 'Input: nums1 = [1, 2, 3, 4, 5], nums2 = [2, 3, 4, 4, 5, 6]
Output: [1, 2, 3, 4, 5, 6]', '1 <= nums1.length, nums2.length <= 10^5', 'Two pointers merge while skipping duplicate insertions.', 'public class Solution {
    public java.util.List<Integer> findUnion(int[] a, int[] b) {
        java.util.List<Integer> res = new java.util.ArrayList<>();
        int i = 0, j = 0;
        while (i < a.length || j < b.length) {
            int val;
            if (i < a.length && (j >= b.length || a[i] <= b[j])) {
                val = a[i++]; if (j < b.length && b[j] == val) j++;
            } else val = b[j++];
            if (res.isEmpty() || res.get(res.size() - 1) != val) res.add(val);
        }
        return res;
    }
}', 'class Solution:
    def findUnion(self, a: list[int], b: list[int]) -> list[int]:
        pass', 'class Solution {
public:
    vector<int> findUnion(vector<int>& a, vector<int>& b) {
        
    }
};', 'function findUnion(a, b) {
    
}', 'public class Solution {
    public java.util.List<Integer> findUnion(int[] a, int[] b) {
        java.util.List<Integer> res = new java.util.ArrayList<>();
        int i = 0, j = 0;
        while (i < a.length || j < b.length) {
            int val;
            if (i < a.length && (j >= b.length || a[i] <= b[j])) {
                val = a[i++]; if (j < b.length && b[j] == val) j++;
            } else val = b[j++];
            if (res.isEmpty() || res.get(res.size() - 1) != val) res.add(val);
        }
        return res;
    }
}', '[{"input": "[1, 2, 3, 4, 5], [2, 3, 4, 4, 5, 6]", "expected": "[1, 2, 3, 4, 5, 6]", "sample": true}]', 'Arrays,Two Pointers', 'https://takeuforward.org/data-structure/union-of-two-sorted-arrays/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (10, 10, 'Find Missing Number in Array', 'Arrays', 'Easy Array Problems', 'Easy', 'Given array nums containing n distinct numbers in range [0, n], return the only missing number.', 'Input: nums = [3,0,1]
Output: 2', 'n == nums.length
1 <= n <= 10^4', 'Sum of 0..n is n*(n+1)/2. Subtract elements or XOR.', 'public class Solution {
    public int missingNumber(int[] nums) {
        int n = nums.length, sum = n * (n + 1) / 2;
        for (int x : nums) sum -= x;
        return sum;
    }
}', 'class Solution:
    def missingNumber(self, nums: list[int]) -> int:
        n = len(nums)
        return n * (n + 1) // 2 - sum(nums)', 'class Solution {
public:
    int missingNumber(vector<int>& nums) {
        int n = nums.size(), sum = n * (n + 1) / 2;
        for (int x : nums) sum -= x;
        return sum;
    }
};', 'function missingNumber(nums) {
    let n = nums.length;
    return n * (n + 1) / 2 - nums.reduce((a, b) => a + b, 0);
}', 'public class Solution {
    public int missingNumber(int[] nums) {
        int n = nums.length, sum = n * (n + 1) / 2;
        for (int x : nums) sum -= x;
        return sum;
    }
}', '[{"input": "[3,0,1]", "expected": "2", "sample": true}, {"input": "[0,1]", "expected": "2", "sample": true}]', 'Arrays,Math', 'https://takeuforward.org/arrays/find-the-missing-number-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (11, 11, 'Maximum Consecutive Ones', 'Arrays', 'Easy Array Problems', 'Easy', 'Given a binary array nums, return maximum number of consecutive 1s.', 'Input: nums = [1,1,0,1,1,1]
Output: 3', '1 <= nums.length <= 10^5
nums[i] is 0 or 1', 'Count 1s, reset on 0, track max.', 'public class Solution {
    public int findMaxConsecutiveOnes(int[] nums) {
        int max = 0, cur = 0;
        for (int x : nums) {
            if (x == 1) max = Math.max(max, ++cur);
            else cur = 0;
        }
        return max;
    }
}', 'class Solution:
    def findMaxConsecutiveOnes(self, nums: list[int]) -> int:
        pass', 'class Solution {
public:
    int findMaxConsecutiveOnes(vector<int>& nums) {}
};', 'function findMaxConsecutiveOnes(nums) {}', 'public class Solution {
    public int findMaxConsecutiveOnes(int[] nums) {
        int max = 0, cur = 0;
        for (int x : nums) {
            if (x == 1) max = Math.max(max, ++cur);
            else cur = 0;
        }
        return max;
    }
}', '[{"input": "[1,1,0,1,1,1]", "expected": "3", "sample": true}]', 'Arrays', 'https://takeuforward.org/data-structure/count-maximum-consecutive-ones-in-the-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (12, 12, 'Single Number', 'Arrays', 'Easy Array Problems', 'Easy', 'Every element appears twice except for one. Find that single one in O(n) time and O(1) space.', 'Input: nums = [4,1,2,1,2]
Output: 4', '1 <= nums.length <= 3 * 10^4', 'XOR all elements together.', 'public class Solution {
    public int singleNumber(int[] nums) {
        int xor = 0;
        for (int x : nums) xor ^= x;
        return xor;
    }
}', 'class Solution:
    def singleNumber(self, nums: list[int]) -> int:
        r = 0
        for x in nums: r ^= x
        return r', 'class Solution {
public:
    int singleNumber(vector<int>& nums) {
        int r = 0; for (int x : nums) r ^= x; return r;
    }
};', 'function singleNumber(nums) {
    return nums.reduce((a, b) => a ^ b, 0);
}', 'public class Solution {
    public int singleNumber(int[] nums) {
        int xor = 0;
        for (int x : nums) xor ^= x;
        return xor;
    }
}', '[{"input": "[4,1,2,1,2]", "expected": "4", "sample": true}, {"input": "[2,2,1]", "expected": "1", "sample": true}]', 'Arrays,Bit Manipulation', 'https://takeuforward.org/arrays/find-the-number-that-appears-once-and-the-other-numbers-twice/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (13, 13, 'Two Sum', 'Arrays', 'Medium Array Problems', 'Easy', 'Given array of integers nums and target, return indices of two numbers that add up to target.', 'Input: nums = [2,7,11,15], target = 9
Output: [0,1]', '2 <= nums.length <= 10^4', 'HashMap stores complement -> index.', 'public class Solution {
    public int[] twoSum(int[] nums, int target) {
        java.util.Map<Integer, Integer> map = new java.util.HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int comp = target - nums[i];
            if (map.containsKey(comp)) return new int[]{map.get(comp), i};
            map.put(nums[i], i);
        }
        return new int[]{};
    }
}', 'class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        seen = {}
        for i, x in enumerate(nums):
            if target - x in seen: return [seen[target - x], i]
            seen[x] = i
        return []', 'class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int, int> m;
        for (int i = 0; i < nums.size(); i++) {
            if (m.count(target - nums[i])) return {m[target - nums[i]], i};
            m[nums[i]] = i;
        }
        return {};
    }
};', 'function twoSum(nums, target) {
    let m = new Map();
    for (let i = 0; i < nums.length; i++) {
        if (m.has(target - nums[i])) return [m.get(target - nums[i]), i];
        m.set(nums[i], i);
    }
    return [];
}', 'public class Solution {
    public int[] twoSum(int[] nums, int target) {
        java.util.Map<Integer, Integer> map = new java.util.HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int comp = target - nums[i];
            if (map.containsKey(comp)) return new int[]{map.get(comp), i};
            map.put(nums[i], i);
        }
        return new int[]{};
    }
}', '[{"input": "[2,7,11,15], 9", "expected": "[0,1]", "sample": true}, {"input": "[3,2,4], 6", "expected": "[1,2]", "sample": true}]', 'Arrays,HashMap', 'https://takeuforward.org/data-structure/two-sum-check-if-a-pair-with-given-sum-exists-in-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (14, 14, 'Sort Colors (0s, 1s, 2s)', 'Arrays', 'Medium Array Problems', 'Medium', 'Sort array with 0s, 1s, 2s in-place (Dutch National Flag algorithm).', 'Input: nums = [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]', '1 <= nums.length <= 300', 'Three pointers: low, mid, high. Swap 0s to low, 2s to high.', 'public class Solution {
    public void sortColors(int[] nums) {
        int low = 0, mid = 0, high = nums.length - 1;
        while (mid <= high) {
            if (nums[mid] == 0) {
                int t = nums[low]; nums[low++] = nums[mid]; nums[mid++] = t;
            } else if (nums[mid] == 1) mid++;
            else {
                int t = nums[mid]; nums[mid] = nums[high]; nums[high--] = t;
            }
        }
    }
}', 'class Solution:
    def sortColors(self, nums: list[int]) -> None:
        pass', 'class Solution {
public:
    void sortColors(vector<int>& nums) {}
};', 'function sortColors(nums) {}', 'public class Solution {
    public void sortColors(int[] nums) {
        int low = 0, mid = 0, high = nums.length - 1;
        while (mid <= high) {
            if (nums[mid] == 0) {
                int t = nums[low]; nums[low++] = nums[mid]; nums[mid++] = t;
            } else if (nums[mid] == 1) mid++;
            else {
                int t = nums[mid]; nums[mid] = nums[high]; nums[high--] = t;
            }
        }
    }
}', '[{"input": "[2,0,2,1,1,0]", "expected": "[0,0,1,1,2,2]", "sample": true}]', 'Arrays,Two Pointers,Sorting', 'https://takeuforward.org/data-structure/sort-an-array-of-0s-1s-and-2s/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (15, 15, 'Majority Element (> N/2 times)', 'Arrays', 'Medium Array Problems', 'Easy', 'Find the element that appears strictly more than n / 2 times.', 'Input: nums = [3,2,3]
Output: 3', '1 <= nums.length <= 5 * 10^4', 'Boyer-Moore voting algorithm.', 'public class Solution {
    public int majorityElement(int[] nums) {
        int cand = 0, count = 0;
        for (int x : nums) {
            if (count == 0) cand = x;
            count += (x == cand ? 1 : -1);
        }
        return cand;
    }
}', 'class Solution:
    def majorityElement(self, nums: list[int]) -> int:
        pass', 'class Solution {
public:
    int majorityElement(vector<int>& nums) {}
};', 'function majorityElement(nums) {}', 'public class Solution {
    public int majorityElement(int[] nums) {
        int cand = 0, count = 0;
        for (int x : nums) {
            if (count == 0) cand = x;
            count += (x == cand ? 1 : -1);
        }
        return cand;
    }
}', '[{"input": "[3,2,3]", "expected": "3", "sample": true}, {"input": "[2,2,1,1,1,2,2]", "expected": "2", "sample": true}]', 'Arrays,Math', 'https://takeuforward.org/data-structure/find-the-majority-element-that-occurs-more-than-n-2-times/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (16, 16, 'Maximum Subarray Sum (Kadane''s)', 'Arrays', 'Medium Array Problems', 'Medium', 'Find subarray with largest sum and return its sum.', 'Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6', '1 <= nums.length <= 10^5', 'Add to running sum, reset if < 0, track max.', 'public class Solution {
    public int maxSubArray(int[] nums) {
        int max = nums[0], sum = 0;
        for (int x : nums) {
            sum += x;
            if (sum > max) max = sum;
            if (sum < 0) sum = 0;
        }
        return max;
    }
}', 'class Solution:
    def maxSubArray(self, nums: list[int]) -> int:
        pass', 'class Solution {
public:
    int maxSubArray(vector<int>& nums) {}
};', 'function maxSubArray(nums) {}', 'public class Solution {
    public int maxSubArray(int[] nums) {
        int max = nums[0], sum = 0;
        for (int x : nums) {
            sum += x;
            if (sum > max) max = sum;
            if (sum < 0) sum = 0;
        }
        return max;
    }
}', '[{"input": "[-2,1,-3,4,-1,2,1,-5,4]", "expected": "6", "sample": true}]', 'Arrays,Dynamic Programming,Kadane', 'https://takeuforward.org/data-structure/kadanes-algorithm-maximum-subarray-sum-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (17, 17, 'Rearrange Array Elements by Sign', 'Arrays', 'Medium Array Problems', 'Medium', 'Rearrange array with equal positive/negative numbers alternately, starting with positive.', 'Input: nums = [3,1,-2,-5,2,-4]
Output: [3,-2,1,-5,2,-4]', '2 <= nums.length <= 2 * 10^5', 'Use two pointer indices: pos = 0, neg = 1.', 'public class Solution {
    public int[] rearrangeArray(int[] nums) {
        int[] ans = new int[nums.length];
        int p = 0, n = 1;
        for (int x : nums) {
            if (x > 0) { ans[p] = x; p += 2; }
            else { ans[n] = x; n += 2; }
        }
        return ans;
    }
}', 'class Solution:
    def rearrangeArray(self, nums: list[int]) -> list[int]:
        pass', 'class Solution {
public:
    vector<int> rearrangeArray(vector<int>& nums) {}
};', 'function rearrangeArray(nums) {}', 'public class Solution {
    public int[] rearrangeArray(int[] nums) {
        int[] ans = new int[nums.length];
        int p = 0, n = 1;
        for (int x : nums) {
            if (x > 0) { ans[p] = x; p += 2; }
            else { ans[n] = x; n += 2; }
        }
        return ans;
    }
}', '[{"input": "[3,1,-2,-5,2,-4]", "expected": "[3,-2,1,-5,2,-4]", "sample": true}]', 'Arrays,Two Pointers', 'https://takeuforward.org/arrays/rearrange-array-elements-by-sign/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (18, 18, 'Next Permutation', 'Arrays', 'Medium Array Problems', 'Medium', 'Rearrange numbers into lexicographically next greater permutation of numbers.', 'Input: nums = [1,2,3]
Output: [1,3,2]', '1 <= nums.length <= 100', 'Find breakpoint nums[i] < nums[i+1], swap with next greater from right, reverse suffix.', 'public class Solution {
    public void nextPermutation(int[] nums) {
        int n = nums.length, i = n - 2;
        while (i >= 0 && nums[i] >= nums[i+1]) i--;
        if (i >= 0) {
            int j = n - 1;
            while (nums[j] <= nums[i]) j--;
            int t = nums[i]; nums[i] = nums[j]; nums[j] = t;
        }
        int l = i + 1, r = n - 1;
        while (l < r) {
            int t = nums[l]; nums[l++] = nums[r]; nums[r--] = t;
        }
    }
}', 'class Solution:
    def nextPermutation(self, nums: list[int]) -> None:
        pass', 'class Solution {
public:
    void nextPermutation(vector<int>& nums) {}
};', 'function nextPermutation(nums) {}', 'public class Solution {
    public void nextPermutation(int[] nums) {
        int n = nums.length, i = n - 2;
        while (i >= 0 && nums[i] >= nums[i+1]) i--;
        if (i >= 0) {
            int j = n - 1;
            while (nums[j] <= nums[i]) j--;
            int t = nums[i]; nums[i] = nums[j]; nums[j] = t;
        }
        int l = i + 1, r = n - 1;
        while (l < r) {
            int t = nums[l]; nums[l++] = nums[r]; nums[r--] = t;
        }
    }
}', '[{"input": "[1,2,3]", "expected": "[1,3,2]", "sample": true}, {"input": "[3,2,1]", "expected": "[1,2,3]", "sample": true}]', 'Arrays,Two Pointers', 'https://takeuforward.org/data-structure/next_permutation-find-next-lexicographically-greater-permutation/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (19, 19, 'Leaders in an Array', 'Arrays', 'Medium Array Problems', 'Easy', 'Find all elements greater than or equal to all elements to their right.', 'Input: nums = [10, 22, 12, 3, 0, 6]
Output: [22, 12, 6]', '1 <= nums.length <= 10^5', 'Scan from right to left keeping track of max seen so far.', 'public class Solution {
    public java.util.List<Integer> leaders(int[] nums) {
        java.util.List<Integer> ans = new java.util.ArrayList<>();
        int max = Integer.MIN_VALUE;
        for (int i = nums.length - 1; i >= 0; i--) {
            if (nums[i] >= max) { ans.add(nums[i]); max = nums[i]; }
        }
        java.util.Collections.reverse(ans);
        return ans;
    }
}', 'class Solution:
    def leaders(self, nums: list[int]) -> list[int]:
        pass', 'class Solution {
public:
    vector<int> leaders(vector<int>& nums) {}
};', 'function leaders(nums) {}', 'public class Solution {
    public java.util.List<Integer> leaders(int[] nums) {
        java.util.List<Integer> ans = new java.util.ArrayList<>();
        int max = Integer.MIN_VALUE;
        for (int i = nums.length - 1; i >= 0; i--) {
            if (nums[i] >= max) { ans.add(nums[i]); max = nums[i]; }
        }
        java.util.Collections.reverse(ans);
        return ans;
    }
}', '[{"input": "[10, 22, 12, 3, 0, 6]", "expected": "[22, 12, 6]", "sample": true}]', 'Arrays', 'https://takeuforward.org/data-structure/leaders-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (20, 20, 'Longest Consecutive Sequence', 'Arrays', 'Medium Array Problems', 'Medium', 'Return length of longest consecutive elements sequence in O(n) time.', 'Input: nums = [100,4,200,1,3,2]
Output: 4
Explanation: Sequence [1, 2, 3, 4].', '0 <= nums.length <= 10^5', 'Store in HashSet. For element x, check if x-1 is absent, then count forward.', 'public class Solution {
    public int longestConsecutive(int[] nums) {
        java.util.Set<Integer> set = new java.util.HashSet<>();
        for (int x : nums) set.add(x);
        int longest = 0;
        for (int x : set) {
            if (!set.contains(x - 1)) {
                int curr = x, count = 1;
                while (set.contains(curr + 1)) { curr++; count++; }
                longest = Math.max(longest, count);
            }
        }
        return longest;
    }
}', 'class Solution:
    def longestConsecutive(self, nums: list[int]) -> int:
        pass', 'class Solution {
public:
    int longestConsecutive(vector<int>& nums) {}
};', 'function longestConsecutive(nums) {}', 'public class Solution {
    public int longestConsecutive(int[] nums) {
        java.util.Set<Integer> set = new java.util.HashSet<>();
        for (int x : nums) set.add(x);
        int longest = 0;
        for (int x : set) {
            if (!set.contains(x - 1)) {
                int curr = x, count = 1;
                while (set.contains(curr + 1)) { curr++; count++; }
                longest = Math.max(longest, count);
            }
        }
        return longest;
    }
}', '[{"input": "[100,4,200,1,3,2]", "expected": "4", "sample": true}, {"input": "[0,3,7,2,5,8,4,6,0,1]", "expected": "9", "sample": true}]', 'Arrays,HashSet', 'https://takeuforward.org/data-structure/longest-consecutive-sequence-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (21, 21, 'Set Matrix Zeroes', 'Arrays', 'Medium Array Problems', 'Medium', 'If an element in matrix is 0, set its entire row and column to 0 in place.', 'Input: matrix = [[1,1,1],[1,0,1],[1,1,1]]
Output: [[1,0,1],[0,0,0],[1,0,1]]', '1 <= m, n <= 200', 'Use row 0 and col 0 as markers.', 'public class Solution {
    public void setZeroes(int[][] matrix) {
        int col0 = 1, rows = matrix.length, cols = matrix[0].length;
        for (int i = 0; i < rows; i++) {
            if (matrix[i][0] == 0) col0 = 0;
            for (int j = 1; j < cols; j++) if (matrix[i][j] == 0) { matrix[i][0] = 0; matrix[0][j] = 0; }
        }
        for (int i = rows - 1; i >= 0; i--) {
            for (int j = cols - 1; j >= 1; j--) if (matrix[i][0] == 0 || matrix[0][j] == 0) matrix[i][j] = 0;
            if (col0 == 0) matrix[i][0] = 0;
        }
    }
}', 'class Solution:
    def setZeroes(self, matrix: list[list[int]]) -> None:
        pass', 'class Solution {
public:
    void setZeroes(vector<vector<int>>& matrix) {}
};', 'function setZeroes(matrix) {}', 'public class Solution {
    public void setZeroes(int[][] matrix) {
        int col0 = 1, rows = matrix.length, cols = matrix[0].length;
        for (int i = 0; i < rows; i++) {
            if (matrix[i][0] == 0) col0 = 0;
            for (int j = 1; j < cols; j++) if (matrix[i][j] == 0) { matrix[i][0] = 0; matrix[0][j] = 0; }
        }
        for (int i = rows - 1; i >= 0; i--) {
            for (int j = cols - 1; j >= 1; j--) if (matrix[i][0] == 0 || matrix[0][j] == 0) matrix[i][j] = 0;
            if (col0 == 0) matrix[i][0] = 0;
        }
    }
}', '[{"input": "[[1,1,1],[1,0,1],[1,1,1]]", "expected": "[[1,0,1],[0,0,0],[1,0,1]]", "sample": true}]', 'Arrays,Matrix', 'https://takeuforward.org/data-structure/set-matrix-zero/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (22, 22, 'Rotate Matrix 90 Degrees Clockwise', 'Arrays', 'Medium Array Problems', 'Medium', 'Rotate an n x n 2D matrix clockwise by 90 degrees in-place.', 'Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [[7,4,1],[8,5,2],[9,6,3]]', '1 <= n <= 20', 'Transpose matrix, then reverse each row.', 'public class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        for (int i = 0; i < n; i++) for (int j = i; j < n; j++) {
            int t = matrix[i][j]; matrix[i][j] = matrix[j][i]; matrix[j][i] = t;
        }
        for (int i = 0; i < n; i++) for (int j = 0; j < n / 2; j++) {
            int t = matrix[i][j]; matrix[i][j] = matrix[i][n - 1 - j]; matrix[i][n - 1 - j] = t;
        }
    }
}', 'class Solution:
    def rotate(self, matrix: list[list[int]]) -> None:
        pass', 'class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {}
};', 'function rotate(matrix) {}', 'public class Solution {
    public void rotate(int[][] matrix) {
        int n = matrix.length;
        for (int i = 0; i < n; i++) for (int j = i; j < n; j++) {
            int t = matrix[i][j]; matrix[i][j] = matrix[j][i]; matrix[j][i] = t;
        }
        for (int i = 0; i < n; i++) for (int j = 0; j < n / 2; j++) {
            int t = matrix[i][j]; matrix[i][j] = matrix[i][n - 1 - j]; matrix[i][n - 1 - j] = t;
        }
    }
}', '[{"input": "[[1,2,3],[4,5,6],[7,8,9]]", "expected": "[[7,4,1],[8,5,2],[9,6,3]]", "sample": true}]', 'Arrays,Matrix', 'https://takeuforward.org/data-structure/rotate-image-by-90-degree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (23, 23, 'Spiral Matrix', 'Arrays', 'Medium Array Problems', 'Medium', 'Return all elements of matrix in spiral order.', 'Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [1,2,3,6,9,8,7,4,5]', '1 <= m, n <= 10', 'Use top, bottom, left, right pointers.', 'public class Solution {
    public java.util.List<Integer> spiralOrder(int[][] matrix) {
        java.util.List<Integer> res = new java.util.ArrayList<>();
        int top = 0, bot = matrix.length - 1, l = 0, r = matrix[0].length - 1;
        while (top <= bot && l <= r) {
            for (int i = l; i <= r; i++) res.add(matrix[top][i]); top++;
            for (int i = top; i <= bot; i++) res.add(matrix[i][r]); r--;
            if (top <= bot) { for (int i = r; i >= l; i--) res.add(matrix[bot][i]); bot--; }
            if (l <= r) { for (int i = bot; i >= top; i--) res.add(matrix[i][l]); l++; }
        }
        return res;
    }
}', 'class Solution:
    def spiralOrder(self, matrix: list[list[int]]) -> list[int]:
        pass', 'class Solution {
public:
    vector<int> spiralOrder(vector<vector<int>>& matrix) {}
};', 'function spiralOrder(matrix) {}', 'public class Solution {
    public java.util.List<Integer> spiralOrder(int[][] matrix) {
        java.util.List<Integer> res = new java.util.ArrayList<>();
        int top = 0, bot = matrix.length - 1, l = 0, r = matrix[0].length - 1;
        while (top <= bot && l <= r) {
            for (int i = l; i <= r; i++) res.add(matrix[top][i]); top++;
            for (int i = top; i <= bot; i++) res.add(matrix[i][r]); r--;
            if (top <= bot) { for (int i = r; i >= l; i--) res.add(matrix[bot][i]); bot--; }
            if (l <= r) { for (int i = bot; i >= top; i--) res.add(matrix[i][l]); l++; }
        }
        return res;
    }
}', '[{"input": "[[1,2,3],[4,5,6],[7,8,9]]", "expected": "[1,2,3,6,9,8,7,4,5]", "sample": true}]', 'Arrays,Matrix', 'https://takeuforward.org/data-structure/spiral-traversal-of-matrix/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (24, 24, '3 Sum', 'Arrays', 'Hard Array Problems', 'Medium', 'Find all unique triplets in nums that sum to zero.', 'Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]', '3 <= nums.length <= 3000', 'Sort and use two pointers with duplicate skipping.', 'public class Solution {
    public java.util.List<java.util.List<Integer>> threeSum(int[] nums) {
        java.util.Arrays.sort(nums);
        java.util.List<java.util.List<Integer>> res = new java.util.ArrayList<>();
        for (int i = 0; i < nums.length - 2; i++) {
            if (i > 0 && nums[i] == nums[i-1]) continue;
            int l = i + 1, r = nums.length - 1;
            while (l < r) {
                int s = nums[i] + nums[l] + nums[r];
                if (s == 0) {
                    res.add(java.util.Arrays.asList(nums[i], nums[l], nums[r]));
                    while (l < r && nums[l] == nums[l+1]) l++;
                    while (l < r && nums[r] == nums[r-1]) r--;
                    l++; r--;
                } else if (s < 0) l++;
                else r--;
            }
        }
        return res;
    }
}', 'class Solution:
    def threeSum(self, nums: list[int]) -> list[list[int]]:
        pass', 'class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {}
};', 'function threeSum(nums) {}', 'public class Solution {
    public java.util.List<java.util.List<Integer>> threeSum(int[] nums) {
        java.util.Arrays.sort(nums);
        java.util.List<java.util.List<Integer>> res = new java.util.ArrayList<>();
        for (int i = 0; i < nums.length - 2; i++) {
            if (i > 0 && nums[i] == nums[i-1]) continue;
            int l = i + 1, r = nums.length - 1;
            while (l < r) {
                int s = nums[i] + nums[l] + nums[r];
                if (s == 0) {
                    res.add(java.util.Arrays.asList(nums[i], nums[l], nums[r]));
                    while (l < r && nums[l] == nums[l+1]) l++;
                    while (l < r && nums[r] == nums[r-1]) r--;
                    l++; r--;
                } else if (s < 0) l++;
                else r--;
            }
        }
        return res;
    }
}', '[{"input": "[-1,0,1,2,-1,-4]", "expected": "[[-1,-1,2],[-1,0,1]]", "sample": true}]', 'Arrays,Two Pointers,Sorting', 'https://takeuforward.org/data-structure/3-sum-find-triplets-that-add-up-to-a-zero/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (25, 25, 'Merge Overlapping Intervals', 'Arrays', 'Hard Array Problems', 'Medium', 'Merge all overlapping intervals.', 'Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]', '1 <= intervals.length <= 10^4', 'Sort by start time, merge if next.start <= curr.end.', 'public class Solution {
    public int[][] merge(int[][] intervals) {
        java.util.Arrays.sort(intervals, (a, b) -> Integer.compare(a[0], b[0]));
        java.util.List<int[]> res = new java.util.ArrayList<>();
        int[] curr = intervals[0];
        res.add(curr);
        for (int[] inv : intervals) {
            if (inv[0] <= curr[1]) curr[1] = Math.max(curr[1], inv[1]);
            else { curr = inv; res.add(curr); }
        }
        return res.toArray(new int[res.size()][]);
    }
}', 'class Solution:
    def merge(self, intervals: list[list[int]]) -> list[list[int]]:
        pass', 'class Solution {
public:
    vector<vector<int>> merge(vector<vector<int>>& intervals) {}
};', 'function merge(intervals) {}', 'public class Solution {
    public int[][] merge(int[][] intervals) {
        java.util.Arrays.sort(intervals, (a, b) -> Integer.compare(a[0], b[0]));
        java.util.List<int[]> res = new java.util.ArrayList<>();
        int[] curr = intervals[0];
        res.add(curr);
        for (int[] inv : intervals) {
            if (inv[0] <= curr[1]) curr[1] = Math.max(curr[1], inv[1]);
            else { curr = inv; res.add(curr); }
        }
        return res.toArray(new int[res.size()][]);
    }
}', '[{"input": "[[1,3],[2,6],[8,10],[15,18]]", "expected": "[[1,6],[8,10],[15,18]]", "sample": true}]', 'Arrays,Sorting', 'https://takeuforward.org/data-structure/merge-overlapping-sub-intervals/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (26, 26, 'Maximum Product Subarray', 'Arrays', 'Hard Array Problems', 'Medium', 'Find contiguous subarray with largest product.', 'Input: nums = [2,3,-2,4]
Output: 6', '1 <= nums.length <= 2 * 10^4', 'Keep max and min product up to current element.', 'public class Solution {
    public int maxProduct(int[] nums) {
        int max = nums[0], min = nums[0], ans = nums[0];
        for (int i = 1; i < nums.length; i++) {
            if (nums[i] < 0) { int t = max; max = min; min = t; }
            max = Math.max(nums[i], max * nums[i]);
            min = Math.min(nums[i], min * nums[i]);
            ans = Math.max(ans, max);
        }
        return ans;
    }
}', 'class Solution:
    def maxProduct(self, nums: list[int]) -> int:
        pass', 'class Solution {
public:
    int maxProduct(vector<int>& nums) {}
};', 'function maxProduct(nums) {}', 'public class Solution {
    public int maxProduct(int[] nums) {
        int max = nums[0], min = nums[0], ans = nums[0];
        for (int i = 1; i < nums.length; i++) {
            if (nums[i] < 0) { int t = max; max = min; min = t; }
            max = Math.max(nums[i], max * nums[i]);
            min = Math.min(nums[i], min * nums[i]);
            ans = Math.max(ans, max);
        }
        return ans;
    }
}', '[{"input": "[2,3,-2,4]", "expected": "6", "sample": true}]', 'Arrays,Dynamic Programming', 'https://takeuforward.org/data-structure/maximum-product-subarray-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (27, 27, 'Binary Search', 'Binary Search', 'BS on 1D Arrays', 'Easy', 'Find target in sorted array nums. Return index or -1.', 'Input: nums = [-1,0,3,5,9,12], target = 9
Output: 4', '1 <= nums.length <= 10^4', 'low, high pointers, mid = low + (high - low) / 2.', 'public class Solution {
    public int search(int[] nums, int target) {
        int l = 0, r = nums.length - 1;
        while (l <= r) {
            int m = l + (r - l) / 2;
            if (nums[m] == target) return m;
            if (nums[m] < target) l = m + 1; else r = m - 1;
        }
        return -1;
    }
}', 'class Solution:
    def search(self, nums: list[int], target: int) -> int:
        pass', 'class Solution {
public:
    int search(vector<int>& nums, int target) {}
};', 'function search(nums, target) {}', 'public class Solution {
    public int search(int[] nums, int target) {
        int l = 0, r = nums.length - 1;
        while (l <= r) {
            int m = l + (r - l) / 2;
            if (nums[m] == target) return m;
            if (nums[m] < target) l = m + 1; else r = m - 1;
        }
        return -1;
    }
}', '[{"input": "[-1,0,3,5,9,12], 9", "expected": "4", "sample": true}]', 'Binary Search', 'https://takeuforward.org/data-structure/binary-search-explained/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (28, 28, 'Search Insert Position', 'Binary Search', 'BS on 1D Arrays', 'Easy', 'Return index if target exists in sorted array; if not, return index where it would be inserted.', 'Input: nums = [1,3,5,6], target = 5
Output: 2', '1 <= nums.length <= 10^4', 'Lower bound: find smallest index where nums[mid] >= target.', 'public class Solution {
    public int searchInsert(int[] nums, int target) {
        int l = 0, r = nums.length - 1, ans = nums.length;
        while (l <= r) {
            int m = l + (r - l) / 2;
            if (nums[m] >= target) { ans = m; r = m - 1; } else l = m + 1;
        }
        return ans;
    }
}', 'class Solution:
    def searchInsert(self, nums: list[int], target: int) -> int:
        pass', 'class Solution {
public:
    int searchInsert(vector<int>& nums, int target) {}
};', 'function searchInsert(nums, target) {}', 'public class Solution {
    public int searchInsert(int[] nums, int target) {
        int l = 0, r = nums.length - 1, ans = nums.length;
        while (l <= r) {
            int m = l + (r - l) / 2;
            if (nums[m] >= target) { ans = m; r = m - 1; } else l = m + 1;
        }
        return ans;
    }
}', '[{"input": "[1,3,5,6], 5", "expected": "2", "sample": true}]', 'Binary Search', 'https://takeuforward.org/arrays/search-insert-position/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (29, 29, 'Search in Rotated Sorted Array', 'Binary Search', 'BS on 1D Arrays', 'Medium', 'Find target in rotated sorted array of unique elements in O(log n).', 'Input: nums = [4,5,6,7,0,1,2], target = 0
Output: 4', '1 <= nums.length <= 5000', 'One half is always sorted. Check if target lies in the sorted half.', 'public class Solution {
    public int search(int[] nums, int target) {
        int l = 0, r = nums.length - 1;
        while (l <= r) {
            int m = l + (r - l) / 2;
            if (nums[m] == target) return m;
            if (nums[l] <= nums[m]) {
                if (nums[l] <= target && target < nums[m]) r = m - 1; else l = m + 1;
            } else {
                if (nums[m] < target && target <= nums[r]) l = m + 1; else r = m - 1;
            }
        }
        return -1;
    }
}', 'class Solution:
    def search(self, nums: list[int], target: int) -> int:
        pass', 'class Solution {
public:
    int search(vector<int>& nums, int target) {}
};', 'function search(nums, target) {}', 'public class Solution {
    public int search(int[] nums, int target) {
        int l = 0, r = nums.length - 1;
        while (l <= r) {
            int m = l + (r - l) / 2;
            if (nums[m] == target) return m;
            if (nums[l] <= nums[m]) {
                if (nums[l] <= target && target < nums[m]) r = m - 1; else l = m + 1;
            } else {
                if (nums[m] < target && target <= nums[r]) l = m + 1; else r = m - 1;
            }
        }
        return -1;
    }
}', '[{"input": "[4,5,6,7,0,1,2], 0", "expected": "4", "sample": true}]', 'Binary Search', 'https://takeuforward.org/data-structure/search-element-in-a-rotated-sorted-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (30, 30, 'Koko Eating Bananas', 'Binary Search', 'BS on Answers', 'Medium', 'Minimum integer speed k to eat all bananas within h hours.', 'Input: piles = [3,6,7,11], h = 8
Output: 4', '1 <= piles.length <= 10^4
1 <= piles[i] <= 10^9', 'Binary search on speed [1, max(piles)].', 'public class Solution {
    public int minEatingSpeed(int[] piles, int h) {
        int l = 1, r = 0;
        for (int p : piles) if (p > r) r = p;
        int ans = r;
        while (l <= r) {
            int m = l + (r - l) / 2;
            long hr = 0;
            for (int p : piles) hr += (p + m - 1) / m;
            if (hr <= h) { ans = m; r = m - 1; } else l = m + 1;
        }
        return ans;
    }
}', 'class Solution:
    def minEatingSpeed(self, piles: list[int], h: int) -> int:
        pass', 'class Solution {
public:
    int minEatingSpeed(vector<int>& piles, int h) {}
};', 'function minEatingSpeed(piles, h) {}', 'public class Solution {
    public int minEatingSpeed(int[] piles, int h) {
        int l = 1, r = 0;
        for (int p : piles) if (p > r) r = p;
        int ans = r;
        while (l <= r) {
            int m = l + (r - l) / 2;
            long hr = 0;
            for (int p : piles) hr += (p + m - 1) / m;
            if (hr <= h) { ans = m; r = m - 1; } else l = m + 1;
        }
        return ans;
    }
}', '[{"input": "[3,6,7,11], 8", "expected": "4", "sample": true}]', 'Binary Search', 'https://takeuforward.org/binary-search/koko-eating-bananas/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (31, 31, 'Search a 2D Matrix', 'Binary Search', 'BS on 2D Arrays', 'Medium', 'Search for target in sorted m x n matrix where row 0 ends < row 1 begins.', 'Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 3
Output: true', '1 <= m, n <= 100', 'Treat as 1D array of size m * n.', 'public class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int m = matrix.length, n = matrix[0].length, l = 0, r = m * n - 1;
        while (l <= r) {
            int mid = l + (r - l) / 2, val = matrix[mid / n][mid % n];
            if (val == target) return true;
            if (val < target) l = mid + 1; else r = mid - 1;
        }
        return false;
    }
}', 'class Solution:
    def searchMatrix(self, matrix: list[list[int]], target: int) -> bool:
        pass', 'class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {}
};', 'function searchMatrix(matrix, target) {}', 'public class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int m = matrix.length, n = matrix[0].length, l = 0, r = m * n - 1;
        while (l <= r) {
            int mid = l + (r - l) / 2, val = matrix[mid / n][mid % n];
            if (val == target) return true;
            if (val < target) l = mid + 1; else r = mid - 1;
        }
        return false;
    }
}', '[{"input": "[[1,3,5,7],[10,11,16,20],[23,30,34,60]], 3", "expected": "true", "sample": true}]', 'Binary Search,Matrix', 'https://takeuforward.org/data-structure/search-in-a-sorted-2d-matrix/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (32, 32, 'Reverse Words in a String', 'Strings', 'Basic String Problems', 'Medium', 'Reverse the order of words in string s separated by spaces.', 'Input: s = "the sky is blue"
Output: "blue is sky the"', '1 <= s.length <= 10^4', 'Trim, split by whitespace, and join in reverse.', 'public class Solution {
    public String reverseWords(String s) {
        String[] w = s.trim().split("\\\\s+");
        StringBuilder sb = new StringBuilder();
        for (int i = w.length - 1; i >= 0; i--) {
            sb.append(w[i]); if (i > 0) sb.append(" ");
        }
        return sb.toString();
    }
}', 'class Solution:
    def reverseWords(self, s: str) -> str:
        return '' ''.join(s.split()[::-1])', 'class Solution {
public:
    string reverseWords(string s) {}
};', 'function reverseWords(s) {
    return s.trim().split(/\\s+/).reverse().join('' '');
}', 'public class Solution {
    public String reverseWords(String s) {
        String[] w = s.trim().split("\\\\s+");
        StringBuilder sb = new StringBuilder();
        for (int i = w.length - 1; i >= 0; i--) {
            sb.append(w[i]); if (i > 0) sb.append(" ");
        }
        return sb.toString();
    }
}', '[{"input": "\\"the sky is blue\\"", "expected": "\\"blue is sky the\\"", "sample": true}]', 'Strings,Two Pointers', 'https://takeuforward.org/data-structure/reverse-words-in-a-string/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (33, 33, 'Longest Common Prefix', 'Strings', 'Basic String Problems', 'Easy', 'Find longest common prefix string among array of strings.', 'Input: strs = ["flower","flow","flight"]
Output: "fl"', '1 <= strs.length <= 200', 'Sort strings and compare first and last strings.', 'public class Solution {
    public String longestCommonPrefix(String[] strs) {
        if (strs == null || strs.length == 0) return "";
        java.util.Arrays.sort(strs);
        String s1 = strs[0], s2 = strs[strs.length - 1];
        int i = 0;
        while (i < s1.length() && i < s2.length() && s1.charAt(i) == s2.charAt(i)) i++;
        return s1.substring(0, i);
    }
}', 'class Solution:
    def longestCommonPrefix(self, strs: list[str]) -> str:
        pass', 'class Solution {
public:
    string longestCommonPrefix(vector<string>& strs) {}
};', 'function longestCommonPrefix(strs) {}', 'public class Solution {
    public String longestCommonPrefix(String[] strs) {
        if (strs == null || strs.length == 0) return "";
        java.util.Arrays.sort(strs);
        String s1 = strs[0], s2 = strs[strs.length - 1];
        int i = 0;
        while (i < s1.length() && i < s2.length() && s1.charAt(i) == s2.charAt(i)) i++;
        return s1.substring(0, i);
    }
}', '[{"input": "[\\"flower\\",\\"flow\\",\\"flight\\"]", "expected": "\\"fl\\"", "sample": true}]', 'Strings', 'https://takeuforward.org/data-structure/longest-common-prefix/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (34, 34, 'Valid Anagram', 'Strings', 'Basic String Problems', 'Easy', 'Return true if t is an anagram of s, false otherwise.', 'Input: s = "anagram", t = "nagaram"
Output: true', '1 <= s.length, t.length <= 5 * 10^4', 'Frequency count array of size 26.', 'public class Solution {
    public boolean isAnagram(String s, String t) {
        if (s.length() != t.length()) return false;
        int[] c = new int[26];
        for (char ch : s.toCharArray()) c[ch - ''a'']++;
        for (char ch : t.toCharArray()) if (--c[ch - ''a''] < 0) return false;
        return true;
    }
}', 'class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        pass', 'class Solution {
public:
    bool isAnagram(string s, string t) {}
};', 'function isAnagram(s, t) {}', 'public class Solution {
    public boolean isAnagram(String s, String t) {
        if (s.length() != t.length()) return false;
        int[] c = new int[26];
        for (char ch : s.toCharArray()) c[ch - ''a'']++;
        for (char ch : t.toCharArray()) if (--c[ch - ''a''] < 0) return false;
        return true;
    }
}', '[{"input": "\\"anagram\\", \\"nagaram\\"", "expected": "true", "sample": true}]', 'Strings,HashMap', 'https://takeuforward.org/data-structure/check-if-two-strings-are-anagrams-of-each-other/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (35, 35, 'Longest Palindromic Substring', 'Strings', 'Medium String Problems', 'Medium', 'Return longest palindromic substring in string s.', 'Input: s = "babad"
Output: "bab"', '1 <= s.length <= 1000', 'Expand around center for 2n-1 possible centers.', 'public class Solution {
    public String longestPalindrome(String s) {
        int st = 0, end = 0;
        for (int i = 0; i < s.length(); i++) {
            int len = Math.max(exp(s, i, i), exp(s, i, i + 1));
            if (len > end - st) { st = i - (len - 1) / 2; end = i + len / 2; }
        }
        return s.substring(st, end + 1);
    }
    private int exp(String s, int l, int r) {
        while (l >= 0 && r < s.length() && s.charAt(l) == s.charAt(r)) { l--; r++; }
        return r - l - 1;
    }
}', 'class Solution:
    def longestPalindrome(self, s: str) -> str:
        pass', 'class Solution {
public:
    string longestPalindrome(string s) {}
};', 'function longestPalindrome(s) {}', 'public class Solution {
    public String longestPalindrome(String s) {
        int st = 0, end = 0;
        for (int i = 0; i < s.length(); i++) {
            int len = Math.max(exp(s, i, i), exp(s, i, i + 1));
            if (len > end - st) { st = i - (len - 1) / 2; end = i + len / 2; }
        }
        return s.substring(st, end + 1);
    }
    private int exp(String s, int l, int r) {
        while (l >= 0 && r < s.length() && s.charAt(l) == s.charAt(r)) { l--; r++; }
        return r - l - 1;
    }
}', '[{"input": "\\"babad\\"", "expected": "\\"bab\\"", "sample": true}]', 'Strings,Dynamic Programming', 'https://takeuforward.org/data-structure/longest-palindromic-substring/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (36, 36, 'Reverse a Linked List', 'Linked List', '1D Linked List', 'Easy', 'Reverse a singly linked list iteratively.', 'Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]', '0 <= nodes <= 5000', 'curr, prev, next three pointers.', 'public class Solution {
    public ListNode reverseList(ListNode head) {
        ListNode prev = null, cur = head;
        while (cur != null) {
            ListNode next = cur.next; cur.next = prev; prev = cur; cur = next;
        }
        return prev;
    }
}', 'class Solution:
    def reverseList(self, head):
        pass', 'class Solution {
public:
    ListNode* reverseList(ListNode* head) {}
};', 'function reverseList(head) {}', 'public class Solution {
    public ListNode reverseList(ListNode head) {
        ListNode prev = null, cur = head;
        while (cur != null) {
            ListNode next = cur.next; cur.next = prev; prev = cur; cur = next;
        }
        return prev;
    }
}', '[{"input": "[1,2,3,4,5]", "expected": "[5,4,3,2,1]", "sample": true}]', 'Linked List,Recursion', 'https://takeuforward.org/data-structure/reverse-a-linked-list/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (37, 37, 'Middle of the Linked List', 'Linked List', '1D Linked List', 'Easy', 'Return middle node of linked list (second middle if even).', 'Input: head = [1,2,3,4,5]
Output: [3,4,5]', '1 <= nodes <= 100', 'Tortoise and Hare: slow 1 step, fast 2 steps.', 'public class Solution {
    public ListNode middleNode(ListNode head) {
        ListNode s = head, f = head;
        while (f != null && f.next != null) { s = s.next; f = f.next.next; }
        return s;
    }
}', 'class Solution:
    def middleNode(self, head):
        pass', 'class Solution {
public:
    ListNode* middleNode(ListNode* head) {}
};', 'function middleNode(head) {}', 'public class Solution {
    public ListNode middleNode(ListNode head) {
        ListNode s = head, f = head;
        while (f != null && f.next != null) { s = s.next; f = f.next.next; }
        return s;
    }
}', '[{"input": "[1,2,3,4,5]", "expected": "[3,4,5]", "sample": true}]', 'Linked List,Two Pointers', 'https://takeuforward.org/data-structure/find-middle-element-in-a-linked-list/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (38, 38, 'Detect Cycle in Linked List', 'Linked List', 'Medium Linked List', 'Easy', 'Determine if linked list has a cycle.', 'Input: head = [3,2,0,-4], pos = 1
Output: true', '0 <= nodes <= 10^4', 'Floyd cycle algorithm.', 'public class Solution {
    public boolean hasCycle(ListNode head) {
        ListNode s = head, f = head;
        while (f != null && f.next != null) {
            s = s.next; f = f.next.next;
            if (s == f) return true;
        }
        return false;
    }
}', 'class Solution:
    def hasCycle(self, head) -> bool:
        pass', 'class Solution {
public:
    bool hasCycle(ListNode* head) {}
};', 'function hasCycle(head) {}', 'public class Solution {
    public boolean hasCycle(ListNode head) {
        ListNode s = head, f = head;
        while (f != null && f.next != null) {
            s = s.next; f = f.next.next;
            if (s == f) return true;
        }
        return false;
    }
}', '[{"input": "[3,2,0,-4], pos = 1", "expected": "true", "sample": true}]', 'Linked List,Two Pointers', 'https://takeuforward.org/data-structure/detect-a-cycle-in-a-linked-list/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (39, 39, 'Merge Two Sorted Lists', 'Linked List', 'Medium Linked List', 'Easy', 'Merge two sorted linked lists and return sorted head.', 'Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]', '0 <= length <= 50', 'Dummy head, pick smaller node.', 'public class Solution {
    public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
        ListNode dummy = new ListNode(0), cur = dummy;
        while (l1 != null && l2 != null) {
            if (l1.val <= l2.val) { cur.next = l1; l1 = l1.next; }
            else { cur.next = l2; l2 = l2.next; }
            cur = cur.next;
        }
        cur.next = (l1 != null) ? l1 : l2;
        return dummy.next;
    }
}', 'class Solution:
    def mergeTwoLists(self, l1, l2):
        pass', 'class Solution {
public:
    ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {}
};', 'function mergeTwoLists(l1, l2) {}', 'public class Solution {
    public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
        ListNode dummy = new ListNode(0), cur = dummy;
        while (l1 != null && l2 != null) {
            if (l1.val <= l2.val) { cur.next = l1; l1 = l1.next; }
            else { cur.next = l2; l2 = l2.next; }
            cur = cur.next;
        }
        cur.next = (l1 != null) ? l1 : l2;
        return dummy.next;
    }
}', '[{"input": "[1,2,4], [1,3,4]", "expected": "[1,1,2,3,4,4]", "sample": true}]', 'Linked List,Recursion', 'https://takeuforward.org/data-structure/merge-two-sorted-linked-lists/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (40, 40, 'Fibonacci Number', 'Recursion', 'Recursion Basics', 'Easy', 'Compute the nth Fibonacci number F(n) where F(0)=0, F(1)=1.', 'Input: n = 4
Output: 3', '0 <= n <= 30', 'F(n) = F(n-1) + F(n-2).', 'public class Solution {
    public int fib(int n) {
        if (n <= 1) return n;
        int a = 0, b = 1;
        for (int i = 2; i <= n; i++) { int c = a + b; a = b; b = c; }
        return b;
    }
}', 'class Solution:
    def fib(self, n: int) -> int:
        pass', 'class Solution {
public:
    int fib(int n) {}
};', 'function fib(n) {}', 'public class Solution {
    public int fib(int n) {
        if (n <= 1) return n;
        int a = 0, b = 1;
        for (int i = 2; i <= n; i++) { int c = a + b; a = b; b = c; }
        return b;
    }
}', '[{"input": "4", "expected": "3", "sample": true}, {"input": "2", "expected": "1", "sample": true}]', 'Recursion,Math,Dynamic Programming', 'https://takeuforward.org/data-structure/dynamic-programming-introduction/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (41, 41, 'Subsets (Power Set)', 'Recursion', 'Subsequences & Subsets', 'Medium', 'Return all possible subsets (the power set) of array with unique elements.', 'Input: nums = [1,2,3]
Output: [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]', '1 <= nums.length <= 10', 'Backtrack: pick or don''t pick current element.', 'public class Solution {
    public java.util.List<java.util.List<Integer>> subsets(int[] nums) {
        java.util.List<java.util.List<Integer>> ans = new java.util.ArrayList<>();
        bt(nums, 0, new java.util.ArrayList<>(), ans);
        return ans;
    }
    private void bt(int[] nums, int i, java.util.List<Integer> cur, java.util.List<java.util.List<Integer>> ans) {
        ans.add(new java.util.ArrayList<>(cur));
        for (int j = i; j < nums.length; j++) {
            cur.add(nums[j]); bt(nums, j + 1, cur, ans); cur.remove(cur.size() - 1);
        }
    }
}', 'class Solution:
    def subsets(self, nums: list[int]) -> list[list[int]]:
        pass', 'class Solution {
public:
    vector<vector<int>> subsets(vector<int>& nums) {}
};', 'function subsets(nums) {}', 'public class Solution {
    public java.util.List<java.util.List<Integer>> subsets(int[] nums) {
        java.util.List<java.util.List<Integer>> ans = new java.util.ArrayList<>();
        bt(nums, 0, new java.util.ArrayList<>(), ans);
        return ans;
    }
    private void bt(int[] nums, int i, java.util.List<Integer> cur, java.util.List<java.util.List<Integer>> ans) {
        ans.add(new java.util.ArrayList<>(cur));
        for (int j = i; j < nums.length; j++) {
            cur.add(nums[j]); bt(nums, j + 1, cur, ans); cur.remove(cur.size() - 1);
        }
    }
}', '[{"input": "[1,2,3]", "expected": "[[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]", "sample": true}]', 'Recursion,Backtracking', 'https://takeuforward.org/data-structure/power-set-print-all-subsequences-of-a-string-or-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (42, 42, 'Combination Sum', 'Recursion', 'Subsequences & Subsets', 'Medium', 'Return unique combinations where candidate numbers sum to target (numbers can be reused).', 'Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]', '1 <= candidates.length <= 30', 'If target >= candidate, pick and stay at idx; else advance idx.', 'public class Solution {
    public java.util.List<java.util.List<Integer>> combinationSum(int[] cand, int target) {
        java.util.List<java.util.List<Integer>> res = new java.util.ArrayList<>();
        find(0, target, cand, new java.util.ArrayList<>(), res);
        return res;
    }
    private void find(int i, int t, int[] a, java.util.List<Integer> cur, java.util.List<java.util.List<Integer>> res) {
        if (i == a.length) { if (t == 0) res.add(new java.util.ArrayList<>(cur)); return; }
        if (a[i] <= t) { cur.add(a[i]); find(i, t - a[i], a, cur, res); cur.remove(cur.size() - 1); }
        find(i + 1, t, a, cur, res);
    }
}', 'class Solution:
    def combinationSum(self, candidates: list[int], target: int) -> list[list[int]]:
        pass', 'class Solution {
public:
    vector<vector<int>> combinationSum(vector<int>& candidates, int target) {}
};', 'function combinationSum(candidates, target) {}', 'public class Solution {
    public java.util.List<java.util.List<Integer>> combinationSum(int[] cand, int target) {
        java.util.List<java.util.List<Integer>> res = new java.util.ArrayList<>();
        find(0, target, cand, new java.util.ArrayList<>(), res);
        return res;
    }
    private void find(int i, int t, int[] a, java.util.List<Integer> cur, java.util.List<java.util.List<Integer>> res) {
        if (i == a.length) { if (t == 0) res.add(new java.util.ArrayList<>(cur)); return; }
        if (a[i] <= t) { cur.add(a[i]); find(i, t - a[i], a, cur, res); cur.remove(cur.size() - 1); }
        find(i + 1, t, a, cur, res);
    }
}', '[{"input": "[2,3,6,7], 7", "expected": "[[2,2,3],[7]]", "sample": true}]', 'Recursion,Backtracking', 'https://takeuforward.org/data-structure/combination-sum-1/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (43, 43, 'N-Queens', 'Backtracking', 'Hard Backtracking', 'Hard', 'Place n queens on an n x n chessboard such that no two queens attack each other.', 'Input: n = 4
Output: [[".Q..","...Q","Q...","..Q."],["..Q.","Q...","...Q",".Q.."]]', '1 <= n <= 9', 'Track cols, main diagonals, and anti-diagonals.', 'public class Solution {
    public java.util.List<java.util.List<String>> solveNQueens(int n) {
        char[][] b = new char[n][n];
        for (int i = 0; i < n; i++) java.util.Arrays.fill(b[i], ''.'');
        java.util.List<java.util.List<String>> res = new java.util.ArrayList<>();
        dfs(0, b, new boolean[n], new boolean[2*n], new boolean[2*n], res, n);
        return res;
    }
    private void dfs(int r, char[][] b, boolean[] c, boolean[] d1, boolean[] d2, java.util.List<java.util.List<String>> res, int n) {
        if (r == n) {
            java.util.List<String> l = new java.util.ArrayList<>();
            for (char[] row : b) l.add(new String(row));
            res.add(l); return;
        }
        for (int col = 0; col < n; col++) {
            int id1 = r - col + n, id2 = r + col;
            if (!c[col] && !d1[id1] && !d2[id2]) {
                b[r][col] = ''Q''; c[col] = d1[id1] = d2[id2] = true;
                dfs(r + 1, b, c, d1, d2, res, n);
                b[r][col] = ''.''; c[col] = d1[id1] = d2[id2] = false;
            }
        }
    }
}', 'class Solution:
    def solveNQueens(self, n: int) -> list[list[str]]:
        pass', 'class Solution {
public:
    vector<vector<string>> solveNQueens(int n) {}
};', 'function solveNQueens(n) {}', 'public class Solution {
    public java.util.List<java.util.List<String>> solveNQueens(int n) {
        char[][] b = new char[n][n];
        for (int i = 0; i < n; i++) java.util.Arrays.fill(b[i], ''.'');
        java.util.List<java.util.List<String>> res = new java.util.ArrayList<>();
        dfs(0, b, new boolean[n], new boolean[2*n], new boolean[2*n], res, n);
        return res;
    }
    private void dfs(int r, char[][] b, boolean[] c, boolean[] d1, boolean[] d2, java.util.List<java.util.List<String>> res, int n) {
        if (r == n) {
            java.util.List<String> l = new java.util.ArrayList<>();
            for (char[] row : b) l.add(new String(row));
            res.add(l); return;
        }
        for (int col = 0; col < n; col++) {
            int id1 = r - col + n, id2 = r + col;
            if (!c[col] && !d1[id1] && !d2[id2]) {
                b[r][col] = ''Q''; c[col] = d1[id1] = d2[id2] = true;
                dfs(r + 1, b, c, d1, d2, res, n);
                b[r][col] = ''.''; c[col] = d1[id1] = d2[id2] = false;
            }
        }
    }
}', '[{"input": "4", "expected": "[[\\".Q..\\",\\"...Q\\",\\"Q...\\",\\"..Q.\\"],[\\"..Q.\\",\\"Q...\\",\\"...Q\\",\\".Q..\\"]]", "sample": true}]', 'Backtracking', 'https://takeuforward.org/data-structure/n-queen-problem-return-all-proper-arrangements-of-queens-on-a-chess-board/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (44, 44, 'Word Search', 'Backtracking', 'Hard Backtracking', 'Medium', 'Given m x n board of characters and string word, return true if word exists in grid.', 'Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
Output: true', '1 <= m, n <= 6
1 <= word.length <= 15', 'DFS in 4 directions marking visited cells.', 'public class Solution {
    public boolean exist(char[][] board, String word) {
        for (int i = 0; i < board.length; i++) for (int j = 0; j < board[0].length; j++) {
            if (dfs(board, word, i, j, 0)) return true;
        }
        return false;
    }
    private boolean dfs(char[][] b, String w, int r, int c, int idx) {
        if (idx == w.length()) return true;
        if (r < 0 || c < 0 || r >= b.length || c >= b[0].length || b[r][c] != w.charAt(idx)) return false;
        char t = b[r][c]; b[r][c] = ''#'';
        boolean found = dfs(b, w, r+1, c, idx+1) || dfs(b, w, r-1, c, idx+1) || dfs(b, w, r, c+1, idx+1) || dfs(b, w, r, c-1, idx+1);
        b[r][c] = t;
        return found;
    }
}', 'class Solution:
    def exist(self, board: list[list[str]], word: str) -> bool:
        pass', 'class Solution {
public:
    bool exist(vector<vector<char>>& board, string word) {}
};', 'function exist(board, word) {}', 'public class Solution {
    public boolean exist(char[][] board, String word) {
        for (int i = 0; i < board.length; i++) for (int j = 0; j < board[0].length; j++) {
            if (dfs(board, word, i, j, 0)) return true;
        }
        return false;
    }
    private boolean dfs(char[][] b, String w, int r, int c, int idx) {
        if (idx == w.length()) return true;
        if (r < 0 || c < 0 || r >= b.length || c >= b[0].length || b[r][c] != w.charAt(idx)) return false;
        char t = b[r][c]; b[r][c] = ''#'';
        boolean found = dfs(b, w, r+1, c, idx+1) || dfs(b, w, r-1, c, idx+1) || dfs(b, w, r, c+1, idx+1) || dfs(b, w, r, c-1, idx+1);
        b[r][c] = t;
        return found;
    }
}', '[{"input": "[[\\"A\\",\\"B\\",\\"C\\",\\"E\\"],[\\"S\\",\\"F\\",\\"C\\",\\"S\\"],[\\"A\\",\\"D\\",\\"E\\",\\"E\\"]], \\"ABCCED\\"", "expected": "true", "sample": true}]', 'Backtracking,Matrix', 'https://takeuforward.org/data-structure/word-search-leetcode/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (45, 45, 'Check if ith Bit is Set', 'Bit Manipulation', 'Bit Manipulation Basics', 'Easy', 'Check if the ith bit of integer n is 1.', 'Input: n = 4, i = 2
Output: true', '0 <= n <= 10^9
0 <= i <= 31', '((n >> i) & 1) == 1', 'public class Solution {
    public boolean checkKthBit(int n, int i) {
        return ((n >> i) & 1) == 1;
    }
}', 'class Solution:
    def checkKthBit(self, n: int, i: int) -> bool:
        return bool((n >> i) & 1)', 'class Solution {
public:
    bool checkKthBit(int n, int i) { return (n >> i) & 1; }
};', 'function checkKthBit(n, i) { return ((n >> i) & 1) === 1; }', 'public class Solution {
    public boolean checkKthBit(int n, int i) {
        return ((n >> i) & 1) == 1;
    }
}', '[{"input": "4, 2", "expected": "true", "sample": true}]', 'Bit Manipulation', 'https://takeuforward.org/data-structure/check-if-the-i-th-bit-is-set-or-not/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (46, 46, 'Power of Two', 'Bit Manipulation', 'Bit Manipulation Basics', 'Easy', 'Check if integer n is power of two.', 'Input: n = 16
Output: true', '-2^31 <= n <= 2^31 - 1', 'n > 0 && (n & (n - 1)) == 0', 'public class Solution {
    public boolean isPowerOfTwo(int n) {
        return n > 0 && (n & (n - 1)) == 0;
    }
}', 'class Solution:
    def isPowerOfTwo(self, n: int) -> bool:
        return n > 0 and (n & (n - 1)) == 0', 'class Solution {
public:
    bool isPowerOfTwo(int n) { return n > 0 && !(n & (n - 1)); }
};', 'function isPowerOfTwo(n) { return n > 0 && (n & (n - 1)) === 0; }', 'public class Solution {
    public boolean isPowerOfTwo(int n) {
        return n > 0 && (n & (n - 1)) == 0;
    }
}', '[{"input": "16", "expected": "true", "sample": true}, {"input": "3", "expected": "false", "sample": true}]', 'Bit Manipulation', 'https://takeuforward.org/data-structure/check-if-a-number-is-a-power-of-2-or-not/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (47, 47, 'Count Set Bits', 'Bit Manipulation', 'Bit Manipulation Basics', 'Easy', 'Count the number of 1-bits in an integer.', 'Input: n = 11
Output: 3
Explanation: 11 in binary is 1011.', '1 <= n <= 2^31 - 1', 'Brian Kernighan''s: n = n & (n - 1).', 'public class Solution {
    public int hammingWeight(int n) {
        int count = 0;
        while (n != 0) { n &= (n - 1); count++; }
        return count;
    }
}', 'class Solution:
    def hammingWeight(self, n: int) -> int:
        pass', 'class Solution {
public:
    int hammingWeight(int n) {}
};', 'function hammingWeight(n) {}', 'public class Solution {
    public int hammingWeight(int n) {
        int count = 0;
        while (n != 0) { n &= (n - 1); count++; }
        return count;
    }
}', '[{"input": "11", "expected": "3", "sample": true}]', 'Bit Manipulation', 'https://takeuforward.org/data-structure/count-number-of-set-bits/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (48, 48, 'Valid Parentheses', 'Stack', 'Learning Stack', 'Easy', 'Check if string s containing ''()[]{}'' has balanced brackets.', 'Input: s = "()[]{}"
Output: true', '1 <= s.length <= 10^4', 'Stack matches top on closing bracket.', 'public class Solution {
    public boolean isValid(String s) {
        java.util.Stack<Character> st = new java.util.Stack<>();
        for (char c : s.toCharArray()) {
            if (c == ''('') st.push('')'');
            else if (c == ''{'') st.push(''}'');
            else if (c == ''['') st.push('']'');
            else if (st.isEmpty() || st.pop() != c) return false;
        }
        return st.isEmpty();
    }
}', 'class Solution:
    def isValid(self, s: str) -> bool:
        pass', 'class Solution {
public:
    bool isValid(string s) {}
};', 'function isValid(s) {}', 'public class Solution {
    public boolean isValid(String s) {
        java.util.Stack<Character> st = new java.util.Stack<>();
        for (char c : s.toCharArray()) {
            if (c == ''('') st.push('')'');
            else if (c == ''{'') st.push(''}'');
            else if (c == ''['') st.push('']'');
            else if (st.isEmpty() || st.pop() != c) return false;
        }
        return st.isEmpty();
    }
}', '[{"input": "\\"()[]{}\\"", "expected": "true", "sample": true}]', 'Stack,String', 'https://takeuforward.org/data-structure/check-for-balanced-parentheses/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (49, 49, 'Next Greater Element', 'Stack', 'Monotonic Stack', 'Easy', 'Find next greater element in array nums2 for elements in nums1.', 'Input: nums1 = [4,1,2], nums2 = [1,3,4,2]
Output: [-1,3,-1]', '1 <= nums1.length <= nums2.length <= 1000', 'Monotonic decreasing stack right to left.', 'public class Solution {
    public int[] nextGreaterElement(int[] nums1, int[] nums2) {
        java.util.Map<Integer, Integer> map = new java.util.HashMap<>();
        java.util.Stack<Integer> st = new java.util.Stack<>();
        for (int x : nums2) {
            while (!st.isEmpty() && st.peek() < x) map.put(st.pop(), x);
            st.push(x);
        }
        int[] ans = new int[nums1.length];
        for (int i = 0; i < nums1.length; i++) ans[i] = map.getOrDefault(nums1[i], -1);
        return ans;
    }
}', 'class Solution:
    def nextGreaterElement(self, nums1: list[int], nums2: list[int]) -> list[int]:
        pass', 'class Solution {
public:
    vector<int> nextGreaterElement(vector<int>& nums1, vector<int>& nums2) {}
};', 'function nextGreaterElement(nums1, nums2) {}', 'public class Solution {
    public int[] nextGreaterElement(int[] nums1, int[] nums2) {
        java.util.Map<Integer, Integer> map = new java.util.HashMap<>();
        java.util.Stack<Integer> st = new java.util.Stack<>();
        for (int x : nums2) {
            while (!st.isEmpty() && st.peek() < x) map.put(st.pop(), x);
            st.push(x);
        }
        int[] ans = new int[nums1.length];
        for (int i = 0; i < nums1.length; i++) ans[i] = map.getOrDefault(nums1[i], -1);
        return ans;
    }
}', '[{"input": "[4,1,2], [1,3,4,2]", "expected": "[-1,3,-1]", "sample": true}]', 'Stack,Monotonic Stack', 'https://takeuforward.org/data-structure/next-greater-element-using-stack/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (50, 50, 'Trapping Rain Water', 'Stack', 'Monotonic Stack', 'Hard', 'Compute how much water can be trapped between elevation heights.', 'Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6', '1 <= height.length <= 2 * 10^4', 'Two pointers leftMax and rightMax.', 'public class Solution {
    public int trap(int[] height) {
        int l = 0, r = height.length - 1, leftMax = 0, rightMax = 0, res = 0;
        while (l <= r) {
            if (height[l] <= height[r]) {
                if (height[l] >= leftMax) leftMax = height[l]; else res += leftMax - height[l];
                l++;
            } else {
                if (height[r] >= rightMax) rightMax = height[r]; else res += rightMax - height[r];
                r--;
            }
        }
        return res;
    }
}', 'class Solution:
    def trap(self, height: list[int]) -> int:
        pass', 'class Solution {
public:
    int trap(vector<int>& height) {}
};', 'function trap(height) {}', 'public class Solution {
    public int trap(int[] height) {
        int l = 0, r = height.length - 1, leftMax = 0, rightMax = 0, res = 0;
        while (l <= r) {
            if (height[l] <= height[r]) {
                if (height[l] >= leftMax) leftMax = height[l]; else res += leftMax - height[l];
                l++;
            } else {
                if (height[r] >= rightMax) rightMax = height[r]; else res += rightMax - height[r];
                r--;
            }
        }
        return res;
    }
}', '[{"input": "[0,1,0,2,1,0,1,3,2,1,2,1]", "expected": "6", "sample": true}]', 'Stack,Two Pointers', 'https://takeuforward.org/data-structure/trapping-rainwater/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (51, 51, 'Implement Queue using Stacks', 'Queue', 'Queue Implementation', 'Easy', 'Implement FIFO queue using two stacks.', 'Input: push(1), push(2), peek(), pop(), empty()
Output: peek=1, pop=1, empty=false', '1 <= calls <= 100', 'Transfer elements only on demand when out stack is empty.', 'public class MyQueue {
    java.util.Stack<Integer> in = new java.util.Stack<>(), out = new java.util.Stack<>();
    public void push(int x) { in.push(x); }
    public int pop() { peek(); return out.pop(); }
    public int peek() { if (out.isEmpty()) while (!in.isEmpty()) out.push(in.pop()); return out.peek(); }
    public boolean empty() { return in.isEmpty() && out.isEmpty(); }
}', 'class MyQueue:
    def __init__(self):
        pass', 'class MyQueue {
public:
    MyQueue() {}
};', 'class MyQueue {
    constructor() {}
}', 'public class MyQueue {
    java.util.Stack<Integer> in = new java.util.Stack<>(), out = new java.util.Stack<>();
    public void push(int x) { in.push(x); }
    public int pop() { peek(); return out.pop(); }
    public int peek() { if (out.isEmpty()) while (!in.isEmpty()) out.push(in.pop()); return out.peek(); }
    public boolean empty() { return in.isEmpty() && out.isEmpty(); }
}', '[{"input": "push(1), push(2), peek()", "expected": "1", "sample": true}]', 'Queue,Stack', 'https://takeuforward.org/data-structure/implement-queue-using-stack/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (52, 52, 'Longest Substring Without Repeating Characters', 'Sliding Window', 'Standard Window', 'Medium', 'Find length of longest substring without repeating characters.', 'Input: s = "abcabcbb"
Output: 3
Explanation: "abc"', '0 <= s.length <= 5 * 10^4', 'Sliding window [l, r] with character last-index map.', 'public class Solution {
    public int lengthOfLongestSubstring(String s) {
        int[] map = new int[256];
        java.util.Arrays.fill(map, -1);
        int l = 0, r = 0, len = 0;
        while (r < s.length()) {
            char c = s.charAt(r);
            if (map[c] != -1) l = Math.max(map[c] + 1, l);
            map[c] = r;
            len = Math.max(len, r - l + 1);
            r++;
        }
        return len;
    }
}', 'class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        pass', 'class Solution {
public:
    int lengthOfLongestSubstring(string s) {}
};', 'function lengthOfLongestSubstring(s) {}', 'public class Solution {
    public int lengthOfLongestSubstring(String s) {
        int[] map = new int[256];
        java.util.Arrays.fill(map, -1);
        int l = 0, r = 0, len = 0;
        while (r < s.length()) {
            char c = s.charAt(r);
            if (map[c] != -1) l = Math.max(map[c] + 1, l);
            map[c] = r;
            len = Math.max(len, r - l + 1);
            r++;
        }
        return len;
    }
}', '[{"input": "\\"abcabcbb\\"", "expected": "3", "sample": true}]', 'Sliding Window,Two Pointers,HashSet', 'https://takeuforward.org/data-structure/length-of-longest-substring-without-any-repeating-character/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (53, 53, 'Max Consecutive Ones III', 'Sliding Window', 'Standard Window', 'Medium', 'Maximum number of consecutive 1s if you can flip at most k 0s.', 'Input: nums = [1,1,1,0,0,0,1,1,1,1,0], k = 2
Output: 6', '1 <= nums.length <= 10^5
0 <= k <= nums.length', 'Expand r; if zeroes > k, increment l.', 'public class Solution {
    public int longestOnes(int[] nums, int k) {
        int l = 0, zeroes = 0, max = 0;
        for (int r = 0; r < nums.length; r++) {
            if (nums[r] == 0) zeroes++;
            while (zeroes > k) { if (nums[l] == 0) zeroes--; l++; }
            max = Math.max(max, r - l + 1);
        }
        return max;
    }
}', 'class Solution:
    def longestOnes(self, nums: list[int], k: int) -> int:
        pass', 'class Solution {
public:
    int longestOnes(vector<int>& nums, int k) {}
};', 'function longestOnes(nums, k) {}', 'public class Solution {
    public int longestOnes(int[] nums, int k) {
        int l = 0, zeroes = 0, max = 0;
        for (int r = 0; r < nums.length; r++) {
            if (nums[r] == 0) zeroes++;
            while (zeroes > k) { if (nums[l] == 0) zeroes--; l++; }
            max = Math.max(max, r - l + 1);
        }
        return max;
    }
}', '[{"input": "[1,1,1,0,0,0,1,1,1,1,0], 2", "expected": "6", "sample": true}]', 'Sliding Window,Two Pointers', 'https://takeuforward.org/arrays/max-consecutive-ones-iii/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (54, 54, 'Container With Most Water', 'Two Pointers', 'Two Pointers Problems', 'Medium', 'Find two lines that together with x-axis form container holding maximum water.', 'Input: height = [1,8,6,2,5,4,8,3,7]
Output: 49', '2 <= height.length <= 10^5', 'Pointers at left and right, move pointer with smaller height.', 'public class Solution {
    public int maxArea(int[] height) {
        int l = 0, r = height.length - 1, max = 0;
        while (l < r) {
            max = Math.max(max, Math.min(height[l], height[r]) * (r - l));
            if (height[l] < height[r]) l++; else r--;
        }
        return max;
    }
}', 'class Solution:
    def maxArea(self, height: list[int]) -> int:
        pass', 'class Solution {
public:
    int maxArea(vector<int>& height) {}
};', 'function maxArea(height) {}', 'public class Solution {
    public int maxArea(int[] height) {
        int l = 0, r = height.length - 1, max = 0;
        while (l < r) {
            max = Math.max(max, Math.min(height[l], height[r]) * (r - l));
            if (height[l] < height[r]) l++; else r--;
        }
        return max;
    }
}', '[{"input": "[1,8,6,2,5,4,8,3,7]", "expected": "49", "sample": true}]', 'Two Pointers,Greedy', 'https://takeuforward.org/data-structure/container-with-most-water/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (55, 55, 'Assign Cookies', 'Greedy', 'Easy Greedy', 'Easy', 'Maximize number of satisfied children given greed factors and cookie sizes.', 'Input: g = [1,2,3], s = [1,1]
Output: 1', '1 <= g.length, s.length <= 3 * 10^4', 'Sort both, two pointers.', 'public class Solution {
    public int findContentChildren(int[] g, int[] s) {
        java.util.Arrays.sort(g); java.util.Arrays.sort(s);
        int i = 0, j = 0;
        while (i < g.length && j < s.length) {
            if (s[j] >= g[i]) i++;
            j++;
        }
        return i;
    }
}', 'class Solution:
    def findContentChildren(self, g: list[int], s: list[int]) -> int:
        pass', 'class Solution {
public:
    int findContentChildren(vector<int>& g, vector<int>& s) {}
};', 'function findContentChildren(g, s) {}', 'public class Solution {
    public int findContentChildren(int[] g, int[] s) {
        java.util.Arrays.sort(g); java.util.Arrays.sort(s);
        int i = 0, j = 0;
        while (i < g.length && j < s.length) {
            if (s[j] >= g[i]) i++;
            j++;
        }
        return i;
    }
}', '[{"input": "[1,2,3], [1,1]", "expected": "1", "sample": true}]', 'Greedy,Sorting', 'https://takeuforward.org/data-structure/assign-cookies/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (56, 56, 'Jump Game', 'Greedy', 'Medium Greedy', 'Medium', 'Check if you can reach the last index from index 0.', 'Input: nums = [2,3,1,1,4]
Output: true', '1 <= nums.length <= 10^4', 'Maintain maxReach, fail if i > maxReach.', 'public class Solution {
    public boolean canJump(int[] nums) {
        int maxReach = 0;
        for (int i = 0; i < nums.length; i++) {
            if (i > maxReach) return false;
            maxReach = Math.max(maxReach, i + nums[i]);
        }
        return true;
    }
}', 'class Solution:
    def canJump(self, nums: list[int]) -> bool:
        pass', 'class Solution {
public:
    bool canJump(vector<int>& nums) {}
};', 'function canJump(nums) {}', 'public class Solution {
    public boolean canJump(int[] nums) {
        int maxReach = 0;
        for (int i = 0; i < nums.length; i++) {
            if (i > maxReach) return false;
            maxReach = Math.max(maxReach, i + nums[i]);
        }
        return true;
    }
}', '[{"input": "[2,3,1,1,4]", "expected": "true", "sample": true}, {"input": "[3,2,1,0,4]", "expected": "false", "sample": true}]', 'Greedy,Dynamic Programming', 'https://takeuforward.org/data-structure/jump-game-i/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (57, 57, 'Binary Tree Inorder Traversal', 'Trees', 'Tree Traversals', 'Easy', 'Return inorder traversal of binary tree nodes'' values.', 'Input: root = [1,null,2,3]
Output: [1,3,2]', '0 <= nodes <= 100', 'Left -> Root -> Right.', 'public class Solution {
    public java.util.List<Integer> inorderTraversal(TreeNode root) {
        java.util.List<Integer> res = new java.util.ArrayList<>();
        inorder(root, res); return res;
    }
    private void inorder(TreeNode n, java.util.List<Integer> res) {
        if (n == null) return;
        inorder(n.left, res); res.add(n.val); inorder(n.right, res);
    }
}', 'class Solution:
    def inorderTraversal(self, root) -> list[int]:
        pass', 'class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {}
};', 'function inorderTraversal(root) {}', 'public class Solution {
    public java.util.List<Integer> inorderTraversal(TreeNode root) {
        java.util.List<Integer> res = new java.util.ArrayList<>();
        inorder(root, res); return res;
    }
    private void inorder(TreeNode n, java.util.List<Integer> res) {
        if (n == null) return;
        inorder(n.left, res); res.add(n.val); inorder(n.right, res);
    }
}', '[{"input": "[1,null,2,3]", "expected": "[1,3,2]", "sample": true}]', 'Trees,DFS', 'https://takeuforward.org/data-structure/inorder-traversal-of-binary-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (58, 58, 'Maximum Depth of Binary Tree', 'Trees', 'Tree Properties', 'Easy', 'Return maximum depth of binary tree.', 'Input: root = [3,9,20,null,null,15,7]
Output: 3', '0 <= nodes <= 10^4', '1 + max(depth(left), depth(right)).', 'public class Solution {
    public int maxDepth(TreeNode root) {
        if (root == null) return 0;
        return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
    }
}', 'class Solution:
    def maxDepth(self, root) -> int:
        pass', 'class Solution {
public:
    int maxDepth(TreeNode* root) {}
};', 'function maxDepth(root) {}', 'public class Solution {
    public int maxDepth(TreeNode root) {
        if (root == null) return 0;
        return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
    }
}', '[{"input": "[3,9,20,null,null,15,7]", "expected": "3", "sample": true}]', 'Trees,DFS', 'https://takeuforward.org/data-structure/maximum-depth-of-a-binary-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (59, 59, 'Lowest Common Ancestor of Binary Tree', 'Trees', 'Tree Properties', 'Medium', 'Find lowest common ancestor of two nodes p and q.', 'Input: root = [3,5,1,6,2,0,8], p = 5, q = 1
Output: 3', '2 <= nodes <= 10^5', 'If root is null or p or q return root; if left and right non-null return root.', 'public class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || root == p || root == q) return root;
        TreeNode l = lowestCommonAncestor(root.left, p, q);
        TreeNode r = lowestCommonAncestor(root.right, p, q);
        if (l != null && r != null) return root;
        return l != null ? l : r;
    }
}', 'class Solution:
    def lowestCommonAncestor(self, root, p, q):
        pass', 'class Solution {
public:
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {}
};', 'function lowestCommonAncestor(root, p, q) {}', 'public class Solution {
    public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
        if (root == null || root == p || root == q) return root;
        TreeNode l = lowestCommonAncestor(root.left, p, q);
        TreeNode r = lowestCommonAncestor(root.right, p, q);
        if (l != null && r != null) return root;
        return l != null ? l : r;
    }
}', '[{"input": "[3,5,1,6,2,0,8], 5, 1", "expected": "3", "sample": true}]', 'Trees,DFS', 'https://takeuforward.org/data-structure/lowest-common-ancestor-for-two-given-nodes/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (60, 60, 'Search in BST', 'Binary Search Tree', 'BST Basics', 'Easy', 'Search for value val in BST and return subtree.', 'Input: root = [4,2,7,1,3], val = 2
Output: [2,1,3]', '1 <= nodes <= 5000', 'val < root.val ? search(left) : search(right).', 'public class Solution {
    public TreeNode searchBST(TreeNode root, int val) {
        while (root != null && root.val != val) root = val < root.val ? root.left : root.right;
        return root;
    }
}', 'class Solution:
    def searchBST(self, root, val: int):
        pass', 'class Solution {
public:
    TreeNode* searchBST(TreeNode* root, int val) {}
};', 'function searchBST(root, val) {}', 'public class Solution {
    public TreeNode searchBST(TreeNode root, int val) {
        while (root != null && root.val != val) root = val < root.val ? root.left : root.right;
        return root;
    }
}', '[{"input": "[4,2,7,1,3], 2", "expected": "[2,1,3]", "sample": true}]', 'Binary Search Tree,Tree', 'https://takeuforward.org/data-structure/search-in-a-binary-search-tree-bst/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (61, 61, 'Validate Binary Search Tree', 'Binary Search Tree', 'BST Validation', 'Medium', 'Determine if binary tree is valid BST.', 'Input: root = [2,1,3]
Output: true', '1 <= nodes <= 10^4', 'Recursively validate node.val is strictly between (min, max).', 'public class Solution {
    public boolean isValidBST(TreeNode root) {
        return val(root, Long.MIN_VALUE, Long.MAX_VALUE);
    }
    private boolean val(TreeNode n, long min, long max) {
        if (n == null) return true;
        if (n.val <= min || n.val >= max) return false;
        return val(n.left, min, n.val) && val(n.right, n.val, max);
    }
}', 'class Solution:
    def isValidBST(self, root) -> bool:
        pass', 'class Solution {
public:
    bool isValidBST(TreeNode* root) {}
};', 'function isValidBST(root) {}', 'public class Solution {
    public boolean isValidBST(TreeNode root) {
        return val(root, Long.MIN_VALUE, Long.MAX_VALUE);
    }
    private boolean val(TreeNode n, long min, long max) {
        if (n == null) return true;
        if (n.val <= min || n.val >= max) return false;
        return val(n.left, min, n.val) && val(n.right, n.val, max);
    }
}', '[{"input": "[2,1,3]", "expected": "true", "sample": true}]', 'Binary Search Tree,Tree,DFS', 'https://takeuforward.org/data-structure/check-if-a-tree-is-a-bst-or-bt/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (62, 62, 'Kth Largest Element in an Array', 'Heaps', 'Heap Problems', 'Medium', 'Return kth largest element in array using min-heap.', 'Input: nums = [3,2,1,5,6,4], k = 2
Output: 5', '1 <= k <= nums.length <= 10^5', 'Min-heap of size k.', 'public class Solution {
    public int findKthLargest(int[] nums, int k) {
        java.util.PriorityQueue<Integer> pq = new java.util.PriorityQueue<>();
        for (int x : nums) { pq.add(x); if (pq.size() > k) pq.poll(); }
        return pq.peek();
    }
}', 'class Solution:
    def findKthLargest(self, nums: list[int], k: int) -> int:
        pass', 'class Solution {
public:
    int findKthLargest(vector<int>& nums, int k) {}
};', 'function findKthLargest(nums, k) {}', 'public class Solution {
    public int findKthLargest(int[] nums, int k) {
        java.util.PriorityQueue<Integer> pq = new java.util.PriorityQueue<>();
        for (int x : nums) { pq.add(x); if (pq.size() > k) pq.poll(); }
        return pq.peek();
    }
}', '[{"input": "[3,2,1,5,6,4], 2", "expected": "5", "sample": true}]', 'Heaps,Priority Queue,Sorting', 'https://takeuforward.org/data-structure/kth-largest-smallest-element-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (63, 63, 'Number of Islands', 'Graphs', 'BFS / DFS Problems', 'Medium', 'Return number of connected components of ''1''s (islands) in 2D binary grid.', 'Input: grid = [["1","1","0"],["1","1","0"],["0","0","1"]]
Output: 2', '1 <= m, n <= 300', 'Traverse grid; on ''1'', run DFS/BFS to sink island, increment count.', 'public class Solution {
    public int numIslands(char[][] grid) {
        int cnt = 0;
        for (int i = 0; i < grid.length; i++) for (int j = 0; j < grid[0].length; j++) {
            if (grid[i][j] == ''1'') { dfs(grid, i, j); cnt++; }
        }
        return cnt;
    }
    private void dfs(char[][] g, int r, int c) {
        if (r < 0 || c < 0 || r >= g.length || c >= g[0].length || g[r][c] != ''1'') return;
        g[r][c] = ''0'';
        dfs(g, r+1, c); dfs(g, r-1, c); dfs(g, r, c+1); dfs(g, r, c-1);
    }
}', 'class Solution:
    def numIslands(self, grid: list[list[str]]) -> int:
        pass', 'class Solution {
public:
    int numIslands(vector<vector<char>>& grid) {}
};', 'function numIslands(grid) {}', 'public class Solution {
    public int numIslands(char[][] grid) {
        int cnt = 0;
        for (int i = 0; i < grid.length; i++) for (int j = 0; j < grid[0].length; j++) {
            if (grid[i][j] == ''1'') { dfs(grid, i, j); cnt++; }
        }
        return cnt;
    }
    private void dfs(char[][] g, int r, int c) {
        if (r < 0 || c < 0 || r >= g.length || c >= g[0].length || g[r][c] != ''1'') return;
        g[r][c] = ''0'';
        dfs(g, r+1, c); dfs(g, r-1, c); dfs(g, r, c+1); dfs(g, r, c-1);
    }
}', '[{"input": "[[\\"1\\",\\"1\\",\\"0\\"],[\\"1\\",\\"1\\",\\"0\\"],[\\"0\\",\\"0\\",\\"1\\"]]", "expected": "2", "sample": true}]', 'Graphs,DFS,BFS', 'https://takeuforward.org/data-structure/number-of-islands/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (64, 64, 'Rotting Oranges', 'Graphs', 'BFS / DFS Problems', 'Medium', 'Minimum minutes until no cell has a fresh orange, or -1 if impossible.', 'Input: grid = [[2,1,1],[1,1,0],[0,1,1]]
Output: 4', '1 <= m, n <= 10', 'Multi-source BFS from all initial 2s.', 'public class Solution {
    public int orangesRotting(int[][] grid) {
        int m = grid.length, n = grid[0].length, fresh = 0;
        java.util.Queue<int[]> q = new java.util.LinkedList<>();
        for (int i = 0; i < m; i++) for (int j = 0; j < n; j++) {
            if (grid[i][j] == 2) q.offer(new int[]{i, j});
            else if (grid[i][j] == 1) fresh++;
        }
        if (fresh == 0) return 0;
        int mins = 0, dirs[][] = {{0,1},{0,-1},{1,0},{-1,0}};
        while (!q.isEmpty()) {
            int sz = q.size(); boolean rotted = false;
            for (int i = 0; i < sz; i++) {
                int[] cur = q.poll();
                for (int[] d : dirs) {
                    int nr = cur[0] + d[0], nc = cur[1] + d[1];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 1) {
                        grid[nr][nc] = 2; q.offer(new int[]{nr, nc}); fresh--; rotted = true;
                    }
                }
            }
            if (rotted) mins++;
        }
        return fresh == 0 ? mins : -1;
    }
}', 'class Solution:
    def orangesRotting(self, grid: list[list[int]]) -> int:
        pass', 'class Solution {
public:
    int orangesRotting(vector<vector<int>>& grid) {}
};', 'function orangesRotting(grid) {}', 'public class Solution {
    public int orangesRotting(int[][] grid) {
        int m = grid.length, n = grid[0].length, fresh = 0;
        java.util.Queue<int[]> q = new java.util.LinkedList<>();
        for (int i = 0; i < m; i++) for (int j = 0; j < n; j++) {
            if (grid[i][j] == 2) q.offer(new int[]{i, j});
            else if (grid[i][j] == 1) fresh++;
        }
        if (fresh == 0) return 0;
        int mins = 0, dirs[][] = {{0,1},{0,-1},{1,0},{-1,0}};
        while (!q.isEmpty()) {
            int sz = q.size(); boolean rotted = false;
            for (int i = 0; i < sz; i++) {
                int[] cur = q.poll();
                for (int[] d : dirs) {
                    int nr = cur[0] + d[0], nc = cur[1] + d[1];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 1) {
                        grid[nr][nc] = 2; q.offer(new int[]{nr, nc}); fresh--; rotted = true;
                    }
                }
            }
            if (rotted) mins++;
        }
        return fresh == 0 ? mins : -1;
    }
}', '[{"input": "[[2,1,1],[1,1,0],[0,1,1]]", "expected": "4", "sample": true}]', 'Graphs,BFS', 'https://takeuforward.org/data-structure/rotton-oranges-min-time-to-rot-all-oranges-bfs/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (65, 65, 'Climbing Stairs', 'Dynamic Programming', '1D DP', 'Easy', 'Distinct ways to climb n stairs if you can take 1 or 2 steps each time.', 'Input: n = 3
Output: 3
Explanation: 1+1+1, 1+2, 2+1.', '1 <= n <= 45', 'dp[i] = dp[i-1] + dp[i-2].', 'public class Solution {
    public int climbStairs(int n) {
        if (n <= 2) return n;
        int a = 1, b = 2;
        for (int i = 3; i <= n; i++) { int c = a + b; a = b; b = c; }
        return b;
    }
}', 'class Solution:
    def climbStairs(self, n: int) -> int:
        pass', 'class Solution {
public:
    int climbStairs(int n) {}
};', 'function climbStairs(n) {}', 'public class Solution {
    public int climbStairs(int n) {
        if (n <= 2) return n;
        int a = 1, b = 2;
        for (int i = 3; i <= n; i++) { int c = a + b; a = b; b = c; }
        return b;
    }
}', '[{"input": "3", "expected": "3", "sample": true}, {"input": "2", "expected": "2", "sample": true}]', 'Dynamic Programming,Math', 'https://takeuforward.org/data-structure/dynamic-programming-climbing-stairs/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (66, 66, 'House Robber', 'Dynamic Programming', '1D DP', 'Medium', 'Maximum money you can rob from houses along street without robbing two adjacent houses.', 'Input: nums = [2,7,9,3,1]
Output: 12', '1 <= nums.length <= 100', 'dp[i] = max(dp[i-1], dp[i-2] + nums[i]).', 'public class Solution {
    public int rob(int[] nums) {
        int p1 = 0, p2 = 0;
        for (int x : nums) { int c = Math.max(p1, p2 + x); p2 = p1; p1 = c; }
        return p1;
    }
}', 'class Solution:
    def rob(self, nums: list[int]) -> int:
        pass', 'class Solution {
public:
    int rob(vector<int>& nums) {}
};', 'function rob(nums) {}', 'public class Solution {
    public int rob(int[] nums) {
        int p1 = 0, p2 = 0;
        for (int x : nums) { int c = Math.max(p1, p2 + x); p2 = p1; p1 = c; }
        return p1;
    }
}', '[{"input": "[2,7,9,3,1]", "expected": "12", "sample": true}]', 'Dynamic Programming', 'https://takeuforward.org/data-structure/maximum-sum-of-non-adjacent-elements-dp-5/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (67, 67, 'Coin Change', 'Dynamic Programming', 'DP on Subsequences', 'Medium', 'Fewest coins needed to make up amount, or -1 if impossible.', 'Input: coins = [1,2,5], amount = 11
Output: 3
Explanation: 5 + 5 + 1', '1 <= coins.length <= 12
0 <= amount <= 10^4', 'dp[i] = min(dp[i], dp[i - c] + 1).', 'public class Solution {
    public int coinChange(int[] coins, int amount) {
        int[] dp = new int[amount + 1];
        java.util.Arrays.fill(dp, amount + 1);
        dp[0] = 0;
        for (int i = 1; i <= amount; i++) for (int c : coins) if (i >= c) dp[i] = Math.min(dp[i], dp[i - c] + 1);
        return dp[amount] > amount ? -1 : dp[amount];
    }
}', 'class Solution:
    def coinChange(self, coins: list[int], amount: int) -> int:
        pass', 'class Solution {
public:
    int coinChange(vector<int>& coins, int amount) {}
};', 'function coinChange(coins, amount) {}', 'public class Solution {
    public int coinChange(int[] coins, int amount) {
        int[] dp = new int[amount + 1];
        java.util.Arrays.fill(dp, amount + 1);
        dp[0] = 0;
        for (int i = 1; i <= amount; i++) for (int c : coins) if (i >= c) dp[i] = Math.min(dp[i], dp[i - c] + 1);
        return dp[amount] > amount ? -1 : dp[amount];
    }
}', '[{"input": "[1,2,5], 11", "expected": "3", "sample": true}]', 'Dynamic Programming', 'https://takeuforward.org/data-structure/coin-change-2-dp-22/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (68, 68, 'Longest Common Subsequence', 'Dynamic Programming', 'DP on Strings', 'Medium', 'Length of longest common subsequence between text1 and text2.', 'Input: text1 = "abcde", text2 = "ace"
Output: 3', '1 <= text1.length, text2.length <= 1000', '2D DP grid: if equal 1 + dp[i-1][j-1], else max(dp[i-1][j], dp[i][j-1]).', 'public class Solution {
    public int longestCommonSubsequence(String s1, String s2) {
        int m = s1.length(), n = s2.length();
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 1; i <= m; i++) for (int j = 1; j <= n; j++) {
            if (s1.charAt(i - 1) == s2.charAt(j - 1)) dp[i][j] = 1 + dp[i - 1][j - 1];
            else dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
        }
        return dp[m][n];
    }
}', 'class Solution:
    def longestCommonSubsequence(self, s1: str, s2: str) -> int:
        pass', 'class Solution {
public:
    int longestCommonSubsequence(string s1, string s2) {}
};', 'function longestCommonSubsequence(s1, s2) {}', 'public class Solution {
    public int longestCommonSubsequence(String s1, String s2) {
        int m = s1.length(), n = s2.length();
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 1; i <= m; i++) for (int j = 1; j <= n; j++) {
            if (s1.charAt(i - 1) == s2.charAt(j - 1)) dp[i][j] = 1 + dp[i - 1][j - 1];
            else dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
        }
        return dp[m][n];
    }
}', '[{"input": "\\"abcde\\", \\"ace\\"", "expected": "3", "sample": true}]', 'Dynamic Programming,Strings', 'https://takeuforward.org/data-structure/longest-common-subsequence-dp-25/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (69, 69, 'Implement Trie (Prefix Tree)', 'Tries', 'Trie Basics', 'Medium', 'Implement prefix tree with insert, search, and startsWith.', 'Input: insert("apple"), search("apple"), search("app"), startsWith("app")
Output: true, false, true', '1 <= length <= 2000', 'Array of 26 children links per node and boolean flag.', 'public class Trie {
    class Node { Node[] links = new Node[26]; boolean flag = false; }
    private Node root = new Node();
    public void insert(String word) {
        Node n = root;
        for (char c : word.toCharArray()) {
            if (n.links[c - ''a''] == null) n.links[c - ''a''] = new Node();
            n = n.links[c - ''a''];
        }
        n.flag = true;
    }
    public boolean search(String word) {
        Node n = root;
        for (char c : word.toCharArray()) { if (n.links[c - ''a''] == null) return false; n = n.links[c - ''a'']; }
        return n.flag;
    }
    public boolean startsWith(String prefix) {
        Node n = root;
        for (char c : prefix.toCharArray()) { if (n.links[c - ''a''] == null) return false; n = n.links[c - ''a'']; }
        return true;
    }
}', 'class Trie:
    def __init__(self):
        pass', 'class Trie {
public:
    Trie() {}
};', 'class Trie {
    constructor() {}
}', 'public class Trie {
    class Node { Node[] links = new Node[26]; boolean flag = false; }
    private Node root = new Node();
    public void insert(String word) {
        Node n = root;
        for (char c : word.toCharArray()) {
            if (n.links[c - ''a''] == null) n.links[c - ''a''] = new Node();
            n = n.links[c - ''a''];
        }
        n.flag = true;
    }
    public boolean search(String word) {
        Node n = root;
        for (char c : word.toCharArray()) { if (n.links[c - ''a''] == null) return false; n = n.links[c - ''a'']; }
        return n.flag;
    }
    public boolean startsWith(String prefix) {
        Node n = root;
        for (char c : prefix.toCharArray()) { if (n.links[c - ''a''] == null) return false; n = n.links[c - ''a'']; }
        return true;
    }
}', '[{"input": "insert(\\"apple\\"), search(\\"apple\\")", "expected": "true", "sample": true}]', 'Tries,Design', 'https://takeuforward.org/data-structure/implement-trie-1/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (70, 70, 'Disjoint Set Union (DSU by Rank)', 'Advanced Data Structures', 'Disjoint Set', 'Medium', 'Implement Disjoint Set (Union-Find) with path compression and union by rank.', 'Input: find(1), union(1, 2), connected(1, 2)
Output: true', '1 <= nodes <= 10^5', 'Parent array with path compression parent[x] = find(parent[x]).', 'public class DSU {
    int[] parent, rank;
    public DSU(int n) {
        parent = new int[n]; rank = new int[n];
        for (int i = 0; i < n; i++) parent[i] = i;
    }
    public int find(int i) {
        if (parent[i] == i) return i;
        return parent[i] = find(parent[i]);
    }
    public boolean union(int i, int j) {
        int rootI = find(i), rootJ = find(j);
        if (rootI == rootJ) return false;
        if (rank[rootI] < rank[rootJ]) parent[rootI] = rootJ;
        else if (rank[rootI] > rank[rootJ]) parent[rootJ] = rootI;
        else { parent[rootJ] = rootI; rank[rootI]++; }
        return true;
    }
}', 'class DSU:
    def __init__(self, n: int):
        pass', 'class DSU {
public:
    DSU(int n) {}
};', 'class DSU {
    constructor(n) {}
}', 'public class DSU {
    int[] parent, rank;
    public DSU(int n) {
        parent = new int[n]; rank = new int[n];
        for (int i = 0; i < n; i++) parent[i] = i;
    }
    public int find(int i) {
        if (parent[i] == i) return i;
        return parent[i] = find(parent[i]);
    }
    public boolean union(int i, int j) {
        int rootI = find(i), rootJ = find(j);
        if (rootI == rootJ) return false;
        if (rank[rootI] < rank[rootJ]) parent[rootI] = rootJ;
        else if (rank[rootI] > rank[rootJ]) parent[rootJ] = rootI;
        else { parent[rootJ] = rootI; rank[rootI]++; }
        return true;
    }
}', '[{"input": "union(1, 2), find(1) == find(2)", "expected": "true", "sample": true}]', 'Advanced Data Structures,Graph', 'https://takeuforward.org/data-structure/disjoint-set-union-by-rank-union-by-size-path-compression-g-46/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (71, 71, 'Segment Tree Range Minimum Query', 'Advanced Data Structures', 'Segment Tree', 'Hard', 'Build segment tree to answer range minimum queries in O(log n) time.', 'Input: nums = [1, 3, 2, 7, 9, 11], query(1, 4)
Output: 2', '1 <= nums.length <= 10^5', 'Divide range in halves [l, mid] and [mid+1, r].', 'public class SegmentTree {
    int[] tree, a; int n;
    public SegmentTree(int[] arr) {
        a = arr; n = arr.length; tree = new int[4 * n];
        build(0, 0, n - 1);
    }
    private void build(int node, int l, int r) {
        if (l == r) { tree[node] = a[l]; return; }
        int m = l + (r - l) / 2;
        build(2 * node + 1, l, m); build(2 * node + 2, m + 1, r);
        tree[node] = Math.min(tree[2 * node + 1], tree[2 * node + 2]);
    }
    public int query(int ql, int qr) { return query(0, 0, n - 1, ql, qr); }
    private int query(int node, int l, int r, int ql, int qr) {
        if (ql <= l && r <= qr) return tree[node];
        if (r < ql || l > qr) return Integer.MAX_VALUE;
        int m = l + (r - l) / 2;
        return Math.min(query(2 * node + 1, l, m, ql, qr), query(2 * node + 2, m + 1, r, ql, qr));
    }
}', 'class SegmentTree:
    def __init__(self, arr: list[int]):
        pass', 'class SegmentTree {
public:
    SegmentTree(vector<int>& arr) {}
};', 'class SegmentTree {
    constructor(arr) {}
}', 'public class SegmentTree {
    int[] tree, a; int n;
    public SegmentTree(int[] arr) {
        a = arr; n = arr.length; tree = new int[4 * n];
        build(0, 0, n - 1);
    }
    private void build(int node, int l, int r) {
        if (l == r) { tree[node] = a[l]; return; }
        int m = l + (r - l) / 2;
        build(2 * node + 1, l, m); build(2 * node + 2, m + 1, r);
        tree[node] = Math.min(tree[2 * node + 1], tree[2 * node + 2]);
    }
    public int query(int ql, int qr) { return query(0, 0, n - 1, ql, qr); }
    private int query(int node, int l, int r, int ql, int qr) {
        if (ql <= l && r <= qr) return tree[node];
        if (r < ql || l > qr) return Integer.MAX_VALUE;
        int m = l + (r - l) / 2;
        return Math.min(query(2 * node + 1, l, m, ql, qr), query(2 * node + 2, m + 1, r, ql, qr));
    }
}', '[{"input": "[1, 3, 2, 7, 9, 11], query(1, 4)", "expected": "2", "sample": true}]', 'Advanced Data Structures,Segment Tree', 'https://takeuforward.org/data-structure/segment-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (72, 72, 'Pascal''s Triangle', 'Arrays', 'Hard Array Problems', 'Easy', 'Generate first numRows of Pascal''s triangle.', 'Input: numRows = 5
Output: [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]', '1 <= numRows <= 30', 'Row elements are combination C(n, k).', 'public class Solution {
    // Complete solution for Pascal''s Triangle
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Arrays,Math', 'https://takeuforward.org/data-structure/program-to-generate-pascals-triangle/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (73, 73, '4 Sum', 'Arrays', 'Hard Array Problems', 'Medium', 'Find all unique quadruplets summing to target.', 'Input: nums = [1,0,-1,0,-2,2], target = 0
Output: [[-2,-1,1,2],[-2,0,0,2],[-1,0,0,1]]', '1 <= nums.length <= 200', 'Two loops + two pointers.', 'public class Solution {
    // Complete solution for 4 Sum
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Arrays,Two Pointers', 'https://takeuforward.org/data-structure/4-sum-find-quads-that-add-up-to-a-target-value/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (74, 74, 'Find Repeating and Missing Number', 'Arrays', 'Hard Array Problems', 'Hard', 'Given array of size n containing numbers from 1 to n with one repeating and one missing, find them.', 'Input: nums = [3, 1, 2, 5, 3]
Output: Repeating: 3, Missing: 4', '2 <= n <= 10^5', 'Use math equations sum and sum of squares or XOR.', 'public class Solution {
    // Complete solution for Find Repeating and Missing Number
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Arrays,Math', 'https://takeuforward.org/data-structure/find-the-repeating-and-missing-numbers/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (75, 75, 'Count Inversions in an Array', 'Arrays', 'Hard Array Problems', 'Hard', 'Count inversions where i < j and nums[i] > nums[j].', 'Input: nums = [5, 3, 2, 4, 1]
Output: 8', '1 <= nums.length <= 10^5', 'Modified Merge Sort.', 'public class Solution {
    // Complete solution for Count Inversions in an Array
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Arrays,Divide and Conquer', 'https://takeuforward.org/data-structure/count-inversions-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (76, 76, 'Reverse Pairs', 'Arrays', 'Hard Array Problems', 'Hard', 'Count reverse pairs where i < j and nums[i] > 2 * nums[j].', 'Input: nums = [1,3,2,3,1]
Output: 2', '1 <= nums.length <= 5 * 10^4', 'Modified Merge Sort count.', 'public class Solution {
    // Complete solution for Reverse Pairs
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Arrays,Merge Sort', 'https://takeuforward.org/data-structure/count-reverse-pairs/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (77, 77, 'Lower Bound in Sorted Array', 'Binary Search', 'BS on 1D Arrays', 'Easy', 'Find smallest index i such that nums[i] >= x.', 'Input: nums = [1, 2, 8, 10, 11, 12, 19], x = 5
Output: 2', '1 <= nums.length <= 10^5', 'Binary search lower bound.', 'public class Solution {
    // Complete solution for Lower Bound in Sorted Array
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search', 'https://takeuforward.org/arrays/implement-lower-bound-bs-2/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (78, 78, 'Upper Bound in Sorted Array', 'Binary Search', 'BS on 1D Arrays', 'Easy', 'Find smallest index i such that nums[i] > x.', 'Input: nums = [2, 3, 6, 7, 8, 8, 11, 11, 12], x = 8
Output: 6', '1 <= nums.length <= 10^5', 'Binary search upper bound.', 'public class Solution {
    // Complete solution for Upper Bound in Sorted Array
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search', 'https://takeuforward.org/arrays/implement-upper-bound/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (79, 79, 'Find Peak Element', 'Binary Search', 'BS on 1D Arrays', 'Medium', 'Find peak element strictly greater than neighbors.', 'Input: nums = [1,2,3,1]
Output: 2', '1 <= nums.length <= 1000', 'If nums[mid] < nums[mid+1] peak is to the right.', 'public class Solution {
    // Complete solution for Find Peak Element
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search', 'https://takeuforward.org/data-structure/peak-element-in-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (80, 80, 'Minimum Days to Make M Bouquets', 'Binary Search', 'BS on Answers', 'Medium', 'Find minimum days to make m bouquets of k adjacent flowers.', 'Input: bloomDay = [1,10,3,10,2], m = 3, k = 1
Output: 3', '1 <= bloomDay.length <= 10^5', 'Binary search on days [min(bloomDay), max(bloomDay)].', 'public class Solution {
    // Complete solution for Minimum Days to Make M Bouquets
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search', 'https://takeuforward.org/data-structure/minimum-days-to-make-m-bouquets/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (81, 81, 'Capacity to Ship Packages within D Days', 'Binary Search', 'BS on Answers', 'Medium', 'Minimum ship capacity to convey all packages within d days.', 'Input: weights = [1,2,3,4,5,6,7,8,9,10], days = 5
Output: 15', '1 <= days <= weights.length <= 5 * 10^4', 'Binary search on capacity [max(weights), sum(weights)].', 'public class Solution {
    // Complete solution for Capacity to Ship Packages within D Days
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search', 'https://takeuforward.org/data-structure/capacity-to-ship-packages-within-d-days/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (82, 82, 'Aggressive Cows', 'Binary Search', 'BS on Answers', 'Hard', 'Assign cows to stalls such that minimum distance between any two cows is maximum.', 'Input: stalls = [1, 2, 8, 4, 9], k = 3
Output: 3', '2 <= stalls.length <= 10^5', 'Binary search on distance [1, max-min].', 'public class Solution {
    // Complete solution for Aggressive Cows
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search', 'https://takeuforward.org/data-structure/aggressive-cows-detailed-solution/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (83, 83, 'Book Allocation Problem', 'Binary Search', 'BS on Answers', 'Hard', 'Allocate books to m students such that maximum pages allocated is minimized.', 'Input: pages = [12, 34, 67, 90], m = 2
Output: 113', '1 <= pages.length <= 10^5', 'Binary search on pages [max(pages), sum(pages)].', 'public class Solution {
    // Complete solution for Book Allocation Problem
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search', 'https://takeuforward.org/data-structure/allocate-minimum-number-of-pages/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (84, 84, 'Median of Two Sorted Arrays', 'Binary Search', 'BS on 2D Arrays', 'Hard', 'Return median of two sorted arrays in O(log(min(m, n))) time.', 'Input: nums1 = [1,3], nums2 = [2]
Output: 2.0', '0 <= m, n <= 1000', 'Binary search on partition point of smaller array.', 'public class Solution {
    // Complete solution for Median of Two Sorted Arrays
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search,Divide and Conquer', 'https://takeuforward.org/data-structure/median-of-two-sorted-arrays-of-different-sizes/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (85, 85, 'Isomorphic Strings', 'Strings', 'Basic String Problems', 'Easy', 'Check if characters in s can be replaced to get t.', 'Input: s = "egg", t = "add"
Output: true', '1 <= s.length <= 5 * 10^4', 'Two maps/arrays for character mappings.', 'public class Solution {
    // Complete solution for Isomorphic Strings
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Strings,HashMap', 'https://takeuforward.org/data-structure/isomorphic-string/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (86, 86, 'Roman to Integer', 'Strings', 'Basic String Problems', 'Easy', 'Convert roman numeral to integer.', 'Input: s = "MCMXCIV"
Output: 1994', '1 <= s.length <= 15', 'Map Roman symbols, subtract if smaller precedes larger.', 'public class Solution {
    // Complete solution for Roman to Integer
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Strings,Math', 'https://takeuforward.org/data-structure/roman-to-integer/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (87, 87, 'String to Integer (atoi)', 'Strings', 'Medium String Problems', 'Medium', 'Convert a string to a 32-bit signed integer.', 'Input: s = "   -42"
Output: -42', '0 <= s.length <= 200', 'Handle whitespace, sign, overflow/underflow clamp.', 'public class Solution {
    // Complete solution for String to Integer (atoi)
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Strings', 'https://takeuforward.org/data-structure/string-to-integer-atoi/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (88, 88, 'Count Substrings with K Distinct Characters', 'Strings', 'Medium String Problems', 'Medium', 'Count substrings that have exactly k distinct characters.', 'Input: s = "pqpqs", k = 2
Output: 7', '1 <= s.length <= 10^5', 'atMost(k) - atMost(k - 1) sliding window.', 'public class Solution {
    // Complete solution for Count Substrings with K Distinct Characters
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Strings,Sliding Window', 'https://takeuforward.org/data-structure/count-number-of-substrings-with-exactly-k-distinct-characters/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (89, 89, 'Delete Middle Node of Linked List', 'Linked List', '1D Linked List', 'Medium', 'Delete middle node of linked list and return head.', 'Input: head = [1,3,4,7,1,2,6]
Output: [1,3,4,1,2,6]', '1 <= nodes <= 10^5', 'Fast and slow pointers with prev pointer.', 'public class Solution {
    // Complete solution for Delete Middle Node of Linked List
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Linked List,Two Pointers', 'https://takeuforward.org/data-structure/delete-the-middle-node-of-the-linked-list/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (90, 90, 'Check if Linked List is Palindrome', 'Linked List', 'Medium Linked List', 'Easy', 'Check if linked list values form palindrome.', 'Input: head = [1,2,2,1]
Output: true', '1 <= nodes <= 10^5', 'Find middle, reverse second half, compare.', 'public class Solution {
    // Complete solution for Check if Linked List is Palindrome
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Linked List,Two Pointers', 'https://takeuforward.org/data-structure/check-if-given-linked-list-is-plaindrome/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (91, 91, 'Intersection of Two Linked Lists', 'Linked List', 'Medium Linked List', 'Easy', 'Find node at which the two singly linked lists intersect.', 'Input: intersectVal = 8, listA = [4,1,8,4,5], listB = [5,6,1,8,4,5]
Output: Reference to node with value 8', '1 <= nodes <= 3 * 10^4', 'Switch heads when pointer reaches end.', 'public class Solution {
    // Complete solution for Intersection of Two Linked Lists
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Linked List,Two Pointers', 'https://takeuforward.org/data-structure/find-intersection-of-two-linked-lists/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (92, 92, 'Add Two Numbers Represented by Linked Lists', 'Linked List', 'Medium Linked List', 'Medium', 'Add two numbers given in reverse order in linked lists.', 'Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807.', '1 <= nodes <= 100', 'Simulate addition with carry.', 'public class Solution {
    // Complete solution for Add Two Numbers Represented by Linked Lists
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Linked List,Math', 'https://takeuforward.org/data-structure/add-two-numbers-represented-as-linked-list/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (93, 93, 'Reverse Nodes in k-Group', 'Linked List', 'Hard Linked List', 'Hard', 'Reverse nodes of a linked list k at a time.', 'Input: head = [1,2,3,4,5], k = 2
Output: [2,1,4,3,5]', '1 <= k <= nodes <= 5000', 'Count k nodes, reverse sublist, link recursively.', 'public class Solution {
    // Complete solution for Reverse Nodes in k-Group
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Linked List,Recursion', 'https://takeuforward.org/data-structure/reverse-linked-list-in-groups-of-size-k/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (94, 94, 'Rotate List', 'Linked List', 'Hard Linked List', 'Medium', 'Rotate list to right by k places.', 'Input: head = [1,2,3,4,5], k = 2
Output: [4,5,1,2,3]', '0 <= nodes <= 500', 'Connect tail to head to form ring, break at n - (k % n).', 'public class Solution {
    // Complete solution for Rotate List
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Linked List,Two Pointers', 'https://takeuforward.org/data-structure/rotate-a-linked-list/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (95, 95, 'Generate Parentheses', 'Recursion', 'Combinations & Permutations', 'Medium', 'Generate all combinations of well-formed parentheses for n pairs.', 'Input: n = 3
Output: ["((()))","(()())","(())()","()(())","()()()"]', '1 <= n <= 8', 'Backtrack adding ''('' if open < n, '')'' if close < open.', 'public class Solution {
    // Complete solution for Generate Parentheses
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Recursion,Backtracking,String', 'https://takeuforward.org/data-structure/generate-all-parenthesis/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (96, 96, 'Permutations', 'Recursion', 'Combinations & Permutations', 'Medium', 'Return all possible permutations of an array of distinct integers.', 'Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]', '1 <= nums.length <= 6', 'Backtracking with swap.', 'public class Solution {
    // Complete solution for Permutations
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Recursion,Backtracking', 'https://takeuforward.org/data-structure/print-all-permutations-of-a-string-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (97, 97, 'Palindrome Partitioning', 'Backtracking', 'Hard Backtracking', 'Medium', 'Partition string s such that every substring is a palindrome.', 'Input: s = "aab"
Output: [["a","a","b"],["aa","b"]]', '1 <= s.length <= 16', 'Backtrack over all palindrome prefixes.', 'public class Solution {
    // Complete solution for Palindrome Partitioning
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Backtracking,Dynamic Programming', 'https://takeuforward.org/data-structure/palindrome-partitioning/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (98, 98, 'Sudoku Solver', 'Backtracking', 'Hard Backtracking', 'Hard', 'Solve a 9x9 Sudoku puzzle by filling empty cells.', 'Input: 9x9 board with empty cells ''.''
Output: Completed valid Sudoku board', 'board is 9x9', 'Try numbers 1-9 in empty cell, validate row, col, 3x3 box.', 'public class Solution {
    // Complete solution for Sudoku Solver
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Backtracking,Matrix', 'https://takeuforward.org/data-structure/sudoku-solver/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (99, 99, 'Rat in a Maze', 'Backtracking', 'Hard Backtracking', 'Medium', 'Find all paths from (0,0) to (n-1, n-1) in maze.', 'Input: n = 4, m = [[1, 0, 0, 0], [1, 1, 0, 1], [1, 1, 0, 0], [0, 1, 1, 1]]
Output: ["DDRDRR", "DRDDRR"]', '2 <= n <= 5', 'DFS exploring ''D'', ''L'', ''R'', ''U'' with visited array.', 'public class Solution {
    // Complete solution for Rat in a Maze
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Backtracking,Graph', 'https://takeuforward.org/data-structure/rat-in-a-maze/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (100, 100, 'Single Number II', 'Bit Manipulation', 'Bit Manipulation Basics', 'Medium', 'Every element appears three times except for one. Find it.', 'Input: nums = [2,2,3,2]
Output: 3', '1 <= nums.length <= 3 * 10^4', 'Count bits at each position modulo 3 or use bit state machines.', 'public class Solution {
    // Complete solution for Single Number II
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Bit Manipulation', 'https://takeuforward.org/data-structure/single-number-ii-find-the-element-that-appears-once/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (101, 101, 'Single Number III', 'Bit Manipulation', 'Bit Manipulation Basics', 'Medium', 'Two elements appear once, all others twice. Find the two.', 'Input: nums = [1,2,1,3,2,5]
Output: [3,5]', '2 <= nums.length <= 3 * 10^4', 'Find rightmost set bit in XOR total to divide into two groups.', 'public class Solution {
    // Complete solution for Single Number III
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Bit Manipulation', 'https://takeuforward.org/data-structure/single-number-iii-find-the-two-numbers-that-appear-once/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (102, 102, 'Bitwise AND of Numbers Range', 'Bit Manipulation', 'Bit Manipulation Basics', 'Medium', 'Return bitwise AND of all numbers in [left, right].', 'Input: left = 5, right = 7
Output: 4', '0 <= left <= right <= 2^31 - 1', 'Find common binary prefix by shifting right.', 'public class Solution {
    // Complete solution for Bitwise AND of Numbers Range
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Bit Manipulation', 'https://takeuforward.org/data-structure/bitwise-and-of-numbers-range/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (103, 103, 'Implement Min Stack', 'Stack', 'Learning Stack', 'Medium', 'Design a stack that supports push, pop, top, and getMin in O(1) time.', 'Input: push(-2), push(0), push(-3), getMin(), pop(), top(), getMin()
Output: -3, 0, -2', 'Calls <= 3 * 10^4', 'Maintain min stack or store 2*val - min.', 'public class Solution {
    // Complete solution for Implement Min Stack
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Stack,Design', 'https://takeuforward.org/data-structure/implement-min-stack-o2n-and-on-space-complexity/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (104, 104, 'Largest Rectangle in Histogram', 'Stack', 'Monotonic Stack', 'Hard', 'Find area of largest rectangle in histogram heights.', 'Input: heights = [2,1,5,6,2,3]
Output: 10', '1 <= heights.length <= 10^5', 'Monotonic stack to find previous and next smaller elements.', 'public class Solution {
    // Complete solution for Largest Rectangle in Histogram
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Stack,Monotonic Stack', 'https://takeuforward.org/data-structure/area-of-largest-rectangle-in-histogram/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (105, 105, 'Sliding Window Maximum', 'Queue', 'Monotonic Queue', 'Hard', 'Return max value in sliding window of size k moving across nums.', 'Input: nums = [1,3,-1,-3,5,3,6,7], k = 3
Output: [3,3,5,5,6,7]', '1 <= nums.length <= 10^5', 'Monotonic decreasing deque storing indices.', 'public class Solution {
    // Complete solution for Sliding Window Maximum
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Queue,Monotonic Queue,Sliding Window', 'https://takeuforward.org/data-structure/sliding-window-maximum/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (106, 106, 'Asteroid Collision', 'Stack', 'Monotonic Stack', 'Medium', 'Find state of asteroids after all collisions.', 'Input: asteroids = [5,10,-5]
Output: [5,10]', '2 <= asteroids.length <= 10^4', 'Stack to simulate collisions between right and left moving asteroids.', 'public class Solution {
    // Complete solution for Asteroid Collision
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Stack,Simulation', 'https://takeuforward.org/data-structure/asteroid-collision/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (107, 107, 'Minimum Window Substring', 'Sliding Window', 'Standard Window', 'Hard', 'Find minimum window in s which contains all characters of t.', 'Input: s = "ADOBECODEBANC", t = "ABC"
Output: "BANC"', '1 <= s.length, t.length <= 10^5', 'Two pointers with frequency map and match counter.', 'public class Solution {
    // Complete solution for Minimum Window Substring
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Sliding Window,HashMap,String', 'https://takeuforward.org/data-structure/minimum-window-substring/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (108, 108, 'Longest Repeating Character Replacement', 'Sliding Window', 'Standard Window', 'Medium', 'Maximum length of substring containing same letter after replacing k chars.', 'Input: s = "AABABBA", k = 1
Output: 4', '1 <= s.length <= 10^5', 'Window valid when (window_len - max_freq) <= k.', 'public class Solution {
    // Complete solution for Longest Repeating Character Replacement
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Sliding Window,HashMap', 'https://takeuforward.org/data-structure/longest-repeating-character-replacement/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (109, 109, 'Fruit Into Baskets', 'Sliding Window', 'Standard Window', 'Medium', 'Find maximum fruits you can pick with at most 2 basket types.', 'Input: fruits = [1,2,1]
Output: 3', '1 <= fruits.length <= 10^5', 'Sliding window with at most 2 distinct elements.', 'public class Solution {
    // Complete solution for Fruit Into Baskets
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Sliding Window,Two Pointers', 'https://takeuforward.org/data-structure/fruits-into-baskets/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (110, 110, 'Non-overlapping Intervals', 'Greedy', 'Intervals Greedy', 'Medium', 'Find minimum number of intervals to remove to make rest non-overlapping.', 'Input: intervals = [[1,2],[2,3],[3,4],[1,3]]
Output: 1', '1 <= intervals.length <= 10^5', 'Sort by end time; keep intervals that end earliest.', 'public class Solution {
    // Complete solution for Non-overlapping Intervals
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Greedy,Sorting', 'https://takeuforward.org/data-structure/non-overlapping-intervals/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (111, 111, 'Gas Station (Circular Tour)', 'Greedy', 'Medium Greedy', 'Medium', 'Find starting gas station index to complete circular tour.', 'Input: gas = [1,2,3,4,5], cost = [3,4,5,1,2]
Output: 3', '1 <= gas.length <= 10^5', 'If total gas < total cost, return -1. Otherwise, reset start whenever current tank < 0.', 'public class Solution {
    // Complete solution for Gas Station (Circular Tour)
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Greedy,Arrays', 'https://takeuforward.org/data-structure/gas-station/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (112, 112, 'Candy Distribution', 'Greedy', 'Hard Greedy', 'Hard', 'Minimum candies to distribute such that higher rating gets more candies than neighbors.', 'Input: ratings = [1,0,2]
Output: 5
Explanation: [2,1,2]', '1 <= ratings.length <= 2 * 10^4', 'Left to right pass, then right to left pass.', 'public class Solution {
    // Complete solution for Candy Distribution
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Greedy,Arrays', 'https://takeuforward.org/data-structure/candy/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (113, 113, 'Binary Tree Level Order Traversal', 'Trees', 'Tree Traversals', 'Medium', 'Level order traversal of binary tree (BFS).', 'Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]', '0 <= nodes <= 2000', 'Queue BFS level by level.', 'public class Solution {
    // Complete solution for Binary Tree Level Order Traversal
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Trees,BFS', 'https://takeuforward.org/data-structure/level-order-traversal-of-a-binary-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (114, 114, 'Balanced Binary Tree', 'Trees', 'Tree Properties', 'Easy', 'Check if binary tree is height-balanced (height difference <= 1 at each node).', 'Input: root = [3,9,20,null,null,15,7]
Output: true', '0 <= nodes <= 5000', 'Bottom-up DFS returning -1 if unbalanced.', 'public class Solution {
    // Complete solution for Balanced Binary Tree
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Trees,DFS', 'https://takeuforward.org/data-structure/check-if-the-binary-tree-is-balanced-binary-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (115, 115, 'Symmetric Tree', 'Trees', 'Tree Properties', 'Easy', 'Check if binary tree is mirror of itself around center.', 'Input: root = [1,2,2,3,4,4,3]
Output: true', '1 <= nodes <= 1000', 'Recursively check isMirror(left, right).', 'public class Solution {
    // Complete solution for Symmetric Tree
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Trees,DFS', 'https://takeuforward.org/data-structure/check-for-symmetrical-binary-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (116, 116, 'Binary Tree Maximum Path Sum', 'Trees', 'Tree Properties', 'Hard', 'Maximum path sum of any non-empty path in binary tree.', 'Input: root = [-10,9,20,null,null,15,7]
Output: 42', '1 <= nodes <= 3 * 10^4', 'At each node, update max with node.val + leftGain + rightGain.', 'public class Solution {
    // Complete solution for Binary Tree Maximum Path Sum
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Trees,Dynamic Programming,DFS', 'https://takeuforward.org/data-structure/maximum-sum-path-in-binary-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (117, 117, 'Insert into a Binary Search Tree', 'Binary Search Tree', 'BST Basics', 'Medium', 'Insert value into BST and return root.', 'Input: root = [4,2,7,1,3], val = 5
Output: [4,2,7,1,3,5]', '0 <= nodes <= 10^4', 'Traverse down; attach new node at null leaf.', 'public class Solution {
    // Complete solution for Insert into a Binary Search Tree
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search Tree,Tree', 'https://takeuforward.org/data-structure/insert-a-given-node-in-binary-search-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (118, 118, 'Delete Node in a BST', 'Binary Search Tree', 'BST Basics', 'Medium', 'Delete node with given key in BST.', 'Input: root = [5,3,6,2,4,null,7], key = 3
Output: [5,4,6,2,null,null,7]', '0 <= nodes <= 10^4', 'Replace node with inorder successor if it has two children.', 'public class Solution {
    // Complete solution for Delete Node in a BST
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search Tree,Tree', 'https://takeuforward.org/data-structure/delete-a-node-in-binary-search-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (119, 119, 'Lowest Common Ancestor in BST', 'Binary Search Tree', 'BST Ancestry', 'Medium', 'Find LCA of nodes p and q in BST.', 'Input: root = [6,2,8,0,4,7,9], p = 2, q = 8
Output: 6', '2 <= nodes <= 10^5', 'If both p, q < root move left; if both > root move right; else root is LCA.', 'public class Solution {
    // Complete solution for Lowest Common Ancestor in BST
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search Tree,Tree', 'https://takeuforward.org/data-structure/lowest-common-ancestor-in-bst/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (120, 120, 'Kth Smallest Element in a BST', 'Binary Search Tree', 'BST Basics', 'Medium', 'Find kth smallest element in BST.', 'Input: root = [3,1,4,null,2], k = 1
Output: 1', '1 <= k <= nodes <= 10^4', 'Inorder traversal visits elements in ascending order.', 'public class Solution {
    // Complete solution for Kth Smallest Element in a BST
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Binary Search Tree,Tree,DFS', 'https://takeuforward.org/data-structure/kth-largest-smallest-element-in-binary-search-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (121, 121, 'Top K Frequent Elements', 'Heaps', 'Heap Problems', 'Medium', 'Find k most frequent elements in array.', 'Input: nums = [1,1,1,2,2,3], k = 2
Output: [1,2]', '1 <= nums.length <= 10^5', 'Frequency map + min-heap of size k or bucket sort.', 'public class Solution {
    // Complete solution for Top K Frequent Elements
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Heaps,HashMap,Bucket Sort', 'https://takeuforward.org/data-structure/k-most-frequent-elements/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (122, 122, 'Merge K Sorted Lists', 'Heaps', 'Heap Problems', 'Hard', 'Merge k sorted linked lists into one sorted linked list.', 'Input: lists = [[1,4,5],[1,3,4],[2,6]]
Output: [1,1,2,3,4,4,5,6]', '0 <= k <= 10^4', 'Min-heap of node heads.', 'public class Solution {
    // Complete solution for Merge K Sorted Lists
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Heaps,Linked List,Divide and Conquer', 'https://takeuforward.org/data-structure/merge-k-sorted-arrays/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (123, 123, 'Find Median from Data Stream', 'Heaps', 'Heap Problems', 'Hard', 'Design data structure supporting addNum and findMedian in O(log n).', 'Input: addNum(1), addNum(2), findMedian(), addNum(3), findMedian()
Output: 1.5, 2.0', 'At most 5 * 10^4 calls', 'Two heaps: max-heap for lower half, min-heap for upper half.', 'public class Solution {
    // Complete solution for Find Median from Data Stream
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Heaps,Design', 'https://takeuforward.org/data-structure/find-median-from-data-stream/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (124, 124, 'Flood Fill', 'Graphs', 'BFS / DFS Problems', 'Easy', 'Perform flood fill from starting pixel (sr, sc) with color.', 'Input: image = [[1,1,1],[1,1,0],[1,0,1]], sr = 1, sc = 1, color = 2
Output: [[2,2,2],[2,2,0],[2,0,1]]', '1 <= m, n <= 50', 'Standard DFS/BFS checking original color.', 'public class Solution {
    // Complete solution for Flood Fill
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Graphs,DFS,BFS,Matrix', 'https://takeuforward.org/data-structure/flood-fill-algorithm/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (125, 125, 'Course Schedule (Cycle Detection)', 'Graphs', 'Topological Sort', 'Medium', 'Check if you can finish all numCourses given prerequisites.', 'Input: numCourses = 2, prerequisites = [[1,0]]
Output: true', '1 <= numCourses <= 2000', 'Kahn''s BFS topological sort with in-degrees.', 'public class Solution {
    // Complete solution for Course Schedule (Cycle Detection)
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Graphs,Topological Sort,BFS', 'https://takeuforward.org/data-structure/course-schedule-i-and-ii-pre-requisite-tasks-topological-sort/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (126, 126, 'Dijkstra''s Shortest Path', 'Graphs', 'Shortest Paths', 'Medium', 'Find shortest path from source vertex to all vertices in weighted graph with non-negative weights.', 'Input: V = 3, E = 3, adj = [[[1, 1], [2, 6]], [[2, 3]], []], S = 2
Output: [4, 3, 0]', '1 <= V <= 1000', 'Priority queue storing (distance, node).', 'public class Solution {
    // Complete solution for Dijkstra''s Shortest Path
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Graphs,Shortest Path,Heaps', 'https://takeuforward.org/data-structure/dijkstras-algorithm-using-priority-queue-g-32/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (127, 127, 'Bellman-Ford Algorithm', 'Graphs', 'Shortest Paths', 'Medium', 'Find shortest path from source with negative edge weights and detect negative cycles.', 'Input: V = 4, edges = [[0,1,1],[1,2,-1],[2,3,-1],[3,0,-1]], S = 0
Output: [-1]', '1 <= V <= 500', 'Relax all edges V-1 times. Nth relaxation indicates negative cycle.', 'public class Solution {
    // Complete solution for Bellman-Ford Algorithm
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Graphs,Shortest Path,Dynamic Programming', 'https://takeuforward.org/data-structure/bellman-ford-algorithm-g-41/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (128, 128, 'Minimum Spanning Tree (Kruskal''s)', 'Graphs', 'Minimum Spanning Tree', 'Medium', 'Find sum of weights of edges in Minimum Spanning Tree.', 'Input: V = 3, edges = [[0,1,5],[1,2,3],[0,2,1]]
Output: 4', '1 <= V <= 1000', 'Sort edges by weight, add edge using DSU if nodes in different sets.', 'public class Solution {
    // Complete solution for Minimum Spanning Tree (Kruskal''s)
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Graphs,Disjoint Set,Greedy', 'https://takeuforward.org/data-structure/kruskals-algorithm-minimum-spanning-tree-g-47/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (129, 129, 'Unique Paths in Grid', 'Dynamic Programming', '2D DP', 'Medium', 'Number of unique paths from top-left to bottom-right of m x n grid.', 'Input: m = 3, n = 7
Output: 28', '1 <= m, n <= 100', 'dp[i][j] = dp[i-1][j] + dp[i][j-1].', 'public class Solution {
    // Complete solution for Unique Paths in Grid
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Dynamic Programming,Math', 'https://takeuforward.org/data-structure/grid-unique-paths-dp-on-grids-dp8/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (130, 130, 'Minimum Path Sum in Grid', 'Dynamic Programming', '2D DP', 'Medium', 'Find path from top left to bottom right minimizing sum of numbers.', 'Input: grid = [[1,3,1],[1,5,1],[4,2,1]]
Output: 7
Explanation: 1 -> 3 -> 1 -> 1 -> 1 = 7.', '1 <= m, n <= 200', 'dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1]).', 'public class Solution {
    // Complete solution for Minimum Path Sum in Grid
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Dynamic Programming,Matrix', 'https://takeuforward.org/data-structure/minimum-path-sum-in-a-grid-dp-10/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (131, 131, '0/1 Knapsack Problem', 'Dynamic Programming', 'DP on Subsequences', 'Medium', 'Maximize value of items in knapsack of capacity W.', 'Input: W = 4, val = [1, 2, 3], wt = [4, 5, 1]
Output: 3', '1 <= N <= 1000
1 <= W <= 1000', 'dp[i][w] = max(dp[i-1][w], val[i] + dp[i-1][w - wt[i]]).', 'public class Solution {
    // Complete solution for 0/1 Knapsack Problem
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Dynamic Programming', 'https://takeuforward.org/data-structure/0-1-knapsack-dp-19/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (132, 132, 'Longest Increasing Subsequence', 'Dynamic Programming', 'DP on LIS', 'Medium', 'Length of longest strictly increasing subsequence.', 'Input: nums = [10,9,2,5,3,7,101,18]
Output: 4', '1 <= nums.length <= 2500', 'O(N log N) using binary search (tails array).', 'public class Solution {
    // Complete solution for Longest Increasing Subsequence
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Dynamic Programming,Binary Search', 'https://takeuforward.org/data-structure/longest-increasing-subsequence-dp-41/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (133, 133, 'Edit Distance', 'Dynamic Programming', 'DP on Strings', 'Hard', 'Minimum operations (insert, delete, replace) to convert word1 to word2.', 'Input: word1 = "horse", word2 = "ros"
Output: 3', '0 <= word1.length, word2.length <= 500', 'dp[i][j] = 1 + min(insert, delete, replace).', 'public class Solution {
    // Complete solution for Edit Distance
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Dynamic Programming,Strings', 'https://takeuforward.org/data-structure/edit-distance-dp-33/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (134, 134, 'Matrix Chain Multiplication', 'Dynamic Programming', 'MCM DP', 'Hard', 'Find minimum number of scalar multiplications needed to multiply chain of matrices.', 'Input: p = [10, 20, 30, 40, 30]
Output: 30000', '2 <= p.length <= 100', 'MCM partition: dp[i][j] = min(dp[i][k] + dp[k+1][j] + p[i-1]*p[k]*p[j]).', 'public class Solution {
    // Complete solution for Matrix Chain Multiplication
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Dynamic Programming', 'https://takeuforward.org/data-structure/matrix-chain-multiplication-dp-48/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (135, 135, 'Number of Distinct Substrings in a String', 'Tries', 'Trie Basics', 'Medium', 'Count total number of distinct substrings in string using Trie.', 'Input: s = "abab"
Output: 8
Explanation: "", "a", "b", "ab", "ba", "aba", "bab", "abab".', '1 <= s.length <= 1000', 'Insert all suffixes into Trie and count total nodes created.', 'public class Solution {
    // Complete solution for Number of Distinct Substrings in a String
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Tries,String', 'https://takeuforward.org/data-structure/number-of-distinct-substrings-in-a-string-using-trie/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (136, 136, 'Maximum XOR of Two Numbers in an Array', 'Tries', 'Bitwise Trie', 'Medium', 'Find maximum XOR of two numbers in array in O(32 * n) time.', 'Input: nums = [3,10,5,25,2,8]
Output: 28
Explanation: 5 XOR 25 = 28.', '1 <= nums.length <= 2 * 10^5', 'Bitwise trie: greedily take opposite bit if available.', 'public class Solution {
    // Complete solution for Maximum XOR of Two Numbers in an Array
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Tries,Bit Manipulation', 'https://takeuforward.org/data-structure/maximum-xor-of-two-numbers-in-an-array/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;
INSERT INTO coding_problems 
(problem_number, order_index, title, topic, subtopic, difficulty, description, examples, constraints_text, hints, starter_code_java, starter_code_python, starter_code_cpp, starter_code_js, solution_java, test_cases_json, tags, external_link, is_active)
VALUES (137, 137, 'Fenwick Tree (Binary Indexed Tree)', 'Advanced Data Structures', 'Binary Indexed Tree', 'Medium', 'Implement Fenwick Tree for point update and prefix sum queries in O(log n).', 'Input: arr = [1, 2, 3, 4, 5], sum(3), update(2, 6)
Output: 6', '1 <= n <= 10^5', 'Use lowbit x & (-x) for tree traversal.', 'public class Solution {
    // Complete solution for Fenwick Tree (Binary Indexed Tree)
    public int solve() {
        return 0;
    }
}', 'class Solution:
    def solve(self):
        pass', 'class Solution {
public:
    int solve() {
        return 0;
    }
};', 'function solve() {
    return 0;
}', 'public class Solution {
    public int solve() {
        return 0;
    }
}', '[{"input": "sample test", "expected": "sample output", "sample": true}]', 'Advanced Data Structures,Arrays', 'https://takeuforward.org/data-structure/fenwick-tree-binary-indexed-tree/', 1)
ON DUPLICATE KEY UPDATE 
order_index = VALUES(order_index),
topic = VALUES(topic),
subtopic = VALUES(subtopic),
difficulty = VALUES(difficulty),
description = VALUES(description),
examples = VALUES(examples),
constraints_text = VALUES(constraints_text),
hints = VALUES(hints),
starter_code_java = VALUES(starter_code_java),
starter_code_python = VALUES(starter_code_python),
starter_code_cpp = VALUES(starter_code_cpp),
starter_code_js = VALUES(starter_code_js),
solution_java = VALUES(solution_java),
test_cases_json = VALUES(test_cases_json),
tags = VALUES(tags),
external_link = VALUES(external_link),
is_active = 1;