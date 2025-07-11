//
//  SelectCapyVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 13/6/25.
//

import UIKit

class SelectCapyVC: BaseVC {

    private let columns: CGFloat = checkIphone ? 1 : 2
    private let spacing: CGFloat = checkIphone ? 50 : 75
    private let padding: CGFloat = checkIphone ? 25 : 40
    private let capyCount = 4

    @IBOutlet weak var capyClv: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        capyClv.registerCell(cellType: GameCell.self)
        capyClv.delegate = self
        capyClv.dataSource = self
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SelectCapyVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ clv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return capyCount
    }

    func collectionView(_ clv: UICollectionView, cellForItemAt idx: IndexPath) -> UICollectionViewCell {
        let cell = clv.dequeue(cellType: GameCell.self, for: idx)
        cell.innerImg.image = UIImage(named: "home_\(idx.item + 1)")
        return cell
    }

    func collectionView(_ clv: UICollectionView, didSelectItemAt idx: IndexPath) {
        let selected = idx.item
        UserDefaults.standard.set(selected, forKey: DefaultsKey.selectedCapy)
        UserDefaults.standard.synchronize()
        navigationController?.popViewController(animated: true)
    }

    func collectionView(_ clv: UICollectionView, layout clvLayout: UICollectionViewLayout, sizeForItemAt idx: IndexPath) -> CGSize {
        let total = clv.frame.width - spacing * (columns - 1) - padding * 2
        let side = total / columns
        return CGSize(width: side, height: side)
    }

    func collectionView(_ clv: UICollectionView, layout clvLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }

    func collectionView(_ clv: UICollectionView, layout clvLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}
