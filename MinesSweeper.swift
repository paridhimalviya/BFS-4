
class MinesSweeper {
    
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
            let val = front?.value
            front = front?.next
            if (front == nil) {
                rear = nil
            }
            count -= 1
            return val
        }

        var isEmpty: Bool {
            return count == 0
        }

        var size: Int {
            return count
        }

        var peek: T? {
            return front?.value
        }
    }

    func updateBoard(_ board: [[Character]], _ click: [Int]) -> [[Character]] {
        
        var board = board
        var queue = QueueUsingLinkedList<[Int]>()
        queue.enqueue(click)
        
        var dirs = [[1,0], [1,1], [-1,0], [0, -1], [0,1], [1, -1], [-1,-1], [-1, 1]]
        
        let char = board[click[0]][click[1]]
        
        if (char == "M") {
            board[click[0]][click[1]] = "X"
            return board
        } else if (char == "E"){
             board[click[0]][click[1]] = "B"
        }

        while(!queue.isEmpty) {
            guard let current = queue.dequeue() else {
                continue
            }
            let r = current[0]
            let c = current[1]
            let mines = checkNoOfMines(at: current, dirs: dirs, board: board)
            if (mines > 0) {
                board[r][c] = Character(String(mines))
            } else {
                //go through neighbors
                for dir in dirs {
                    let nR = r + dir[0]
                    let nC = c + dir[1]
                    if (nR  >= 0 && nR < board.count && nC >= 0 && nC < board[0].count) {
                        if (board[nR][nC] == "E") {
                            queue.enqueue([nR, nC])
                            board[nR][nC] = "B"
                        }
                    }
                }
            }
        }
        return board
    }

    func checkNoOfMines(at point: [Int], dirs: [[Int]], board: [[Character]]) -> Int {
        var point = point
        var noOfMines = 0
        for dir in dirs {
            let nR = point[0] + dir[0]
            let nC = point[1] + dir[1]
            if (nR  >= 0 && nR < board.count && nC >= 0 && nC < board[0].count && board[nR][nC] == "M") {
                noOfMines += 1
            }
        }
        return noOfMines
    }
    
    //MARK: DFS
    func updateBoardUsingDFS(_ board: [[Character]], _ click: [Int]) -> [[Character]] {
        
        var board = board
        
        var dirs = [[1,0], [1,1], [-1,0], [0, -1], [0,1], [1, -1], [-1,-1], [-1, 1]]
        
        let char = board[click[0]][click[1]]
        if (char == "M") {
            board[click[0]][click[1]] = "X"
            return board
        }
        dfs(board: &board, r: click[0], c: click[1], dirs: dirs)
        return board
    }

    func dfs(board: inout [[Character]], r: Int, c: Int, dirs: [[Int]]) {
        if (r < 0 || c < 0 || r == board.count || c == board[0].count || board[r][c] != "E") {
            return
        }
        let countOfMines = checkNoOfMines(at: [r,c], dirs: dirs, board: board)
        if (countOfMines > 0) {
            board[r][c] = Character(String(countOfMines))
        } else {
            //go through the neighbors
            board[r][c] = "B"
            for dir in dirs {
                let nr = r + dir[0]
                let nc = c + dir[1]
                dfs(board: &board, r: nr, c: nc, dirs: dirs)
            }
        }
    }

}
