//
//  Service.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import Foundation

class NetworkManager {
    
    class func fetchMovies(urlstr: String, completion: @escaping(Result<MovieInfo, Error>) -> Void) {
        
        var request: URLRequest?
        
        print(urlstr)
        
        request = URLRequest(url: URL(string: urlstr)!)
        
        request?.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request!) { (data, response, _) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                successCode = httpResponse.statusCode
                
                if successCode == 200 {
                    
                    if let data = data {
                        
                        let res = try! JSONDecoder().decode(MovieInfo.self, from: data)
                        
                        completion(.success(res))
                        
                    }else {
                        
                        completion(.failure(MyErrors.ParsingError))
                    }
                }else {
                    
                    completion(.failure(MyErrors.ParsingError))
                }
            }
        }
        task.resume()
    }
    
    class func searchMovies(urlstr: String, movieName: String, completion: @escaping(Result<[Search], Error>) -> Void) {
        
        let urlComps: NSURLComponents?
        let urlComps1: NSURLComponents?
        let result: URL?
        let results: URL?
        var request: URLRequest?
        //var responseModel = SearchInfo()
        
        let ress = "&s=\(movieName)"
        
        
        
        request = URLRequest(url: URL(string: urlstr+(ress))!)
        print(request)
        
        request?.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request!) { (data, response, _) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                successCode = httpResponse.statusCode
                
                if successCode == 200 {
                    
                    if let data = data {
                        
                        let res = try! JSONDecoder().decode(SearchInfo.self, from: data)
                        
                        completion(.success(res.search))
                        
                    }else {
                        
                        completion(.failure(MyErrors.ParsingError))
                    }
                    
                }else {
                    
                    completion(.failure(MyErrors.ParsingError))
                }
            }
        }
        task.resume()
    }
}
