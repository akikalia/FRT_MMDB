//
//  PageModel.swift
//  MMDB
//
//  Created by Alex kikalia on 08.05.21.
//

import UIKit
import CoreData

protocol PageModelDelegate: AnyObject{
    func pageModelDidFinishFetching(sender: PageModel, errorCode: PageModelError, dataSource: PageType)
}

class PageModel{
    //db service to fetch movies from CoreData
    var dbContext = DBManager.shared.persistentContainer.viewContext
    
    //api service to fetch movies from api
    var apiService = Service()
    
    private var group = DispatchGroup()
    
    // class used to store info on how many pages have been fetched and how many are out there
    private class PageInfo{
        var local: Int
        var global: Int
        init(local: Int, global: Int) {
            self.local = local
            self.global = global
        }
    }
    
    //used to store list of movies for each page type
    var data : [PageType:[MovieData]] = [.TopRated : [], .Favourite : [], .Popular : []]
    
    //storing info for each page
    private var sourceInfo: [PageType : PageInfo] = [.TopRated : .init(local: 0, global: 1), .Favourite : .init(local: 0, global: 0), .Popular : .init(local: 0, global: 0)]
    
    //current page
    var dataSource : PageType
    
    weak var delegate: PageModelDelegate?
    
    init(){
        dataSource = .TopRated
    }
    
    init(source: PageType){
        dataSource = source
    }
    
    
    //used to set current datasource, automatically fetches first page if it's not fetched yet
    func setDatasource(source: PageType){//, completion: @escaping (PageModelError) -> ()){
        if dataSource == source{
            delegate?.pageModelDidFinishFetching(sender: self, errorCode: .Success, dataSource: source)
        }else{
            dataSource = source
            guard let arr = data[source] else {
                delegate?.pageModelDidFinishFetching(sender: self, errorCode: .FailedToFetchData, dataSource: source)
                return
            }
            if arr.isEmpty || source == .Favourite{
                fetchMore()
            }else{
                delegate?.pageModelDidFinishFetching(sender: self, errorCode: .Success, dataSource: source)
            }
        }
    }
    
    //used to fetch additional pages from current datasource. Database pages are fetched as a single page and are not cached.
    func fetchMore(){
        let source = dataSource
        switch source {
        case .Favourite:
            let request = Movie.fetchRequest() as NSFetchRequest<Movie>
            do {
                data[.Favourite]? = []
                let movies = try dbContext.fetch(request)
                for movie in movies{
                    data[.Favourite]?.append(.init(movie: movie))
                }
            } catch {
                delegate?.pageModelDidFinishFetching(sender: self, errorCode: .FailedToFetchData, dataSource: source)
                return
            }
            delegate?.pageModelDidFinishFetching(sender: self, errorCode: .Success, dataSource: source)
        default:
            guard let info = sourceInfo[source], var arr = data[source], (info.local < info.global || info.global == 0)  else {
                self.delegate?.pageModelDidFinishFetching(sender: self, errorCode: .FailedToFetchData, dataSource: source)
                return
            }
            var apiType = APIType.TopRated
            if source == .Popular{
                apiType = .Popular
            }
            apiService.loadMovies(for: apiType, page: info.local + 1, completion: {[weak self] result in
                guard let self = self else{return}
                var errorCode = PageModelError.Success
                switch result{
                case .success(let movieList):
                    info.local = movieList.page
                    info.global = movieList.totalPages
                    for movieData in movieList.results{
                        let movie: MovieData = .init(movieEntry: movieData)
                        arr.append(movie)
                    }
                    self.data[source] = arr
                case .failure(_):
                    errorCode = PageModelError.FailedToFetchData
                }
                DispatchQueue.main.async {
                    self.delegate?.pageModelDidFinishFetching(sender: self, errorCode: errorCode, dataSource: source)
                }
            })
        }
    }
    
    //get movie at specified index, from current datasource.
    func getMovie(at index:Int) -> MovieData?{
        guard let source = data[dataSource] else {
            return nil
        }
        return source[index]
    }
    
    
    //get number of movies available locally for specified datasource
    func getSize() -> Int{
        guard let source = data[dataSource] else {
            return 0
        }
        return source.count
    }
    
    func getLocalPages() -> Int{
        guard let source = sourceInfo[dataSource] else {
            return 0
        }
        return source.local
    }
    
//    get specified datasource number of pages
    func getGlobalPages() -> Int{
        guard let source = sourceInfo[dataSource] else {
            return 0
        }
        return source.global
    }
}

enum PageModelError: String {
    case FailedToFetchData = "FailedToFetch"
    case Success = "success"
}


enum PageType: String {
    case TopRated = "Top Rated"
    case Popular = "Popular"
    case Favourite = "Favourite"
}

