//
//  PokerViewController.swift
//  cardDeck
//
//  Created by Marc Attinasi on 10/5/19.
//  Copyright © 2019 Marc Attinasi. All rights reserved.
//

import UIKit

class PokerTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItems()
    }
    
    func setupTabBarItems() {
        let gameImage = UIImage(named: "game.png")
        tabBar.items?.first?.image = gameImage?.withRenderingMode(.alwaysOriginal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
