//
//  CreateDiaryVC.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//

import UIKit
import PhotosUI

protocol PhotoCellDelegate: AnyObject {
    func didTapDelete(at index: Int)
}

protocol TextTBVCellDelegate: AnyObject {
    func textViewDidBeginEditing()
}

class CreateDiaryVC: BaseVC {
    
    @IBOutlet weak var diaryTbv: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    let cells: [String] = [
        EmojiTBVCell.reuseIdentifier,
        PhotoTBVCell.reuseIdentifier,
        TextTBVCell.reuseIdentifier
    ]

    private var selectedImages: [UIImage] = [] {
        didSet {
            diaryTbv.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
    }

    var name: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTbv()
        registerKeyboardNotifications()
        saveBtn.titleLabel?.font = UIFont.HoltwoodOneSC(16)
        saveBtn.layer.cornerRadius = 20
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setupTbv() {
        diaryTbv.registerCell(cellType: EmojiTBVCell.self)
        diaryTbv.registerCell(cellType: PhotoTBVCell.self)
        diaryTbv.registerCell(cellType: TextTBVCell.self)
        diaryTbv.delegate = self
        diaryTbv.dataSource = self
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let info = notification.userInfo,
              let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = frame.height
        diaryTbv.contentInset.bottom = keyboardHeight
        diaryTbv.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        diaryTbv.contentInset.bottom = 0
        diaryTbv.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func pickerImage(_ sender: Any) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.presentPicker()
                    }
                }
            }
        } else if status == .authorized || status == .limited {
            presentPicker()
        } else {
            let alert = UIAlertController(title: "Photo Access Denied",
                                          message: "Please allow photo access in Settings",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 0
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }


    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func save(_ sender: Any) {
        guard let textCell = diaryTbv.cellForRow(at: IndexPath(row: 2, section: 0)) as? TextTBVCell,
              let titleText = textCell.titleTf.text,
              !titleText.trimmingCharacters(in: .whitespaces).isEmpty,
              let bodyText = textCell.diaryTv.text,
              !bodyText.trimmingCharacters(in: .whitespaces).isEmpty
        else { return }

        let id = UUID()
        let fileNames = selectedImages.enumerated().map { index, _ in "\(id.uuidString)_\(index).jpg" }
        let entry = DiaryEntry(
            id: id,
            emotionName: name,
            title: titleText,
            body: bodyText,
            imageFileNames: fileNames,
            date: Date()
        )

        do {
            try DiaryViewModel.shared.save(entry: entry, images: selectedImages)
            self.showMsg(message: "Save Success")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Save failed: \(error)")
        }
    }
    
}

extension CreateDiaryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
            case EmojiTBVCell.reuseIdentifier:
                let cell = tableView.dequeue(cellType: EmojiTBVCell.self, for: indexPath)
                cell.configure(name: self.name)
                return cell
            case PhotoTBVCell.reuseIdentifier:
                let cell = tableView.dequeue(cellType: PhotoTBVCell.self, for: indexPath)
                cell.setup(images: selectedImages, delegate: self)
                return cell
            case TextTBVCell.reuseIdentifier:
                let cell = tableView.dequeue(cellType: TextTBVCell.self, for: indexPath)
                return cell
            default:
                fatalError("Invalid cell type")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {
            case EmojiTBVCell.reuseIdentifier: return EmojiTBVCell.height
            case PhotoTBVCell.reuseIdentifier: return PhotoTBVCell.height
            case TextTBVCell.reuseIdentifier: return TextTBVCell.height
            default:
                fatalError("Invalid cell type")
        }
    }
}

extension CreateDiaryVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProviders = results.map { $0.itemProvider }
        for provider in itemProviders {
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    guard let self = self, let uiImage = image as? UIImage else { return }
                    DispatchQueue.main.async {
                        self.selectedImages.append(uiImage)
                    }
                }
            }
        }
    }
}

extension CreateDiaryVC: PhotoCellDelegate {
    func didTapDelete(at index: Int) {
        selectedImages.remove(at: index)
    }
}
