//
//  StatisticalVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 12/6/25.
//

import UIKit

class StatisticalVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let columns: CGFloat = checkIphone ? 3 : 5
    private let spacing: CGFloat = checkIphone ? 10 : 15
    private let padding: CGFloat = checkIphone ? 15 : 20

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var chartContainer: UIView!
    @IBOutlet weak var legendCollection: UICollectionView!

    private var entries: [DiaryEntry] = []
    private var counts: [String: Int] = [:]
    private var data: [(String, Int)] = []

    private let emptyImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "nodata"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let colors: [UIColor] = [UIColor(hex: "#F3DEF0"), UIColor(hex: "#F2DEB9"), UIColor(hex: "#DBC6FC"), UIColor(hex: "#F4A8A5"), UIColor(hex: "#B8F7DB"), UIColor(hex: "#F1F7AD"), UIColor(hex: "#FAC35C"), UIColor(hex: "#A5D3F9")]

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLb.font = UIFont.HoltwoodOneSC(32)
        setupChart()
        legendCollection.dataSource = self
        legendCollection.delegate = self
        legendCollection.registerCell(cellType: StatisticalLegendCell.self)
    }

    private func setupChart() {
        entries = DiaryViewModel.shared.loadAll()
        counts = [:]
        for entry in entries {
            counts[entry.emotionName, default: 0] += 1
        }
        data = counts.map { ($0.key, $0.value) }
        let pie = PieChartView(frame: chartContainer.bounds, data: data, colors: colors)
        pie.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        chartContainer.subviews.forEach { $0.removeFromSuperview() }
        chartContainer.addSubview(pie)
        legendCollection.reloadData()
        if data.isEmpty {
            view.insertSubview(emptyImageView, at: 0)
            emptyImageView.center = view.center
        } else {
            emptyImageView.removeFromSuperview()
        }
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellType: StatisticalLegendCell.self, for: indexPath)
        let (name, _) = data[indexPath.item]
        cell.dot.backgroundColor = colors[indexPath.item % colors.count]
        cell.label.text = name
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = 2 * padding + spacing * (columns - 1)
        let width = (collectionView.bounds.width - totalSpacing) / columns
        return CGSize(width: width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}
