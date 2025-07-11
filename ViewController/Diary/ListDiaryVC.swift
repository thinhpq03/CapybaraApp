//
//  ListDiaryVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit

class ListDiaryVC: BaseVC {

    let padding: CGFloat = checkIphone ? 25 : 40
    let spacing: CGFloat = checkIphone ? 10 : 15
    let column: CGFloat = checkIphone ? 1 : 2

    @IBOutlet weak var listDiaryClv: UICollectionView!

    private var diaries: [DiaryEntry] = []

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()

    private let emptyImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "nodiary"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        listDiaryClv.registerCell(cellType: DiaryCell.self)
        listDiaryClv.delegate = self
        listDiaryClv.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diaries = DiaryViewModel.shared.loadAll()
        if diaries.isEmpty {
            view.insertSubview(emptyImageView, at: 0)
            emptyImageView.center = view.center
        } else {
            emptyImageView.removeFromSuperview()
        }
        listDiaryClv.reloadData()
    }

    @IBAction func createDiary(_ sender: Any) {
        let feelVC = FeelVC()
        navigationController?.pushViewController(feelVC, animated: true)
    }

    @IBAction func statistical(_ sender: Any) {
        navigationController?.pushViewController(StatisticalVC(), animated: true)
    }
    
}

extension ListDiaryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaries.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCell.reuseIdentifier, for: indexPath) as! DiaryCell
        let entry = diaries[indexPath.row]
        if let first = entry.imageFileNames.first,
           let url = DiaryViewModel.shared.folderURL?.appendingPathComponent(first),
           let data = try? Data(contentsOf: url),
           let img = UIImage(data: data) {
            cell.img.image = img
        } else {
            cell.img.image = UIImage(named: entry.emotionName)
        }
        cell.titleLb.text = entry.title
        cell.dateLb.text = dateFormatter.string(from: entry.date)
        return cell
    }
}

extension ListDiaryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - padding * 2 - spacing * (column - 1)) / column
        let height: CGFloat = width * 0.3
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
