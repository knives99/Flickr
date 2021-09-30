//
//  PhotoViewController.swiftPhotoCollectionViewController
//  FlickerDemo
//
//  Created by Knivesnine on 2021/9/28.
//

import UIKit
import Kingfisher
import RealmSwift

class PhotoViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    @IBOutlet var collectionView: UICollectionView!
    
    var photos = FlickerStore.shared.photos
    let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()


        collectionView.dataSource = self
        collectionView.delegate = self
        configureCellSize()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
    }
    @objc func refresh(_ sender: AnyObject) {
        if var number = Int(FlickerStore.shared.page) {
                       number = number + 2
                       FlickerStore.shared.page = String(number)
                       print(FlickerStore.shared.page)
                   }
        let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=5d79aba7f362c61e8becf3b54eb8af84&text=\(FlickerStore.shared.text)&per_page=\(FlickerStore.shared.page)&format=json&nojsoncallback=1"
        
        FlickerStore.shared.fetchData(url: url) { (data) in
            self.photos = data.photos.photo
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    func configureCellSize() {
            let itemSpace: CGFloat = 5
            let columnCount: CGFloat = 2

        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            let width = floor((view.frame.size.width - itemSpace * (columnCount-1)) / columnCount)
            flowLayout?.itemSize = CGSize(width: width, height: width)
            flowLayout?.estimatedItemSize = .zero
            flowLayout?.minimumInteritemSpacing = itemSpace
            flowLayout?.minimumLineSpacing = itemSpace
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
            }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        let url = photos[indexPath.row].imageUrl
        cell.image.kf.setImage(with: url)
//        FlickerStore.shared.fetchImage(url: url) { (data) in
//            DispatchQueue.main.async {
//                if let cell1 = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell{
//                    let image = UIImage(data:data)
//                    cell1.image.image = image
//                }
//
//            }
//        }
        cell.text.text = photos[indexPath.row].title
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(whichButtonPressed(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func whichButtonPressed(sender: UIButton) {
        var buttonNumber = sender.tag
        print(photos.count)
        print(buttonNumber)
        let photo = photos[buttonNumber]
        let realm = FlickerStore.shared.realm
        let favPhoto:RealmData = RealmData()
        favPhoto.farm = photo.farm
        favPhoto.id = photo.id
        favPhoto.title = photo.title
        favPhoto.server = photo.server
        favPhoto.secret = photo.server
        favPhoto.imageUrl =  photo.imageUrl.absoluteString
        
        
        try! realm.write{
            realm.add(favPhoto)
        }
//        print("fileURL: \(realm.configuration.fileURL!)")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset.y: \(scrollView.contentOffset.y)")
//        print("scrollView.frame.size.height: \(scrollView.frame.size.height)")
//        print("scrollView.contentSize.height: \(scrollView.contentSize.height)")
        if scrollView.contentOffset.y  >= (scrollView.contentSize.height - scrollView.frame.size.height * 1) {
            if var number = Int(FlickerStore.shared.page) {
                           number = number + 1
                           FlickerStore.shared.page = String(number) 
                       }
            let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=5d79aba7f362c61e8becf3b54eb8af84&text=\(FlickerStore.shared.text)&per_page=\(FlickerStore.shared.page)&format=json&nojsoncallback=1"
            
            FlickerStore.shared.fetchData(url: url) { (data) in
                self.photos = data.photos.photo
                print(self.photos.count)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

}
