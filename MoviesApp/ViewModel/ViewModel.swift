//
//  ViewModel.swift
//  MoviesApp
//
//  Created by Ambarish Shivakumar on 24/09/24.
//

import Foundation

class ViewModel {
    
    var dataModel: [MovieInfo] = []
    var searchData: [Search] = []
    
    //var products: [Product] = []
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    //guard let url = moviesFetchEndPoint else { return }
    
    let movieBase = URL(string: moviesFetchEndPoint)
    
    func fetchData() {
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: MovieInfo.self, url: movieBase) { response in
            
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let products):
                
                let rr = response.map { res in
                    
                    self.dataModel.append(res)
                }
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
    
    func searchMovies(movieName: String) {
        
        let finalUrl = "&s=\(movieName)"
        
        let movieURL = URL(string: SearchResEndPoint+finalUrl)
        
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: SearchInfo.self, url: movieURL) { response in
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let resultss):
                
                print(resultss)
                
                let rr = response.map { res in
                    
                    let newArr = res.search?.sorted { $0.year ?? "" > $1.year ?? "" }
                    self.searchData = newArr ?? []
                }
                
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
}

extension ViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
       // case newProductAdded(product: AddProduct)
    }

}
