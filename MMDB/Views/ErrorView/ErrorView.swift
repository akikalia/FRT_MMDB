//
//  ErrorView.swift
//  MMDB
//
//  Created by Alex kikalia on 08.05.21.
//

import UIKit

protocol ErrorViewDelegate: AnyObject{
    func errorViewButtonTap(sender: ErrorView)
}

class ErrorView: BaseReusableView{
    
    @IBOutlet var button: UIButton!
    
    weak var delegate: ErrorViewDelegate?
    
    override func setup(){
        
    }
    
    @IBAction func handleButtonTap() {
        delegate?.errorViewButtonTap(sender: self)
    }
}
