//
//  GameCell.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 12/6/25.
//

import UIKit

class GameCell: UICollectionViewCell {

    @IBOutlet weak var innerImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerImg.clipsToBounds = true

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskLayer = CALayer()
        innerImg.layoutIfNeeded()
        maskLayer.contents = UIImage(named: "image")?.cgImage
        maskLayer.frame = innerImg.bounds
        innerImg.layer.mask = maskLayer
        innerImg.layer.masksToBounds = true
    }

}
