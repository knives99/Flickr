//
//  FavoriteViewController.swift
//  FlickerDemo
//
//  Created by Knivesnine on 2021/9/30.
//

import UIKit
import RealmSwift
import Kingfisher

class FavoriteViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {


    @IBOutlet var collectionView: UICollectionView!
    let realm = FlickerStore.shared.realm
    lazy var photos = realm.objects(RealmData.self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        configureCellSize()
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FavoriteCollectionViewCell
        let url = URL(string: photos[indexPath.row].imageUrl)
        cell.image.kf.setImage(with: url)
        cell.text.text = photos[indexPath.row].title
        return cell
    }
    

}
