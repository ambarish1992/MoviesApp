//
//  MovieListViewController.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import UIKit

class MovieListViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var SearchTxt: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataModel: [MovieInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.SearchTxt.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.FetchMovie()
    }
    
    func FetchMovie() {
        
        FIOProgressView.shared.showProgressView(self.view)
        NetworkManager.fetchMovies(urlstr: moviesFetchEndPoint) { res in
            
            if successCode == 200 {
                
                FIOProgressView.shared.hideProgressView()
                var results = res.map { resultss in
                    
                    self.dataModel.append(resultss)
                    
                    DispatchQueue.main.async { [weak self] in
                        
                        self?.tableView.reloadData()
                    }
                }
            }else {
                
                FIOProgressView.shared.hideProgressView()
                self.showAlert(title: "Warning", msg: "Please check the api or the url")
            }
        }
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        
        let res = self.dataModel[indexPath.row]
        
        let actualUrl = res.poster ?? ""
        
        if actualUrl != "" {
            
            cell.MovieImg.imageFromServerURL(actualUrl, placeHolder: UIImage(systemName: "wrongwaysign.fill"))
        }
        
        cell.titleLbl.text = res.title ?? ""
        cell.dateLbl.text = res.released ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let res = self.dataModel[indexPath.row]
        let VC = self.storyboard!.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        VC.movieData = res
        self.present(VC, animated: true)
        
    }
}
