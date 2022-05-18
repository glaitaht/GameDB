//
//  GameDetail.swift
//  GameDB
//
//  Created by Cem Kılıç on 6.03.2022.
//

import Foundation

struct GameDetail : Decodable{
    let id: Int?
    let name, description: String?
    let released: String? 
    let backgroundImage, backgroundImageAdditional: String?
    let rating: Double?
    let descriptionRaw: String?

    enum CodingKeys : String, CodingKey {
        case id, name
        case released
        case description = "description"
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case rating
        case descriptionRaw = "description_raw"
    }
}
