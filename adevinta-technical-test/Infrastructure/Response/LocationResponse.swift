import Foundation

struct LocationResponse: Codable {
    let street: StreetResponse
    let city: String
    let state: String
    let country: String
    let postcode: String
    let coordinates: CoordinateResponse
    let timezone: UserTimeZoneResponse
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try container.decode(StreetResponse.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        if let value = try? container.decode(Int.self, forKey: .postcode) {
            postcode = String(value)
        } else {
            postcode = try container.decode(String.self, forKey: .postcode)
        }
        coordinates = try container.decode(CoordinateResponse.self, forKey: .coordinates)
        timezone = try container.decode(UserTimeZoneResponse.self, forKey: .timezone)
    }
    
    func toLocation() -> Location {
        return Location(street: street.toStreet(),
                        city: city,
                        state: state,
                        country: country,
                        postcode: postcode,
                        coordinates: coordinates.toCoordinate(),
                        timezone: timezone.toUserTimeZone())
    }
    
    init(location: Location) {
        self.street = StreetResponse(street: location.street)
        self.city = location.city
        self.state = location.state
        self.country = location.country
        self.postcode = location.postcode
        self.coordinates = CoordinateResponse(coordinates: location.coordinates)
        self.timezone = UserTimeZoneResponse(timeZone: location.timezone)
    }
}
