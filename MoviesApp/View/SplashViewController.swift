//
//  SplashViewController.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            let VC = self.storyboard!.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
            self.present(VC, animated: true)
            
        }
    }
}
