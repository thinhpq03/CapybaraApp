//
//  HomeVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit

enum DefaultsKey {
    static let selectedCapy = "selectedCapy"
    static let itemCounts = "itemCounts"
}

class HomeVC: BaseVC {

    @IBOutlet var lbs: [UILabel]!
    @IBOutlet weak var item1Count: UILabel!
    @IBOutlet weak var item2Count: UILabel!
    @IBOutlet weak var item3Count: UILabel!
    @IBOutlet weak var item4Count: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var capyImg: UIImageView!
    @IBOutlet weak var itemView: UIImageView!

    @IBOutlet weak var foodStack: UIStackView!
    @IBOutlet var foodBtns: [UIButton]!
    
    private var isShowFood: Bool = false {
        didSet {
            foodStack.isHidden = !isShowFood
        }
    }

    private let maxDrops = 10
    private var activeDrops = 0
    private var itemCounts: [Int] = [0,0,0,0] {
        didSet { saveItemCounts(); updateLabels() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItemCounts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        loadSelectedCapy()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scheduleNextDrop()
    }

    private func setupView() {
        lbs.forEach { $0.font = UIFont.HoltwoodOneSC(16) }
        isShowFood = false
        for (i, btn) in foodBtns.enumerated() {
            btn.tag = i
            btn.addTarget(self, action: #selector(foodBtnTapped(_:)), for: .touchUpInside)
        }
    }

    // MARK: - Persistence
    private func saveItemCounts() {
        UserDefaults.standard.set(itemCounts, forKey: DefaultsKey.itemCounts)
    }

    private func loadItemCounts() {
        if let arr = UserDefaults.standard.array(forKey: DefaultsKey.itemCounts) as? [Int], arr.count == 4 {
            itemCounts = arr
        }
    }

    // MARK: - Capy
    private func loadSelectedCapy() {
        let idx = UserDefaults.standard.integer(forKey: DefaultsKey.selectedCapy)
        let name = "capy_home_\(idx + 1)"
        capyImg.image = UIImage(named: name)
    }

    // MARK: - Drops
    private func scheduleNextDrop() {
        guard activeDrops < maxDrops else { return }
        let delay = TimeInterval.random(in: 5...20)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.performDrop()
        }
    }

    private func performDrop() {
        guard activeDrops < maxDrops else { return }
        activeDrops += 1

        let idx = UserDefaults.standard.integer(forKey: DefaultsKey.selectedCapy)
        let imageName = "item_\(idx+1)"
        guard let img = UIImage(named: imageName) else { activeDrops -= 1; return }
        let drop = UIImageView(image: img)
        drop.isUserInteractionEnabled = true

        let maxSide: CGFloat = 60
        let aspect = img.size.width / img.size.height
        let width = min(img.size.width, maxSide)
        let height = width / aspect
        drop.frame = CGRect(
            x: capyImg.frame.midX - width/2,
            y: capyImg.frame.minY - height - 10,
            width: width,
            height: height
        )
        view.addSubview(drop)

        drop.accessibilityIdentifier = imageName
        drop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDropTap(_:))))

        let dropArea = itemView.frame.intersection(view.bounds)
        let destX = CGFloat.random(in: dropArea.minX ... dropArea.maxX - width)
        let destY = CGFloat.random(in: dropArea.minY ... dropArea.maxY - height)

        UIView.animate(
            withDuration: 0.3, delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 2,
            options: [],
            animations: { drop.center.y -= 15 },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.8,
                    animations: { drop.frame.origin = CGPoint(x: destX, y: destY) },
                    completion: { [weak self] _ in
                        self?.scheduleNextDrop()
                    }
                )
            }
        )
    }

    @objc private func handleDropTap(_ g: UITapGestureRecognizer) {
        guard let drop = g.view as? UIImageView,
              let id = drop.accessibilityIdentifier,
              id.starts(with: "item_"),
              let num = Int(id.split(separator: "_")[1]) else { return }
        let index = num - 1
        itemCounts[index] += 1
        drop.removeFromSuperview()
        activeDrops -= 1
        let delay = TimeInterval.random(in: 1...3)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.scheduleNextDrop()
        }
    }

    // MARK: - Food Action
    @objc private func foodBtnTapped(_ sender: UIButton) {
        // Calculate total available
        let totalAvailable = itemCounts.reduce(0, +)
        if totalAvailable < 10 {
            showMsg(message: "Not enough balance")
            return
        }

        // Deduct 10 in order from itemCounts[0] to itemCounts[3]
        var remaining = 10
        for i in 0..<itemCounts.count {
            if itemCounts[i] >= remaining {
                itemCounts[i] -= remaining
                remaining = 0
                break
            } else {
                remaining -= itemCounts[i]
                itemCounts[i] = 0
            }
        }
        updateLabels()

        // Existing animation logic
        let idx = sender.tag
        let selected = UserDefaults.standard.integer(forKey: DefaultsKey.selectedCapy)
        capyImg.image = UIImage(named: "capy_eat_\(selected+1)")

        let eatImageName = "eat_\(idx+1)"
        guard let img = UIImage(named: eatImageName) else { return }
        let feed = UIImageView(image: img)
        feed.contentMode = .scaleAspectFit

        let btnCenter = sender.convert(CGPoint(x: sender.bounds.midX, y: sender.bounds.midY), to: view)
        let size = min(feed.image!.size.width, 60)
        feed.frame = CGRect(x: 0, y: 0, width: size, height: size)
        feed.center = btnCenter
        view.addSubview(feed)

        let dest = capyImg.convert(CGPoint(x: capyImg.bounds.midX, y: capyImg.bounds.midY), to: view)
        UIView.animate(withDuration: 0.5, animations: {
            feed.center = dest
        }, completion: { _ in
            feed.removeFromSuperview()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.capyImg.image = UIImage(named: "capy_home_\(selected+1)")
            }
        })
    }

    private func updateLabels() {
        item1Count.text = "\(itemCounts[0])"
        item2Count.text = "\(itemCounts[1])"
        item3Count.text = "\(itemCounts[2])"
        item4Count.text = "\(itemCounts[3])"
        total.text = "\(itemCounts.reduce(0, +))"
    }

    @IBAction func showFood(_ sender: Any) {
        isShowFood.toggle()
        let hidden = !isShowFood
        foodStack.isHidden = false
        let width = foodStack.frame.width
        foodStack.transform = CGAffineTransform(translationX: hidden ? 0 : width, y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.foodStack.transform = CGAffineTransform(translationX: hidden ? width : 0, y: 0)
        }, completion: { _ in
            self.foodStack.isHidden = hidden
        })
    }

    @IBAction func selectCapybara(_ sender: Any) {
        let vc = SelectCapyVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
