//
//  DiaryEntry.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//


import UIKit

class DiaryViewModel {
    static let shared = DiaryViewModel()
    private init() {}

    private let folderName = "DiaryEntries"

    // Exposed folderURL for loading images
    var folderURL: URL? {
        let fm = FileManager.default
        guard let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let url = docs.appendingPathComponent(folderName)
        if !fm.fileExists(atPath: url.path) {
            try? fm.createDirectory(at: url, withIntermediateDirectories: true)
        }
        return url
    }

    func save(entry: DiaryEntry, images: [UIImage]) throws {
        guard let folderURL = folderURL else { return }
        let fm = FileManager.default

        // Save images
        for (idx, image) in images.enumerated() {
            let name = entry.imageFileNames[idx]
            let url = folderURL.appendingPathComponent(name)
            if let data = image.jpegData(compressionQuality: 0.8) {
                try data.write(to: url)
            }
        }
        // Save JSON
        let jsonURL = folderURL.appendingPathComponent("\(entry.id.uuidString).json")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(entry)
        try data.write(to: jsonURL)
    }

    func loadAll() -> [DiaryEntry] {
        guard let folderURL = folderURL else { return [] }
        let fm = FileManager.default
        var entries: [DiaryEntry] = []
        if let files = try? fm.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            for file in files where file.pathExtension == "json" {
                if let data = try? Data(contentsOf: file),
                   let entry = try? decoder.decode(DiaryEntry.self, from: data) {
                    entries.append(entry)
                }
            }
            // sort by date descending
            entries.sort { $0.date > $1.date }
        }
        return entries
    }
}
