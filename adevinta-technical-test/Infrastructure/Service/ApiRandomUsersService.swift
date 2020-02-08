import Foundation
import RxSwift

class ApiRandomUsersService: RandomUsersService {
    
    private let urlSession = URLSession.shared
    
    func find() -> Single<RandomUsers> {
        return Single<RandomUsers>.create { single in
            guard let url = URL(string: "http://api.randomuser.me/?results=40") else {
                return single(.error(ApiError.urlError)) as! Disposable
            }
            
            let urlRequest = self.createRequest(url: url)
            
            let task = self.urlSession.dataTask(with: urlRequest) { (data, response, error) -> Void in
                guard error == nil else {
                    return single(.error(ApiError.fetchingError))
                }
                let decoder = self.createDecoder()
                
                guard let data = data,
                    let responseObject = try? decoder.decode(RandomUsersResponse.self, from: data) else {
                        return single(.error(ApiError.fetchingError))
                }
                let randomUsers = responseObject.toRandomUsers()
                return single(.success(randomUsers))
            }
            
            task.resume()
            return Disposables.create { }
        }
    }
    
    private func createRequest(url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
    
    private func createDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return formatter
    }
    
    private func createDecoder() -> JSONDecoder {
        let formatter = createDateFormatter()
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }
}
