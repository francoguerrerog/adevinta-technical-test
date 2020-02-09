import Foundation

struct CoordinateResponse: Codable {
    let latitude: String
    let longitude: String
    
    func toCoordinate() -> Coordinate {
        return Coordinate(latitude: latitude,
                          longitude: longitude)
    }
    
    init(coordinates: Coordinate) {
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
    }
}
