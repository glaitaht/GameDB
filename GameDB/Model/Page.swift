import Foundation

struct Page: Decodable {
    let next: String?
    let previous: String?
    let results: [Game]
}
   
struct Game:  Decodable, Hashable, Identifiable {
    let id: Int?
    let name, released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double?
    
    init(_ gameDetail: GameDetail) {
        id = gameDetail.id
        name = gameDetail.name
        released = gameDetail.released
        backgroundImage = gameDetail.backgroundImage
        rating = gameDetail.rating
        tba = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, tba
        case backgroundImage = "background_image"
        case rating
    }
}
