//
//  ContactCell.swift
//  MMDB
//
//  Created by Alex kikalia on 07.05.21.
//


import UIKit

protocol MovieCellDelegate: AnyObject{
    func movieCellDelegateTap(_ sender: MovieCell, index: Int)
    func movieCellDelegateLongPress(_ sender: MovieCell, index: Int)
}

class MovieCell: UICollectionViewCell {

    @IBOutlet var wrapperView: UIView!
    @IBOutlet var poster: UIImageView!
    
//    var posterURL: String?
    var index: Int?
    
    weak var delegate: MovieCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        wrapperView.addGestureRecognizer(tap)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        wrapperView.addGestureRecognizer(longPress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wrapperView.layer.cornerRadius = 10
        wrapperView.layer.borderWidth = 0.1
        if #available(iOS 11.0, *) {
            wrapperView.layer.borderColor = UIColor(named: "primaryColor")?.cgColor
        }
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if sender?.state == .ended{
        if let index = index{
            delegate?.movieCellDelegateTap(self, index: index)
        } else {
            print("movie id not set")
        }
       }
    }
    @objc
    func handleLongPress(_ sender: UILongPressGestureRecognizer? = nil) {
        if sender?.state == .ended{
        if let index = index{
            delegate?.movieCellDelegateLongPress(self, index: index)
        } else {
            print("movie id not set")
        }
       }
    }
}
