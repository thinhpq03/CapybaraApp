//
//  EmojiTBVCell.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit

class EmojiTBVCell: UITableViewCell {

    static let height: CGFloat = checkIphone ? 300 : 450

    @IBOutlet weak var img: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(name: String) {
        img.image = UIImage(named: name)
    }

}
