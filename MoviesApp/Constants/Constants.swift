//
//  Constants.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import Foundation

let apiKey = "1667d104"
let type = "movie"

var successCode = HTTPURLResponse().statusCode
let baseURL = "https://www.omdbapi.com/?"
let moviesFetchEndPoint = "\(baseURL)i=tt3896198&apikey=1667d104"

let SearchResEndPoint = "\(baseURL)?apikey=\(apiKey)"




