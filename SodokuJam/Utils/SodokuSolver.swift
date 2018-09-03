//
//  SodokuSolver.swift
//  SodokuJam
//
//  Created by Rob Fazio on 10/14/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//
//  The Solver algorithm is based on Kristopher Jognson's algorithm
//  which was posted at https://gist.github.com/kristopherjohnson/c49448aad37e766b4fd1#file-_sudoku-swift-L82
//

import Foundation

/*
 This class uses an algorith to solve a sodoku board
 */
class SodokuSolver
{
    
    func SolveSodokuBoard(board: [[Square]]) -> [[Square]]?
    {
        if let (row, col) = getEmptySquare(board) {
            for number in 1...9
            {
                if isNumberValid(number: number, row: row, col: col, board: board)
                {
                    let tempBoard = copyBoardWithNumber(boardToCopy: board, number: number, row: row, col: col)
                    // recursive call ahead...
                    if let solution = SolveSodokuBoard(board: tempBoard)
                    {
                        return solution
                    }
                }
            }
            // solution not found
            return nil
        }
        else
        {
            // the board contains no empty squars, so it is solved
            return board
        }
    }
    
    /*
     Scan the board and find an empty square
     */
    private func getEmptySquare(_ board: [[Square]]) -> (Int, Int)?
    {
        for row in 0..<9
        {
            for col in 0..<9
            {
                if board[row][col].value.isEmpty
                {
                    return (row, col)
                }
            }
        }
        return nil
    }
    
    /*
     make a copy of the board and insert the number to the location
     */
    private func copyBoardWithNumber(boardToCopy: [[Square]], number: Int, row: Int, col: Int) -> [[Square]]
    {
        var temp =  [[Square]](boardToCopy)
        
        var newRow = Array(boardToCopy[row])
        newRow[col] = Square(value: String(number), row: row, col: col)
        temp[row] = newRow
        
        return temp
        
    }
    
    /*
     Check if the given number violates sodoku rules
     */
    private func isNumberValid(number: Int, row: Int, col: Int, board: [[Square]]) -> Bool
    {
        return !isNumberExistsInRow(board: board, number: number, row: row)
        && !isNumberExistsInColumn(board: board, number: number, col: col)
        && !isNumberExistsInSection(board: board, number: number, row: row, col: col)
    }
    
    /* The following overloads check for sodoku rules violations */
    
    private func isNumberExistsInRow(board: [[Square]], number: Int, row: Int) -> Bool
    {
        for col in 0..<9
        {
            if board[row][col].value == String(number)
            {
                return true
            }
        }
        return false
    }
    
    private func isNumberExistsInColumn(board: [[Square]], number: Int, col: Int) -> Bool
    {
        for row in 0..<9
        {
            if board[row][col].value == String(number)
            {
                return true
            }
        }
        return false
    }
    
    private func isNumberExistsInSection(board: [[Square]], number: Int, row: Int, col: Int) -> Bool
    {
        let minRow = (row / 3) * 3
        let maxRow = minRow + 2
        let minCol = (col / 3) * 3
        let maxCol = minCol + 2
        
        for row in minRow...maxRow
        {
            for col in minCol...maxCol
            {
                if board[row][col].value == String(number)
                {
                    return true
                }
            }
        }
        return false
    }
}
