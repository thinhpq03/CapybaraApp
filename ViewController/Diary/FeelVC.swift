//
//  FeelVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit

class FeelVC: BaseVC {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var emojiClv: UICollectionView!
    @IBOutlet weak var selectBtn: UIButton!
    
    let padding: CGFloat = checkIphone ? 30 : 40

    private let emojiNames: [String] = ["excited", "happy", "lovely", "surprised", "heavy mood", "calm down", "bored", "repentant"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }

    func setup() {
        titleLb.font = UIFont.HoltwoodOneSC(32)
        selectBtn.titleLabel?.font = UIFont.HoltwoodOneSC(20)
        selectBtn.layer.cornerRadius = 20
        emojiClv.registerCell(cellType: EmojiCell.self)
        emojiClv.delegate = self
        emojiClv.dataSource = self
    }

    @IBAction func next(_ sender: Any) {
        guard let visible = emojiClv.indexPathsForVisibleItems.sorted().first else { return }
        let nextRow = min(visible.row + 1, emojiNames.count - 1)
        let nextIndex = IndexPath(row: nextRow, section: 0)
        emojiClv.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
    }

    @IBAction func pre(_ sender: Any) {
        guard let visible = emojiClv.indexPathsForVisibleItems.sorted().first else { return }
        let prevRow = max(visible.row - 1, 0)
        let prevIndex = IndexPath(row: prevRow, section: 0)
        emojiClv.scrollToItem(at: prevIndex, at: .centeredHorizontally, animated: true)
    }

    @IBAction func selectTap(_ sender: Any) {
        guard let visible = emojiClv.indexPathsForVisibleItems.sorted().first else { return }
        let selectedName = emojiNames[visible.row]
        let vc = CreateDiaryVC()
        vc.name = selectedName
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

extension FeelVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as! EmojiCell
        let name = emojiNames[indexPath.row]
        cell.configureCell(name: name)
        return cell
    }
}

extension FeelVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - padding * 2
        let height: CGFloat = collectionView.frame.height - padding * 2
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        padding * 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        padding * 2
    }
}
