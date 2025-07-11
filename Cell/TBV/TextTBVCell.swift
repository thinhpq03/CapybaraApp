//
//  TextTBVCell.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit

class TextTBVCell: UITableViewCell, UITextViewDelegate {

    static let height: CGFloat = checkIphone ? 400 : 550

    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var diaryTv: UITextView!
    @IBOutlet weak var bg: UIView!

    weak var delegate: TextTBVCellDelegate?
    private let placeholder = "Enter your diary here..."
    private var placeholderLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        titleTf.font = UIFont.EduVICWANTHandPre(32)
        titleTf.attributedPlaceholder = NSAttributedString(
            string: "ENTER TITLE",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#5CBF93")]
        )
        diaryTv.font = UIFont.EduVICWANTHandPre(18)
        diaryTv.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = diaryTv.font
        placeholderLabel.textColor = UIColor(hex: "#5CBF93")
        placeholderLabel.frame = CGRect(x: 5, y: 8,
                                        width: diaryTv.frame.width - 10,
                                        height: 35)
        diaryTv.addSubview(placeholderLabel)
        bg.layer.cornerRadius = 15
        bg.layer.borderWidth = 4.5
        bg.layer.borderColor = UIColor(hex: "#C9EADB").cgColor
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textViewDidBeginEditing()
    }
}
