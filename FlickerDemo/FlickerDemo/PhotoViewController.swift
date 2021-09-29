//
//  PhotoViewController.swiftPhotoCollectionViewController
//  FlickerDemo
//
//  Created by Knivesnine on 2021/9/28.
//

import UIKit

class PhotoViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    @IBOutlet var collectionView: UICollectionView!
    
    var photos = FlickerStore.shared.photos
    let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 1
//        layout.minimumInteritemSpacing = 1
//        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.height/2)
//        collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)

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

//
//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photos.count)
        return photos.count
            }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        let url = photos[indexPath.row].imageUrl
        FlickerStore.shared.fetchImage(url: url) { (data) in
            DispatchQueue.main.async {
                let image = UIImage(data:data)
                cell.image.image = image
            }
        }
        cell.text.text = photos[indexPath.row].title
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.y: \(scrollView.contentOffset.y)")
        print("scrollView.frame.size.height: \(scrollView.frame.size.height)")
        print("scrollView.contentSize.height: \(scrollView.contentSize.height)")

        // 當 scrollView 的 contentOffset 的 y 座標 + scrollView.frame 的高「大於等於」scrollView 的 contentView 的承載量時，表示快滾到最後一筆了，此時即可開始載入資料
        if scrollView.contentOffset.y  >= (scrollView.contentSize.height - scrollView.frame.size.height * 1) {
            if var number = Int(FlickerStore.shared.page) {
                           number = number + 10
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
    }

}
