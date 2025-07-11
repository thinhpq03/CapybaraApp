//
//  DiaryCell.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit

class DiaryCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLb.font = UIFont.EduVICWANTHandPre(20)
        dateLb.font = UIFont.EduVICWANTHandPre(14)
        img.layer.cornerRadius = 10
    }

}
