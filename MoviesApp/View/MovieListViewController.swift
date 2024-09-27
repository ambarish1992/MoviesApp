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
    
    //var dataModel: [MovieInfo] = []
    var searchTimer: Timer?
   // var searchDatas: [Search] = []
    var isChecked = false
    var result = UserDefaults.standard
    var status: String?
    var searchStat: String?
    var isSearch = Bool()
    
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.isSearch = false
        self.addToolBar(textField: self.SearchTxt)
        self.searchTrailConstraint.constant = 0
        self.SearchTxt.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        
        if self.searchStat == "yes" {
            
            self.searchTrailConstraint.constant = 0
            SearchTxt.text = ""
            self.SearchTxt.resignFirstResponder()
            self.viewModel.dataModel = []
            self.viewModel.fetchData()
            
        }else {
            
            let res = SearchTxt.text
            let ress = res?.lowercased()
            
            self.viewModel.searchMovies(movieName: ress ?? "")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.global().async {
            
            self.observeEvent()
            self.checkInternet()
            self.viewModel.dataModel = []
            self.viewModel.fetchData()
            
        }
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isSearch == true {
            
            if self.viewModel.searchData.count > 0 {
                
                self.tableView.restore()
                return self.viewModel.searchData.count
                
            }else {
                
                self.tableView.setEmptyMessage("No results found", color: .black)
                return 0
            }
            
        }else {
            
            if self.viewModel.dataModel.count > 0 {
                
                self.tableView.restore()
                return self.viewModel.dataModel.count
                
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
            
            let res = self.viewModel.searchData[indexPath.row]
            
            let actualUrl = res.poster
            
            if actualUrl != "" {
                
                cell.MovieImg.imageFromServerURL(actualUrl ?? "", placeHolder: UIImage(systemName: "wrongwaysign.fill"))
            }
            
            cell.titleLbl.text = res.title 
            cell.dateLbl.text = res.year
            
        }else {
            
            cell.favBtn.isHidden = false
            let res = self.viewModel.dataModel[indexPath.row]
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
                self.viewModel.fetchData()
                
            }else {
                
                self.status = "no"
                cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                self.result.removeObject(forKey: "status")
                self.result.set(self.status, forKey: "status")
                self.result.synchronize()
                self.viewModel.fetchData()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isSearch == false {
            
            if self.viewModel.dataModel.count > 0 {
                
                let res = self.viewModel.dataModel[indexPath.row]
                let VC = self.storyboard!.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
                VC.movieData = res
                self.present(VC, animated: true)
                
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if self.SearchTxt.text != "" {
            
            self.viewModel.searchMovies(movieName: self.SearchTxt.text ?? "")
            
        }else {
            
            self.isSearch = false
            self.viewModel.dataModel = []
            self.viewModel.dataModel.removeAll()
            //self.showAlert(title: "Warning", msg: "Please type a movie to search")
            self.viewModel.fetchData()
            
        }
    }
    
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                /// Indicator show
                print("Product loading....")
            case .stopLoading:
                // Indicator hide kardo
                print("Stop loading...")
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    // UI Main works well
                    
                    if self.isSearch == true {
                        
                        self.SearchTxt.resignFirstResponder()
                        self.tableView.reloadData()
                        
                    }else {
                        
                        self.tableView.reloadData()
                        
                    }
                }
            case .error(let error):
                print(error)
            }
        }
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
        
        if let searchTimer = searchTimer {
                searchTimer.invalidate()
            }
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.doSearch), userInfo: nil, repeats: false)
        
        if self.SearchTxt.text != "" {
            
            self.searchStat = "yes"
            self.searchBtn.setImage(UIImage(named: "Close"), for: .normal)
            
        }else {
            
            self.searchStat = "no"
            self.searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        }
    }
    
    @objc func doSearch() {
        
        self.searchTrailConstraint.constant = -50
        self.isSearch = true
        if SearchTxt.text != "" {
            
            let res = SearchTxt.text
            let ress = res?.lowercased()
            
            self.viewModel.searchMovies(movieName: ress ?? "")
            
        }else {
            
            self.isSearch = false
            self.searchStat = "yes"
            self.searchTrailConstraint.constant = 0
            self.viewModel.dataModel = []
            self.viewModel.dataModel.removeAll()
            self.viewModel.fetchData()
        }
    }
}
