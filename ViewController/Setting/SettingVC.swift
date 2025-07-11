//
//  SettingVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 16/6/25.
//

import UIKit

class SettingVC: BaseVC {

    @IBOutlet var lbs: [UILabel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        lbs.forEach {
            $0.font = UIFont.HoltwoodOneSC(17)
        }
    }

    @IBAction func rate(_ sender: Any) {
    }
    
    @IBAction func share(_ sender: Any) {
    }

    @IBAction func support(_ sender: Any) {
    }
    
}
