//
//  MovieEntity.swift
//  MMDB
//
//  Created by Alex kikalia on 09.05.21.
//

import Foundation
import SDWebImage

class MovieData{
    var og_title: String
    var title : String
    var overview : String
    var poster : String
    var rating : Float
    var release_date : String
    var id : Int
//    var image : UIImageView?
    
    init(movie: Movie) {
        self.id = Int(movie.id)
        self.title = movie.title ?? ""
        self.og_title = movie.og_title ?? ""
        self.overview = movie.overview ?? ""
        self.poster = movie.poster ?? ""
        self.rating = Float(movie.rating)
        self.release_date = movie.release_date ?? ""
//        self.image = movie.posterPath
    }
    
    init(movieEntry: MovieEntry) {
        self.id = movieEntry.id
        self.title = movieEntry.title
        self.og_title = movieEntry.originalTitle
        self.overview = movieEntry.overview
        self.poster = movieEntry.posterPath
        self.rating = Float(movieEntry.voteAverage)
        self.release_date = movieEntry.releaseDate
//        self.image?
    }
}
