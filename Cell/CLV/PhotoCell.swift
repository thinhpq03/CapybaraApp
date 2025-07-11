//
//  PhotoCell.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
    }

}
