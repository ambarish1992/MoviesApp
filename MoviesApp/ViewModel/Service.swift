//
//  Service.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import Foundation

typealias ResultHandler<T> = (Result<T, MyErrors>) -> Void

final class APIManager {

    static let shared = APIManager()
    private let networkHandler: NetworkHandler
    private let responseHandler: ResponseHandler

    init(networkHandler: NetworkHandler = NetworkHandler(),
         responseHandler: ResponseHandler = ResponseHandler()) {
        self.networkHandler = networkHandler
        self.responseHandler = responseHandler
    }

    func request<T: Codable>(
        modelType: T.Type,
        url: URL?,
        completion: @escaping ResultHandler<T>
    ) {
        guard let url = url else {
            completion(.failure(.invalidURL)) // I forgot to mention this in the video
            return
        }

        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.allHTTPHeaderFields = ["Content-Type": "application/json"]

        // Network Request - URL TO DATA
        networkHandler.requestDataAPI(url: request) { result in
            switch result {
            case .success(let data):
                // Json parsing - Decoder - DATA TO MODEL
                self.responseHandler.parseResonseDecode(
                    data: data,
                    modelType: modelType) { response in
                        switch response {
                        case .success(let mainResponse):
                            completion(.success(mainResponse)) // Final
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }

}

class NetworkHandler {

    func requestDataAPI(
        url: URLRequest,
        completionHandler: @escaping (Result<Data, MyErrors>) -> Void
    ) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completionHandler(.failure(.invalidResponse))
                return
            }

            guard let data, error == nil else {
                completionHandler(.failure(.invalidData))
                return
            }

            completionHandler(.success(data))
        }
        session.resume()
    }
}

class ResponseHandler {

    func parseResonseDecode<T: Decodable>(
        data: Data,
        modelType: T.Type,
        completionHandler: ResultHandler<T>
    ) {
        
        do {
            let userResponse = try JSONDecoder().decode(modelType, from: data)
            
            completionHandler(.success(userResponse))
        }catch {
            completionHandler(.failure(.decoding(error)))
        }
    }
}
