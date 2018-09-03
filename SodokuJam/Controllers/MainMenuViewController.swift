//
//  ViewController.swift
//  SodokuJam
//
//  Created by Rob Fazio on 10/14/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import UIKit
import SnapKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setupHeaderView()
        addDifficultyButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // create the top header view of the Main Menu
    private func setupHeaderView()
    {
        // create the heaer view
        let topView = UIView()
        view.addSubview(topView)
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.height.equalTo(view.frame.height * 0.25)
            
        }
        
        topView.backgroundColor = UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1)
        
        // add the header label and align at the center
        
        let title = UILabel()
        title.text = "Welcome To SodokuJam"
        title.textColor = UIColor.white
        title.font = UIFont(name: "AvenirNext-Bold", size: 30)
        
        topView.addSubview(title)
        
        title.snp.makeConstraints({ (make) in
            make.centerX.equalTo(topView)
            make.centerY.equalTo(topView)
        })
        
        addDifficultyLabel(header: topView)
        
    }
    
    private func addDifficultyLabel(header: UIView)
    {
        let title = UILabel()
        title.text = "Choose A Difficulty"
        title.textColor = UIColor.darkGray
        title.font = UIFont(name: "AvenirNext-Medium", size: 30)
        
        view.addSubview(title)
        
        title.snp.makeConstraints { (make) in
            
            make.top.equalTo(header.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
    }
    
    private func addDifficultyButtons()
    {
        let easyButton = RoundedButton(label: "Easy", color: UIColor(red: 184/255, green: 233/255, blue: 134/255, alpha: 1))
        easyButton.tag = 1
        easyButton.addTarget(self, action: #selector(MainMenuViewController.difficultyButtonClicked(sender:)), for: .touchUpInside)
        
        view.addSubview(easyButton)
        
        easyButton.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.height.equalTo(50)
            make.width.equalTo(241)
        }
        
        let mediumButton = RoundedButton(label: "Medium", color: UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1))
        mediumButton.tag = 2
        mediumButton.addTarget(self, action: #selector(MainMenuViewController.difficultyButtonClicked(sender:)), for: .touchUpInside)
        
        view.addSubview(mediumButton)
        
        mediumButton.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(easyButton)
            make.top.equalTo(easyButton.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(241)
        }
        
        let hardButton = RoundedButton(label: "Hard", color: UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1))
        hardButton.tag = 3
        hardButton.addTarget(self, action: #selector(MainMenuViewController.difficultyButtonClicked(sender:)), for: .touchUpInside)
        
        view.addSubview(hardButton)
        
        hardButton.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(easyButton)
            make.top.equalTo(mediumButton.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(241)
        }
    }
    
    // handle the touchup inside event and set the difficulty level
    @objc private func difficultyButtonClicked(sender: RoundedButton)
    {
        // set difficulty level
        switch sender.tag {
        case 1:
            GameplayManager.sharedInstance.difficultyLevel = .Easy
        case 2:
            GameplayManager.sharedInstance.difficultyLevel = .Medium
        case 3:
            GameplayManager.sharedInstance.difficultyLevel = .Hard
        default:
            GameplayManager.sharedInstance.difficultyLevel = .Easy
        }
        
        performBackgroundTask {
            
            // generate a game board
            if GameplayManager.sharedInstance.playGame()
            {
                performUIUpdateOnMain {
                    // push the GameplayViewController to the navigation stack
                    let controller = GameplayViewController()
                    self.navigationController?.pushViewController(controller, animated: true);
                }
                
            }
            else
            {
                performUIUpdateOnMain {
                    
                    let alert = UIAlertController(title: "Oops...", message: "We were unable to initialize the Sodoku board", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
}
