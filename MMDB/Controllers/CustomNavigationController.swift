//
//  CustomNavigationController.swift
//  MMDB
//
//  Created by Alex kikalia on 09.05.21.
//


import UIKit

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let navBarAppearence = UINavigationBarAppearance()
            navBarAppearence.configureWithTransparentBackground()
            navBarAppearence.backgroundImage = UIImage()
            navBarAppearence.shadowImage = UIImage()
            
            navigationBar.compactAppearance = navBarAppearence
            navigationBar.standardAppearance = navBarAppearence
            navigationBar.scrollEdgeAppearance = navBarAppearence
        } else {
            // Fallback on earlier versions
        }
    }
}
