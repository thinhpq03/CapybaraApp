//
//  CustomTabBarController.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 13/6/25.
//


import UIKit

class CustomTabBarController: UITabBarController {
    private let customBarHeight: CGFloat = 60
    private let sideInset: CGFloat = 15
    private let bottomInset: CGFloat = 40
    private let cornerRadius: CGFloat = 30
    private var buttons: [UIButton] = []
    private let icons = ["home", "diary", "game", "setting"]
    private let selectedIcons = ["home_sel", "diary_sel", "game_sel", "setting_sel"]
    private var customBarView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupCustomTabBar()
        selectItem(at: 0)

        if #available(iOS 17.0, *) {
            traitOverrides.horizontalSizeClass = .compact
        }
    }

    private func setupViewControllers() {
        let homeVC = HomeVC()
        let diaryVC = ListDiaryVC()
        let gameVC = SavedGameVC()
        let settingVC = SettingVC()
        viewControllers = [homeVC, diaryVC, gameVC, settingVC]
    }
    
    private func setupCustomTabBar() {
        tabBar.isHidden = true
        let bar = UIView()
        bar.backgroundColor = .white
        bar.layer.cornerRadius = cornerRadius
        bar.clipsToBounds = false
        bar.layer.masksToBounds = false
        customBarView = bar
        view.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bar.heightAnchor.constraint(equalToConstant: customBarHeight),
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset),
            bar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        setupButtons(on: bar)
    }

    private func setupButtons(on bar: UIView) {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 0
        bar.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: bar.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: bar.trailingAnchor),
            stack.topAnchor.constraint(equalTo: bar.topAnchor),
            stack.bottomAnchor.constraint(equalTo: bar.bottomAnchor)
        ])
        for i in 0..<icons.count {
            let btn = UIButton(type: .custom)
            btn.tag = i
            btn.setImage(UIImage(named: icons[i]), for: .normal)
            btn.contentMode = .scaleAspectFit
            btn.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(btn)
            buttons.append(btn)
        }
    }

    @objc private func tabTapped(_ sender: UIButton) {
        selectItem(at: sender.tag)
        selectedIndex = sender.tag
    }

    private func selectItem(at index: Int) {
        for (i, btn) in buttons.enumerated() {
            if i == index {
                btn.setImage(UIImage(named: selectedIcons[i]), for: .normal)
                UIView.animate(withDuration: 0.3) {
                    btn.transform = CGAffineTransform(translationX: 0, y: -20).scaledBy(x: 1.2, y: 1.2)
                }
            } else {
                btn.setImage(UIImage(named: icons[i]), for: .normal)
                UIView.animate(withDuration: 0.3) {
                    btn.transform = .identity
                }
            }
        }
    }
}
