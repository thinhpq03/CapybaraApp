//
//  BaseVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 10/6/25.
//

import UIKit

public let checkIphone: Bool = UIDevice.current.userInterfaceIdiom == .phone

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(hex: "DAFFF4")
    }

}
