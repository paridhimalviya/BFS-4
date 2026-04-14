//
//  SnakesAndLadders.swift
//  DSA-Practice
//
//  Created by Paridhi Malviya on 3/12/26.
//

class SnakesAndLadders {
    struct QueueUsingLinkedList<T> {

        class LinkedListNode<T> {
            var value: T
            var next: LinkedListNode<T>?
            init(value: T) {
                self.value = value
            }
        }

        private var front: LinkedListNode<T>?
        private var rear: LinkedListNode<T>?
        private var count: Int = 0

        mutating func enqueue(_ value: T) {
            let newNode = LinkedListNode(value: value)
            if (front == nil) {
                front = newNode
                rear = newNode
            } else {
               rear?.next = newNode
               rear = newNode
            }
            count += 1
        }

        mutating func dequeue() -> T? {
            if (front == nil) {
                return nil
            }
            let value = front?.value
            front = front?.next
            if (front == nil) {
                rear = nil
            }
            count -= 1
            return value
        }

        var isEmpty: Bool {
            return count == 0
        }

        var size: Int {
            return count
        }
    }
    
    //MARK: using BFS, visited set
    func snakesAndLadders(_ board: [[Int]]) -> Int {
        let n = board.count
        var arr = Array(repeating: 0, count: n*n)
        var isLeftToRight = true
        var r = n - 1 //rows are strting from the bottom
        var c = 0
        //idx is an index, we are taking on flattened array
        var idx = 0
        while (idx < n * n) {
            //some r,c gives me -1. other 14
            if (board[r][c] == -1) {
                arr[idx] = -1
            } else {
                arr[idx] = board[r][c] - 1
            }
            idx += 1
            //move the r, c to next location
            if (isLeftToRight) {
                c += 1
                if (c == n) {
                    //since beyond the end column, so make c to n-1 and move to the previous rows, r -= 1
                    c = n - 1
                    r -= 1
                    isLeftToRight = false
                }
            } else {
                c -= 1
                if (c == -1) {
                    r -= 1
                    c = 0
                    isLeftToRight = true
                }
            }
        }
        
        var queue = QueueUsingLinkedList<Int>()
        var visited = Set<Int>()
        visited.insert(0)
        queue.enqueue(0)
        var count = 0
        while (!queue.isEmpty) {
            let size = queue.size
            for _ in 0..<size {
                guard let current = queue.dequeue() else {
                    continue
                }
                for i in 1...6 {
                    let nextPos = current + i
                    if (nextPos < n * n) {
                        if (!visited.contains(nextPos)) {
                            if (arr[nextPos] == -1) {
                                queue.enqueue(nextPos)
                                if (nextPos == n * n - 1) {
                                    return count + 1
                                }


                            } else {
                                queue.enqueue(arr[nextPos])
                                 if (arr[nextPos] == n * n - 1) {
                                    return count + 1
                                }
                            }
                            visited.insert(nextPos)

                        }
                    }
                }
            }
            count += 1
        }
        return -1
    }
    
    //MARK: BFS, without taking any extra space- markes -2 in arr itself instead of visited set
    func snakesAndLaddersWithoutExtraSpace(_ board: [[Int]]) -> Int {
        let n = board.count
        var arr = Array(repeating: 0, count: n*n)
        var isLeftToRight = true
        var r = n - 1 //rows are strting from the bottom
        var c = 0
        //idx is an index, we are taking on flattened array
        var idx = 0
        while (idx < n * n) {
            //some r,c gives me -1. other 14
            if (board[r][c] == -1) {
                arr[idx] = -1
            } else {
                arr[idx] = board[r][c] - 1
            }
            idx += 1
            //move the r, c to next location
            if (isLeftToRight) {
                c += 1
                if (c == n) {
                    //since beyond the end column, so make c to n-1 and move to the previous rows, r -= 1
                    c = n - 1
                    r -= 1
                    isLeftToRight = false
                }
            } else {
                c -= 1
                if (c == -1) {
                    r -= 1
                    c = 0
                    isLeftToRight = true
                }
            }
        }
        
        var queue = QueueUsingLinkedList<Int>()
        queue.enqueue(0)
        var count = 0
        arr[0] = -2 // -2 to mark the visited without taking extra space
        while (!queue.isEmpty) {
            let size = queue.size
            for _ in 0..<size {
                guard let current = queue.dequeue() else {
                    continue
                }
                for i in 1...6 {
                    let nextPos = current + i
                    if (nextPos < n * n) {
                        if (arr[nextPos] != -2) {
                            if (arr[nextPos] == -1) {
                                queue.enqueue(nextPos)
                                if (nextPos == n * n - 1) {
                                    return count + 1
                                }
                            } else {
                                queue.enqueue(arr[nextPos])
                                 if (arr[nextPos] == n * n - 1) {
                                    return count + 1
                                }
                            }
                            arr[nextPos] = -2
                        }
                    }
                }
            }
            count += 1
        }
        return -1
    }

}
