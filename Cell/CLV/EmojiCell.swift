//
//  EmojiCell.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit

class EmojiCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configureCell(name: String) {
        self.name.font = UIFont.EduVICWANTHandPre(20)
        self.name.text = name
        self.img.image = UIImage(named: name)
    }

}
