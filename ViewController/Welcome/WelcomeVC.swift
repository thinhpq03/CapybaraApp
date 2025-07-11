//
//  WelcomeVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 10/6/25.
//

import UIKit

class WelcomeVC: BaseVC {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var capyView: UIView!
    @IBOutlet weak var waterImg: UIImageView!
    @IBOutlet var targetLine: UIView!

    private var initialWaterImgCenter: CGPoint = .zero
    private var panGesture: UIPanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        waterImg.isUserInteractionEnabled = true
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        waterImg.addGestureRecognizer(panGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setup()
    }

    func setup() {
        titleLb.font = UIFont.HoltwoodOneSC(16)
        topConstraint.constant = (145.0 / 344.0) * capyView.frame.height
        rightConstraint.constant = (125.0 / 380.0) * capyView.frame.width
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)

        switch gesture.state {
            case .began:
                initialWaterImgCenter = waterImg.center

            case .changed:
                var newCenter = initialWaterImgCenter
                newCenter.y += max(0, translation.y)
                waterImg.center = newCenter

                let waterImgFrameInSelfView = self.view.convert(waterImg.frame, from: capyView)
                let targetLineFrameInSelfView = self.view.convert(targetLine.frame, from: targetLine.superview)
                if waterImgFrameInSelfView.maxY >= capyView.frame.maxY {
                    let vc = CustomTabBarController()
                    self.navigationController?.pushViewController(vc, animated: true)

                }

            case .ended, .cancelled:
                break

            default:
                break
        }
    }
}
