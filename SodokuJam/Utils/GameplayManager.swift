//
//  GameplayController.swift
//  SodokuJam
//
//  Created by Rob Fazio on 10/14/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import Foundation

/*
 This class is a singelton that manages the gameplay progression
 */
class GameplayManager
{
    static let sharedInstance = GameplayManager()
    
    
    // MARK: Properties
    
    var difficultyLevel: Difficulties! = Difficulties.Easy
    var selectedNumber: String! = ""
    var gameBoard = [[Square]]() // the puzzle board used for the game
    var solvedBoard = [[Square]]() // the solved ref board used to check for user input
    
    func playGame() -> Bool
    {
        var seed: Int!
        switch difficultyLevel
        {
            case .Easy:
                seed = 81 - 35
            case .Medium:
                seed = 81 - 25
            case .Hard:
                seed = 81 - 15
            default:
                seed = 81 - 35
        }
        
        // clear the boards
        gameBoard.removeAll()
        solvedBoard.removeAll()
        
        return preFillBoard(seed)
    }
    
    // check whether the game board is solved => GAME OVER!
    func isSolved() -> Bool
    {
        for row in 0..<9
        {
            for col in 0..<9
            {
                if gameBoard[row][col].value.isEmpty
                {
                    return false
                }
            }
        }
        return true
    }
    
    func getEmptySquare(_ board: [[Square]]) -> (Int, Int)?
    {
        // construct an array of empty squares
        var squares = [Square]()
        
        for row in 0..<9
        {
            for col in 0..<9
            {
                if board[row][col].value.isEmpty
                {
                    squares.append(Square(value: "", row: row, col: col))
                }
            }
        }
        
        // randomly pick a square from the array if it has at least one element
        if squares.count > 0
        {
            let randomIndex = Int(arc4random_uniform(UInt32(squares.count)))
            return (squares[randomIndex].row, squares[randomIndex].col)
        }
        return nil // no empty squares found!
    }
    
    // pre fill the game board with random numbers based on a seed
    private func preFillBoard(_ seed: Int) -> Bool
    {
        // generate a ranom row in the board
        var numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"].shuffled()
        var firstRow = [Square]()
        for row in 0..<9
        {
            firstRow.append(Square(value: numbers.removeLast(), row: row, col: 0))
        }
        
        // append first row
        gameBoard.append(firstRow)
        // initialize the board with empty values
        for row in 1..<9
        {
            gameBoard.append([Square]())
            for col in 0..<9
            {
                let sq = Square(value: "", row: row, col: col)
                gameBoard[row].append(sq)
            }
        }
        
        // attempt to solve the board
        let solver = SodokuSolver()
        let solution = solver.SolveSodokuBoard(board: gameBoard)
        if let solution = solution
        {
            // make a deep copy of the solved board
            solvedBoard = deepCopy(orginial: solution)
            
            gameBoard = solution
            
            // based on the selected difficulty remove values from the board
            removeNumbersFromGameBoard(seed)
            
            return true
        }

        return false // no solution found.
    }
    
    // randomly remove numbers from the game board using a seed
    // the seed changes based on the difficulty level.
    // the higher the difficulty, the lower the seed
    // IMPORTANT: this method can potentially run forever, if
    // 1 - the gameboad is empty
    // 2 - the game board became empty before the counter reached the seed
    // SOLUTION - check if the boad is empty after every removal.
    private func removeNumbersFromGameBoard(_ seed: Int)
    {
        var numberRemovedCounter = 0
        while numberRemovedCounter < seed {
            
            let randomRow = Int(arc4random_uniform(9))
            let randomCol = Int(arc4random_uniform(9))
            
            if !gameBoard[randomRow][randomCol].value.isEmpty
            {
                numberRemovedCounter += 1
                gameBoard[randomRow][randomCol].value = ""
            }
        }
    }
    
    // perform a deep copy of a 2D jagged array
    private func deepCopy(orginial: [[Square]]) -> [[Square]]
    {
        var copy = [[Square]]()
        
        for row in 0..<orginial.count
        {
            copy.append([Square]())
            
            for col in 0..<orginial.count
            {
                copy[row].append(Square(value: orginial[row][col].value, row: orginial[row][col].row, col: orginial[row][col].col))
            }
        }
        
        return copy
    }
    
    
    
    // MARK: private Init
    
    private init() {}
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
