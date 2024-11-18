//
//  House.swift
//  Thrones
//
//  Created by Aimee Hong on 11/11/24.
//

import Foundation

struct House: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String
    var words: String
    
    enum CodingKeys: CodingKey { // coding keys tells us which values in the struct we expect to decode using JSON
        case name, url, words
    }
}
