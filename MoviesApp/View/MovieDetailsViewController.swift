//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var MovieImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var IMDBrateLbl: UILabel!
    @IBOutlet weak var RottenTomatoesrateLbl: UILabel!
    @IBOutlet weak var MetacriticrateLbl: UILabel!
    let cornerRadius : CGFloat = 25.0
    var movieData: MovieInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            
            let actualUrl = self.movieData?.poster ?? ""
            
            if actualUrl != "" {
                
                self.MovieImg.imageFromServerURL(actualUrl, placeHolder: UIImage(systemName: "wrongwaysign.fill"))
                self.MovieImg.contentMode = .scaleAspectFill
            }
            
            self.titleLbl.text = self.movieData?.title
            self.genreLbl.text = self.movieData?.genre
            self.descriptionLbl.text = self.movieData?.plot
            self.IMDBrateLbl.text = "\(self.movieData?.imdbRating ?? "")/10"
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        self.MovieImg.layer.cornerRadius = cornerRadius
        self.MovieImg.layer.shadowColor = UIColor.gray.cgColor
        self.MovieImg.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.MovieImg.layer.shadowRadius = 25.0
        self.MovieImg.layer.shadowOpacity = 0.9
        
    }
}
