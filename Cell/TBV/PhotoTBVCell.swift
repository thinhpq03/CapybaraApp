//
//  PhotoTBVCell.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit

class PhotoTBVCell: UITableViewCell {

    static let height: CGFloat = checkIphone ? 120 : 180
    let padding: CGFloat = checkIphone ? 25 : 40
    @IBOutlet weak var photoClv: UICollectionView!

    private var images: [UIImage] = []
    private weak var delegate: PhotoCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        photoClv.registerCell(cellType: PhotoCell.self)
        photoClv.delegate = self
        photoClv.dataSource = self
    }

    func setup(images: [UIImage], delegate: PhotoCellDelegate) {
        self.images = images
        self.delegate = delegate
        photoClv.reloadData()
    }
}

extension PhotoTBVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cellType: PhotoCell.self, for: indexPath)
        cell.img.image = images[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapDelete(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 100 / 75
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        padding
    }
}
