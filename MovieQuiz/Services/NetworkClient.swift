import Foundation

struct NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    private let apikey = "k_zcuw1ytf"
    
    private let url = "https://tv-api.com/en/API/Top250TVs/k_zcuw1ytf"
    
    func fetch(url: URL, handler: @escaping(Result<Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}


