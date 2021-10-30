//
//  SongsModel.swift
//  API Project
//
//  Created by Roman on 24.10.2021.
//

import Foundation

struct SongsModel: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    let trackName: String? 
}
