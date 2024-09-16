//
//  MovieListViewController.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 15/09/24.
//

import UIKit

class MovieListViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchTrailConstraint: NSLayoutConstraint!
    @IBOutlet weak var SearchTxt: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataModel: [MovieInfo] = []
    var searchData: [Search] = []
    var isChecked = false
    var result = UserDefaults.standard
    var status: String?
    var searchStat: String?
    var isSearch = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isSearch = false
        self.searchTrailConstraint.constant = 0
        self.SearchTxt.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        
        self.doSearch()
        
        if self.searchStat == "yes" {
            
            self.searchTrailConstraint.constant = 0
            SearchTxt.text = ""
            self.SearchTxt.resignFirstResponder()
            self.dataModel = []
            self.FetchMovie()
            
        }else {
            
            self.doSearch()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.checkInternet()
        
        self.dataModel = []
        self.FetchMovie()
    }
    
    func FetchMovie() {
        
        self.dataModel = []
        self.isSearch = false
        FIOProgressView.shared.showProgressView(self.view)
        NetworkManager.fetchMovies(urlstr: moviesFetchEndPoint) { res in
            
            if successCode == 200 {
                
                FIOProgressView.shared.hideProgressView()
                var results = res.map { resultss in
                    
                    self.dataModel = []
                    self.dataModel.append(resultss)
                    
                    DispatchQueue.main.async { [weak self] in
                        
                        self?.SearchTxt.resignFirstResponder()
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
        
        if self.isSearch == true {
            
            if self.searchData.count > 0 {
                
                self.tableView.restore()
                return self.searchData.count
                
            }else {
                
                self.tableView.setEmptyMessage("No results found", color: .black)
                return 0
            }
            
        }else {
            
            if self.dataModel.count > 0 {
                
                self.tableView.restore()
                return self.dataModel.count
                
            }else {
                
                self.tableView.setEmptyMessage("No results found", color: .black)
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        
        if self.isSearch == true {
            
            cell.favBtn.isHidden = true
            
            let res = self.searchData[indexPath.row]
            
            let actualUrl = res.poster
            
            if actualUrl != "" {
                
                cell.MovieImg.imageFromServerURL(actualUrl ?? "", placeHolder: UIImage(systemName: "wrongwaysign.fill"))
            }
            
            cell.titleLbl.text = res.title 
            cell.dateLbl.text = res.year
            
        }else {
            
            cell.favBtn.isHidden = false
            let res = self.dataModel[indexPath.row]
            let actualUrl = res.poster ?? ""
            
            if actualUrl != "" {
                
                cell.MovieImg.imageFromServerURL(actualUrl, placeHolder: UIImage(systemName: "wrongwaysign.fill"))
            }
            
            let rr = self.result.string(forKey: "status")
            
            print(rr)
            
            if rr == "yes" {
                
                cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
            }else {
                
                cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                
            }
            
            cell.titleLbl.text = res.title ?? ""
            cell.dateLbl.text = res.released ?? ""
            
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(self.FavBtnTapped), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    @objc func FavBtnTapped(sender: UIButton) {
        
        self.isChecked = !self.isChecked
        let index = IndexPath(row: sender.tag, section: 0)
        
        if let cell = self.tableView.cellForRow(at: index) as? MoviesTableViewCell {
            
            if self.isChecked == true {
                
                self.status = "yes"
                cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.result.removeObject(forKey: "status")
                self.result.set(self.status, forKey: "status")
                self.result.synchronize()
                self.FetchMovie()
                
            }else {
                
                self.status = "no"
                cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                self.result.removeObject(forKey: "status")
                self.result.set(self.status, forKey: "status")
                self.result.synchronize()
                self.FetchMovie()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isSearch == false {
            
            if self.dataModel.count > 0 {
                
                let res = self.dataModel[indexPath.row]
                let VC = self.storyboard!.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
                VC.movieData = res
                self.present(VC, animated: true)
                
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.doSearch()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchTrailConstraint.constant = -50
        self.SearchTxt.becomeFirstResponder()
        
//        if self.SearchTxt.text != "" {
//            
//            self.searchTrailConstraint.constant = -50
//            self.isSearch = true
//            
//        }else {
//            
//            self.searchTrailConstraint.constant = 0
//            self.isSearch = false
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if self.SearchTxt.text != "" {
            
            self.searchStat = "yes"
            self.searchBtn.setImage(UIImage(named: "Close"), for: .normal)
            
        }else {
            
            self.searchStat = "no"
            self.searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        }
    }
    
    func doSearch() {
        
        self.searchTrailConstraint.constant = -50
        self.isSearch = true
        if SearchTxt.text != "" {
            
            let res = SearchTxt.text
            
            let ress = res?.lowercased()
            
            FIOProgressView.shared.showProgressView(self.view)
            NetworkManager.searchMovies(urlstr: SearchResEndPoint, movieName: ress ?? "") { res in
                
                if successCode == 200 {
                    
                    FIOProgressView.shared.hideProgressView()
                    var results = res.map { resultss in
                        
                        let newArr = resultss.sorted { $0.year ?? "" > $1.year ?? "" }
                        self.searchData = newArr
                        
                        print(self.searchData)
                        
                        DispatchQueue.main.async {
                            
                            self.SearchTxt.resignFirstResponder()
                            self.tableView.reloadData()
                            
                        }
                    }
                }else {
                    
                    FIOProgressView.shared.hideProgressView()
                    self.showAlert(title: "Warning", msg: "Please check the api or the url")
                }
            }
            
        }else {
            
            //self.isSearch = false
            self.searchTrailConstraint.constant = 0
            self.dataModel = []
            self.dataModel.removeAll()
            //self.showAlert(title: "Warning", msg: "Please type a movie to search")
            self.FetchMovie()
        }
    }
}
