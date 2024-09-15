//
//  Model.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import Foundation

struct MovieInfo: Codable {
    var title, year, rated, released: String?
    var runtime, genre, director, writer: String?
    var actors, plot, language, country: String?
    var awards: String?
    var poster: String?
    var ratings: [Rating]?
    var metascore, imdbRating, imdbVotes, imdbID: String?
    var type, dvd, boxOffice, production: String?
    var website, response: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        
        title = try? values?.decodeIfPresent(String.self, forKey: .title)
        year = try? values?.decodeIfPresent(String.self, forKey: .year)
        rated = try? values?.decodeIfPresent(String.self, forKey: .rated)
        released = try? values?.decodeIfPresent(String.self, forKey: .released)
        runtime = try? values?.decodeIfPresent(String.self, forKey: .runtime)
        genre = try? values?.decodeIfPresent(String.self, forKey: .genre)
        director = try? values?.decodeIfPresent(String.self, forKey: .director)
        writer = try? values?.decodeIfPresent(String.self, forKey: .writer)
        actors = try? values?.decodeIfPresent(String.self, forKey: .actors)
        plot = try? values?.decodeIfPresent(String.self, forKey: .plot)
        language = try? values?.decodeIfPresent(String.self, forKey: .language)
        country = try? values?.decodeIfPresent(String.self, forKey: .country)
        awards = try? values?.decodeIfPresent(String.self, forKey: .awards)
        poster = try? values?.decodeIfPresent(String.self, forKey: .poster)
        ratings = try? values?.decodeIfPresent([Rating].self, forKey: .ratings)
        metascore = try? values?.decodeIfPresent(String.self, forKey: .metascore)
        imdbRating = try? values?.decodeIfPresent(String.self, forKey: .imdbRating)
        imdbVotes = try? values?.decodeIfPresent(String.self, forKey: .imdbVotes)
        imdbID = try? values?.decodeIfPresent(String.self, forKey: .imdbID)
        type = try? values?.decodeIfPresent(String.self, forKey: .type)
        dvd = try? values?.decodeIfPresent(String.self, forKey: .dvd)
        boxOffice = try? values?.decodeIfPresent(String.self, forKey: .boxOffice)
        production = try? values?.decodeIfPresent(String.self, forKey: .production)
        website = try? values?.decodeIfPresent(String.self, forKey: .website)
        response = try? values?.decodeIfPresent(String.self, forKey: .response)
    }
}

// MARK: - Rating
struct Rating: Codable {
    var source, value: String?

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

// MARK: - Search Results
struct SearchInfo: Codable {
    let search: [Search]
    let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
}


