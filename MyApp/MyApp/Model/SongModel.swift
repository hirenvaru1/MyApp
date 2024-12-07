//
//  SongModel.swift
//  MyApp
//
//  Created by Hiren Varu on 07/12/24.
//

import Foundation

struct SongResult: Encodable, Decodable{
    let collectionName: String?
    let artistName: String?
    let collectionPrice: Double?
    let collectionViewUrl: String?
    let artworkUrl100: String?
    let artistId: Int?
}

struct ITunesSearchResponse: Encodable, Decodable{
    let resultCount: Int?
    let results: [SongResult]?
}

struct NewLibrary: Encodable, Decodable{
    var allSong: [SongResult]?
    var name: String?
}

struct AllYourLibrary: Encodable, Decodable{
    var AllLibrary: [NewLibrary] = []
}
