//
//  MoviesTableViewCell.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var MovieImg: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        self.MovieImg.layer.cornerRadius = 15.0
        self.MovieImg.contentMode = .scaleAspectFill
        
    }
}
