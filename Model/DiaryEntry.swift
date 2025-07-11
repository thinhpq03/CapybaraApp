//
//  DiaryEntry.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 11/6/25.
//


import UIKit

// MARK: - Model
struct DiaryEntry: Codable {
    let id: UUID
    let emotionName: String
    let title: String
    let body: String
    let imageFileNames: [String]
    let date: Date
}
