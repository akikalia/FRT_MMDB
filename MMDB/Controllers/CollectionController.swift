//
//  CollectionController.swift
//  MMDB
//
//  Created by Alex kikalia on 07.05.21.
//

import UIKit
import CoreData
import SDWebImage


class CollectionController: UIViewController{
    
    
    var dbContext = DBManager.shared.persistentContainer.viewContext
//    var currentPage : pageType need to get using tab bar or something
    var pageModel = PageModel()

    @IBOutlet var loader: UIActivityIndicatorView!
    
    @IBOutlet var segments : UISegmentedControl!
    
    @IBOutlet var collectionView : UICollectionView!
    
    @IBOutlet var errorView: ErrorView!
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            UINib(nibName: "MovieCell", bundle: nil),
            forCellWithReuseIdentifier: "MovieCell"
        )
        segments.removeAllSegments()
        segments.insertSegment(withTitle: PageType.TopRated.rawValue, at: 0, animated: false)
        segments.insertSegment(withTitle: PageType.Popular.rawValue, at: 1, animated: false)
        segments.insertSegment(withTitle: PageType.Favourite.rawValue, at: 2, animated: false)
        segments.selectedSegmentIndex = 0
        view.bringSubviewToFront(segments)
        view.bringSubviewToFront(loader)
//        segments.tintColor = 
        loader.startAnimating()
        collectionView.isHidden = true
        pageModel.fetchMore()
    }
    
    //if segment control value changes, we need to fetch new page data from PageMeodel
    @IBAction func onChange(_ sender: UISegmentedControl) {
        guard let pageType = sender.titleForSegment(at: sender.selectedSegmentIndex)else {
            return
        }
        if let type = PageType(rawValue: pageType){
            loader.startAnimating()
            collectionView.isHidden = true
            pageModel.setDatasource(source: type)
        }
    }
}


extension CollectionController: ErrorViewDelegate{
    func errorViewButtonTap(sender: ErrorView) {
        errorView.isHidden = true
        loader.startAnimating()
        pageModel.fetchMore()
    }
}

//PageModel notifies us fetching job completion using delegate
extension CollectionController: PageModelDelegate{
    func pageModelDidFinishFetching(sender: PageModel, errorCode: PageModelError, dataSource: PageType) {
        loader.stopAnimating()
        if dataSource.rawValue == segments.titleForSegment(at: segments.selectedSegmentIndex) && errorCode == .Success{
            collectionView.isHidden = false
            collectionView.reloadData()
        }else{
            errorView.isHidden = false
        }
    }
}



extension CollectionController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageModel.getSize()
    }
    
    // passing down image data to current cell. images are fetched using 3'rd party library SDWebImage
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath)
        if let cellEdit: MovieCell = cell as? MovieCell{
            cellEdit.delegate = self
            let movie = pageModel.getMovie(at: indexPath.row)
            cellEdit.index = indexPath.row
            if let movie = movie{
                cellEdit.poster.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/" + movie.poster ), placeholderImage: UIImage(named: movie.title))
            }
        }
        return cell
    }
    
}

//on tap navigate to DetailedViewController using Navigation Controllers PushVC method / tapped cell's movie data passed along...
extension CollectionController: MovieCellDelegate{
    func movieCellDelegateLongPress(_ sender: MovieCell, index: Int) {
        
    }
    
    func movieCellDelegateTap(_ sender: MovieCell, index: Int) {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailedVC = mainStoryboard.instantiateViewController(withIdentifier: "detailedVC") as? DetailedViewController{
                guard let movie = pageModel.getMovie(at: index) else {
                    return
                }
                detailedVC.movie = movie
                navigationController?.pushViewController(detailedVC, animated: true)
            }
            
    }
}


// custom layout configuration code
extension CollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.Insets.top, left: Constants.Insets.left, bottom: Constants.Insets.bottom, right: Constants.Insets.right)
    }
    

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.spacingX
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.spacingY
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath ) -> CGSize {

        var width = CGFloat.init(125)
        
        if collectionView.frame.width <= 428{
            let innerWidth = collectionView.frame.width - Constants.Insets.left - Constants.Insets.right
           width = (innerWidth - (Constants.numCols-1) * Constants.spacingX) / Constants.numCols
        }
        
        return CGSize(width: width - 1, height: 1.44 * width)
    }
    
}

//constants used to modify collection view flow layout
extension CollectionController {
    struct Constants {
        static let numCols : CGFloat = 3
        static let spacingX: CGFloat = 12
        static let spacingY: CGFloat = 20
        struct Insets {
            static let top : CGFloat = 45
            static let bottom : CGFloat = 12
            static let left : CGFloat = 12
            static let right : CGFloat = 12
        }
    }
}




