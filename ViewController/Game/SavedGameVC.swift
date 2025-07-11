//
//  SavedGameVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 12/6/25.
//

import UIKit

class SavedGameVC: BaseVC {

    private let columns: CGFloat = checkIphone ? 1 : 2
    private let spacing: CGFloat = checkIphone ? 50 : 75
    private let padding: CGFloat = checkIphone ? 25 : 40

    @IBOutlet weak var savedClv: UICollectionView!
    private var imageURLs: [URL] = []

    private let emptyImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "nodata"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedImages()

        if imageURLs.isEmpty {
            view.insertSubview(emptyImageView, at: 0)
            emptyImageView.center = view.center
        } else {
            emptyImageView.removeFromSuperview()
        }
        savedClv.reloadData()
    }

    private func setup() {
        savedClv.registerCell(cellType: GameCell.self)
        savedClv.delegate = self
        savedClv.dataSource = self
    }

    private func loadSavedImages() {
        let fm = FileManager.default
        guard let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let folder = docs.appendingPathComponent("GameCaptures")
        if let files = try? fm.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil) {
            imageURLs = files.filter { $0.pathExtension.lowercased() == "png" }
        }
        savedClv.reloadData()
    }

    @IBAction func game(_ sender: Any) {
        navigationController?.pushViewController(GameVC(), animated: true)
    }
    
}

extension SavedGameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ clv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func collectionView(_ clv: UICollectionView, cellForItemAt idx: IndexPath) -> UICollectionViewCell {
        let cell = clv.dequeue(cellType: GameCell.self, for: idx)
        let url = imageURLs[idx.row]
        if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
            cell.innerImg.image = img
        }
        return cell
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
        spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
