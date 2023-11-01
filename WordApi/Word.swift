//
//  Word.swift
//  WordApi
//
//  Created by Alexey Manokhin on 31.10.2023.
//

import Foundation

struct Word: Codable {
    let value: String
    let date: String
    let clarification: String
    let photo: String
}

struct WordData: Codable {
    let data: [Word]
}
