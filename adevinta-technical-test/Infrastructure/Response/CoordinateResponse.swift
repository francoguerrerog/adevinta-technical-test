import Foundation

struct CoordinateResponse: Codable {
    let latitude: String
    let longitude: String
    
    func toCoordinate() -> Coordinate {
        return Coordinate(latitude: latitude,
                          longitude: longitude)
    }
}
