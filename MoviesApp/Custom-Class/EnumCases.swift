//
//  EnumCases.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import Foundation

enum MyErrors: Error {
    
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
    
}

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}
