//
//  GameplayViewController.swift
//  SodokuJam
//
//  Created by Rob Fazio on 10/14/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import UIKit
import SnapKit

class GameplayViewController: UIViewController {

    var previouslySelectedButton: SelectionButton!
    var board: [[SquareView]]!
    var hintButton: UIButton!
    var solveButton: UIButton!
    var tryCounterLbl: UILabel!
    var tryCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Main Menu", style: .plain, target: self, action: #selector(goToMainMenu))
        
        performUIUpdateOnMain {
            self.setBackgroundView()
            self.addFooter()
            self.setSelectionButtons()
            self.generateBoardView()
            self.shadeSectionsInBoard()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setBackgroundView()
    {
        // add the background image
        let image = UIImageView(image: UIImage(named: "background"))
        image.contentMode = .scaleAspectFill
        
        view.addSubview(image)
        
        image.snp.makeConstraints { (make) in
            
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
            
        }
        
        // add vfx blur view
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.frame = image.bounds
        view.addSubview(blurView)
    }
    
    private func addFooter()
    {
        // add a hint button at the bottom left corner
        hintButton = UIButton()
        hintButton.setTitle("Hint", for: .normal)
        hintButton.sizeToFit()
        hintButton.setTitleColor(UIColor.white, for: .normal)
        hintButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16)
        hintButton.addTarget(self, action: #selector(showHint), for: .touchUpInside)
        
        view.addSubview(hintButton)
        
        hintButton.snp.makeConstraints { (make) in

            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.left.equalTo(view.snp.left).offset(20)
        }
        
        tryCounterLbl = UILabel()
        tryCounterLbl.text = "0"
        tryCounterLbl.textColor = UIColor.white
        tryCounterLbl.sizeToFit()
        tryCounterLbl.font = UIFont(name: "AvenirNext-Medium", size: 16)
        
        view.addSubview(tryCounterLbl)
        
        tryCounterLbl.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(hintButton.snp.centerY)
        }
        
        // add a solve button at the bottom right corner
        solveButton = UIButton()
        solveButton.setTitle("Solve", for: .normal)
        solveButton.sizeToFit()
        solveButton.setTitleColor(UIColor.white, for: .normal)
        solveButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16)
        solveButton.addTarget(self, action: #selector(solveBoard), for: .touchUpInside)
        
        view.addSubview(solveButton)
        
        solveButton.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
    }
    
    // add a row of buttons numbered 1...9 at the bottom
    private func setSelectionButtons()
    {
        var buttons = [SelectionButton]()
        for i in 1...9
        {
            let button = SelectionButton(frame: .zero)
            button.setTitle("\(i)", for: .normal)
            button.sizeToFit()
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(GameplayViewController.numberSelected(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 1.0
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).offset(-150)
            make.left.equalTo(view.snp.left).offset(5)
            make.right.equalTo(view.snp.right).offset(-5)
        }
    }
    
    // the main board generator
    private func generateBoardView()
    {
        board = [[SquareView]]()
        for row in 0..<9
        {
            board.append([SquareView]())
            for col in 0..<9
            {
                // fetch a sqaure from the game board
                let mark = GameplayManager.sharedInstance.gameBoard[row][col].value
                // initialize a new square view with a sqaure object
                let squareView = SquareView(frame: .zero, square: Square(value: mark, row: row, col: col))
                // if sqaure view has a mark, disable use interaction
                if mark.isEmpty
                {
                    squareView.isUserInteractionEnabled = true
                }
                else
                {
                    squareView.isUserInteractionEnabled = false
                }
                
                // add a tap gesture to each square view
                let tap = UITapGestureRecognizer(target: self, action: #selector(GameplayViewController.sqaureViewTapped(_:)))
                tap.numberOfTapsRequired = 1
                tap.numberOfTouchesRequired = 1
                
                squareView.addGestureRecognizer(tap)
                
                squareView.snp.makeConstraints({ (make) in
                    make.width.equalTo(30)
                    make.height.equalTo(30)
                })
                board[row].append(squareView)
            }
        }
        
        // start with the top vertical stack view
        let verticalStackView = UIStackView()
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillProportionally
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 6.0
        
        view.addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view.snp.top).offset(85)
        }
        
        // for each row in the board create 9 horizontal stack views
        for row in 0..<9
        {
            // get a row form the board and add it to the stack view
            let horiStackView = UIStackView(arrangedSubviews: board[row])
            
            horiStackView.alignment = .fill
            horiStackView.distribution = .fillProportionally
            horiStackView.axis = .horizontal
            horiStackView.spacing = 4.0
            
            verticalStackView.addArrangedSubview(horiStackView)
        }
    }
    
    // create a checker pattern to diffrentiate between the sections
    private func shadeSectionsInBoard()
    {
        shadeSquares(row: 0, col: 0)
        shadeSquares(row: 0, col: 6)
        shadeSquares(row: 3, col: 3)
        shadeSquares(row: 6, col: 0)
        shadeSquares(row: 6, col: 6)
    }
    
    private func shadeSquares(row: Int, col: Int)
    {
        let minRow = (row / 3) * 3
        let maxRow = minRow + 2
        let minCol = (col / 3) * 3
        let maxCol = minCol + 2
        
        for row in minRow...maxRow
        {
            for col in minCol...maxCol
            {
                board[row][col].updateSqaureViewColor(.gray)
            }
        }
    }
    
    // MARK: TouchUpInside event handlers
    
    @objc func showHint()
    {
        // pick a random empty squre and get its row and col.
        if let (row, col) = GameplayManager.sharedInstance.getEmptySquare(GameplayManager.sharedInstance.gameBoard)
        {
            // get the marked value from the solved board
            let mark = GameplayManager.sharedInstance.solvedBoard[row][col].value
            
            // set the value on the game board
            GameplayManager.sharedInstance.gameBoard[row][col].value = mark
            board[row][col].updateLabel(number: mark)
            board[row][col].square.value = mark
            board[row][col].isUserInteractionEnabled = false
            
            flashInBlue(row, col)
            tryCounter += 1
            tryCounterLbl.text = "\(tryCounter)"
        }
        else
        {
            // board is solved!
        }
    }
    
    @objc func solveBoard()
    {
        let alert = UIAlertController(title: "Are you sure?", message: "Giving up so soon? This action cannot be undone!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            performUIUpdateOnMain {
                
                var solvedBoard = GameplayManager.sharedInstance.solvedBoard
                for row in 0..<9
                {
                    for col in 0..<9
                    {
                        if self.board[row][col].square.value.isEmpty
                        {
                            let mark = solvedBoard[row][col].value
                            self.board[row][col].updateLabel(number: mark)
                            self.board[row][col].isUserInteractionEnabled = false
                            GameplayManager.sharedInstance.gameBoard[row][col].value = mark
                        }
                    }
                }
                
            }
            self.hintButton.isEnabled = false
            self.solveButton.isEnabled = false
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func goToMainMenu()
    {
        if GameplayManager.sharedInstance.isSolved()
        {
            self.navigationController?.popViewController(animated: true);
        }
        else
        {
            let alert = UIAlertController(title: "Are you sure?", message: "You will lose your progress", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true);
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    @objc func numberSelected(sender: SelectionButton)
    {
        if let button = previouslySelectedButton {
            button.layer.backgroundColor = UIColor.clear.cgColor
            button.setTitleColor(UIColor.white, for: .normal)
        }
        previouslySelectedButton = sender
        sender.layer.backgroundColor = UIColor.white.cgColor
        sender.setTitleColor(UIColor.darkGray, for: .normal)
        GameplayManager.sharedInstance.selectedNumber = sender.titleLabel?.text
    }
    
    
    
    @objc func sqaureViewTapped(_ sender: UITapGestureRecognizer)
    {
        // get the square view which was tapped
        let squareView = sender.view as! SquareView
        
        
        if !GameplayManager.sharedInstance.selectedNumber.isEmpty
        {
            // check if the selected number is the correct number.
            let row = squareView.square.row
            let col = squareView.square.col
            
            if GameplayManager.sharedInstance.selectedNumber == GameplayManager.sharedInstance.solvedBoard[row][col].value
            {
                // update the game board
                GameplayManager.sharedInstance.gameBoard[row][col].value = GameplayManager.sharedInstance.selectedNumber
                
                // update the square label mark
                squareView.square.value = GameplayManager.sharedInstance.selectedNumber
                squareView.updateLabel(number: GameplayManager.sharedInstance.selectedNumber)
                squareView.isUserInteractionEnabled = false
                
                // check if the board is fully solved
                if GameplayManager.sharedInstance.isSolved()
                {
                    // GAME OVER - show an alert view, but we could do something cooler if we have more time. Maybe fireworks???
                    let alert = UIAlertController(title: "Congratulations!", message: "Would you like to start a new Game", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true);
                    }))
                    
                    present(alert, animated: true, completion: nil)
                    
                }
            }
            else
            {
                flashInRed(squareView)
            }
            
            tryCounter += 1
            tryCounterLbl.text = "\(tryCounter)"
        }
        else
        {
            // display an alert indicating user must select a number first
            let alert = UIAlertController(title: "Number is missing", message: "Please select a number from the row below", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Animations
    
    private func flashInRed(_ squareView: SquareView) {
        // if the number is not correct, flash the sqaure in red to let the user know the number is incorrect
        squareView.alpha = 0.7
        let prevBgColor = squareView.layer.backgroundColor
        squareView.layer.backgroundColor = UIColor.red.cgColor
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            squareView.alpha = 0.0
            
        }, completion: {(finished: Bool) -> Void in
            
            UIView.animate(withDuration: 0.5, animations: {
                squareView.alpha = 0.7
            }, completion: { (finished) in
                squareView.layer.backgroundColor = prevBgColor
            })
        })
    }
    
    private func flashInBlue(_ row: Int, _ col: Int) {
        // flash in blue
        let squareView = board[row][col]
        squareView.alpha = 0.7
        let prevBgColor = squareView.layer.backgroundColor
        squareView.layer.backgroundColor = UIColor.blue.cgColor
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            squareView.alpha = 0.0
            
        }, completion: {(finished: Bool) -> Void in
            
            UIView.animate(withDuration: 0.5, animations: {
                squareView.alpha = 0.7
            }, completion: { (finished) in
                squareView.layer.backgroundColor = prevBgColor
            })
        })
    }
}
