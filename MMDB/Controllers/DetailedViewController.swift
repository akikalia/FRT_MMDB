//
//  DetailedViewController.swift
//  MMDB
//
//  Created by Alex kikalia on 09.05.21.
//

import UIKit
import CoreData

class DetailedViewController: UIViewController{
    
    @IBOutlet var movieTitle: UILabel!
    
    @IBOutlet var ogTitle: UILabel!
    
    @IBOutlet var poster: UIImageView!
    
    @IBOutlet var rating: UIProgressView!
    
    @IBOutlet var overview: UILabel!
    
    @IBOutlet var releaseDate: UILabel!
    
    @IBOutlet var filledBtn: UIButton!
    
    
    @IBOutlet var addedMessage: UILabel!
    
    @IBOutlet var ratingLabel: UILabel!
    
    var dbContext = DBManager.shared.persistentContainer.viewContext
    
    var movie: MovieData?
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDataFromMovie()
    }
    
    func initDataFromMovie(){
        guard let movie = movie else{return}
        self.movieTitle.text = movie.title
        self.ogTitle.text = movie.og_title
        self.overview.text = movie.overview
//        self.poster = movie.poster
        self.rating.progress = movie.rating / 10.0
        self.ratingLabel.text = String(movie.rating)
        self.releaseDate.text = movie.release_date
        poster.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/" + movie.poster), placeholderImage: UIImage(named: movie.title))
        addedMessage.isHidden = true
    }
    
    @IBAction func filledTap(_ sender: Any) {
        let currMovie = Movie(context: dbContext)
        if let movie = movie {
            currMovie.id = Int64(movie.id)
            currMovie.title = movie.title
            currMovie.og_title = movie.og_title
            currMovie.overview = movie.overview
            currMovie.poster = movie.poster
            currMovie.release_date = movie.release_date
            currMovie.rating = movie.rating
            currMovie.image = poster.image?.pngData()
            do{
                try dbContext.save()
            }catch{}
            addedMessage.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.addedMessage.isHidden = true
            }
        }
    }
}

