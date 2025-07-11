//
//  GameVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 12/6/25.
//

import UIKit

enum EditType {
    case island, clothes, hat, capy
}

class GameVC: BaseVC {

    private let columns: CGFloat = checkIphone ? 5 : 6
    private let spacing: CGFloat = checkIphone ? 30 : 50
    private let padding: CGFloat = checkIphone ? 15 : 20

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var islandImg: UIImageView!
    @IBOutlet weak var capybaraImg: UIImageView!
    @IBOutlet weak var editClv: UICollectionView!

    var editType: EditType = .island {
        didSet { loadItems() }
    }

    // Data sources
    let islands = (1...3).map { "island\($0)" }
    let capyVaras = (1...15).map { "capy\($0)" }
    let clothes = (1...6).map { "clothes\($0)" }
    let hats = (1...9).map { "hat\($0)" }

    // Overlay containers
    private var clothesContainer: UIView?
    private var hatContainer: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        islandImg.image = UIImage(named: islands[0])
        capybaraImg.image = UIImage(named: capyVaras[0])
        // Enable pinch (and pan) on capybara image
        capybaraImg.isUserInteractionEnabled = true
        let capyPan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let capyPinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        capybaraImg.addGestureRecognizer(capyPan)
        capybaraImg.addGestureRecognizer(capyPinch)
        loadItems()
    }

    private func setup() {
        editClv.registerCell(cellType: PhotoCell.self)
        editClv.delegate = self
        editClv.dataSource = self
    }

    private func loadItems() {
        editClv.reloadData()
    }

    @IBAction func islandClick(_ sender: Any) { editType = .island }
    @IBAction func clothesClick(_ sender: Any) { editType = .clothes }
    @IBAction func hatClick(_ sender: Any) { editType = .hat }
    @IBAction func capyClick(_ sender: Any) { editType = .capy }

    // MARK: - Overlay Creation
    private func addOverlay(imageName: String, existingContainer: inout UIView?) {
        if let old = existingContainer {
            old.removeFromSuperview()
            existingContainer = nil
        }
        let size: CGFloat = 200
        let container = UIView(frame: CGRect(x: (contentView.bounds.width-size)/2,
                                             y: (contentView.bounds.height-size)/2,
                                             width: size,
                                             height: size))
        container.backgroundColor = .clear

        let iv = UIImageView(frame: container.bounds)
        iv.image = UIImage(named: imageName)
        iv.contentMode = .scaleAspectFit
        container.addSubview(iv)

        let btnSize: CGFloat = 24
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.frame = CGRect(x: container.bounds.width - btnSize,
                                 y: 0,
                                 width: btnSize,
                                 height: btnSize)
        deleteBtn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteBtn.tintColor = UIColor(hex: "#007340")
        deleteBtn.addTarget(self, action: #selector(handleDelete(_:)), for: .touchUpInside)
        container.addSubview(deleteBtn)
        deleteBtn.isHidden = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleContainerTap(_:)))
        container.addGestureRecognizer(tap)

        addGestures(to: container)
        contentView.addSubview(container)
        existingContainer = container
    }

    @objc private func handleDelete(_ sender: UIButton) {
        guard let container = sender.superview else { return }
        container.removeFromSuperview()
        if container == clothesContainer { clothesContainer = nil }
        if container == hatContainer { hatContainer = nil }
    }

    @objc private func handleContainerTap(_ g: UITapGestureRecognizer) {
        guard let container = g.view,
              let btn = container.subviews.compactMap({ $0 as? UIButton }).first else { return }
        btn.isHidden.toggle()
    }

    private func addGestures(to view: UIView) {
        view.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        view.addGestureRecognizer(pan)
        view.addGestureRecognizer(pinch)
        view.addGestureRecognizer(rotate)
    }

    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
        guard let v = g.view else { return }
        let t = g.translation(in: contentView)
        v.center = CGPoint(x: v.center.x + t.x, y: v.center.y + t.y)
        g.setTranslation(.zero, in: contentView)
    }
    @objc private func handlePinch(_ g: UIPinchGestureRecognizer) {
        guard let v = g.view else { return }
        v.transform = v.transform.scaledBy(x: g.scale, y: g.scale)
        g.scale = 1
    }
    @objc private func handleRotate(_ g: UIRotationGestureRecognizer) {
        guard let v = g.view else { return }
        v.transform = v.transform.rotated(by: g.rotation)
        g.rotation = 0
    }

    @IBAction func save(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(contentView.bounds.size, false, UIScreen.main.scale)
        contentView.drawHierarchy(in: contentView.bounds, afterScreenUpdates: true)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()

        let fm = FileManager.default
        guard let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let folder = docs.appendingPathComponent("GameCaptures")
        if !fm.fileExists(atPath: folder.path) {
            try? fm.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        let name = "capture_\(Date().timeIntervalSince1970).png"
        let url = folder.appendingPathComponent(name)
        if let data = img.pngData() {
            try? data.write(to: url)
            print("Saved to \(url)")
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension GameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ clv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch editType {
            case .island: return islands.count
            case .capy: return capyVaras.count
            case .clothes: return clothes.count
            case .hat: return hats.count
        }
    }
    func collectionView(_ clv: UICollectionView, cellForItemAt idx: IndexPath) -> UICollectionViewCell {
        let cell = clv.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: idx) as! PhotoCell
        let name: String
        switch editType {
            case .island: name = islands[idx.row]
            case .capy: name = capyVaras[idx.row]
            case .clothes: name = clothes[idx.row]
            case .hat: name = hats[idx.row]
        }
        cell.img.image = UIImage(named: name)
        cell.img.contentMode = .scaleAspectFit
        return cell
    }
    func collectionView(_ clv: UICollectionView, didSelectItemAt idx: IndexPath) {
        switch editType {
            case .island:
                islandImg.image = UIImage(named: islands[idx.row])
            case .capy:
                capybaraImg.image = UIImage(named: capyVaras[idx.row])
            case .clothes:
                addOverlay(imageName: clothes[idx.row], existingContainer: &clothesContainer)
            case .hat:
                addOverlay(imageName: hats[idx.row], existingContainer: &hatContainer)
        }
    }
    func collectionView(_ clv: UICollectionView, layout clvLayout: UICollectionViewLayout, sizeForItemAt idx: IndexPath) -> CGSize {
        let side = (clv.frame.width - padding * 2 - spacing * (columns - 1)) / columns
        let height: CGFloat = clv.frame.height - padding * 2
        return CGSize(width: side, height: height)
    }
    func collectionView(_ clv: UICollectionView, layout clvLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    func collectionView(_ clv: UICollectionView, layout clvLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
