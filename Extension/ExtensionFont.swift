//
//  ExtensionFont.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import Foundation
import UIKit

extension UIFont {
    static func HoltwoodOneSC(_ size: CGFloat) -> UIFont? {
        let size = checkIphone ? size : size + 6
        return UIFont(name: "HoltwoodOneSC-Regular", size: size)
    }

    static func EduVICWANTHandPre(_ size: CGFloat) -> UIFont? {
        let size = checkIphone ? size : size + 6
        return UIFont(name: "EduVICWANTHandPre-Regular", size: size)
    }

}
