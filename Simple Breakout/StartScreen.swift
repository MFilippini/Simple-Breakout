//
//  StartScreen.swift
//  Simple Breakout
//
//  Created by Michael Filippini on 7/12/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.borderWidth = 3
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.cornerRadius = 35
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
