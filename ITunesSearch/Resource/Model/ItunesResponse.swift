//
//  ItunesResponse.swift
//  ITunesSearch
//
//  Created by 김성민 on 8/8/24.
//

import Foundation

struct ItunesResponse: Decodable {
    let resultCount: Int
    let results: [ItunesItem]
}

struct ItunesItem: Decodable {
    let artworkUrl60: String
    let artistName: String
    let genres: [String]
    let description: String
    let releaseNotes: String
    let trackName: String
    let version: String
}
