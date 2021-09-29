//
//  ViewController.swift
//  FlickerDemo
//
//  Created by Knivesnine on 2021/9/28.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    
    var searchText = "123"
    var perPages = ""
    @IBOutlet var textField: UITextField!
    @IBOutlet var perPageField: UITextField!
    @IBOutlet var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        self.perPageField.delegate = self
    }
    

    @IBAction func btnPressed(_ sender: Any) {
        if textField.text!.isEmpty || perPageField.text!.isEmpty{
            btn.isEnabled = false
            btn.backgroundColor = .red
            }else{
            
            btn.backgroundColor = .blue
            guard  let text = textField.text else {return}
            guard let page = perPageField.text else {return}
            FlickerStore.shared.text = text
            FlickerStore.shared.page = page
            let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=5d79aba7f362c61e8becf3b54eb8af84&text=\(FlickerStore.shared.text)&per_page=\(FlickerStore.shared.page)&format=json&nojsoncallback=1"

            FlickerStore.shared.fetchData(url: url) { (SearchData) in
                FlickerStore.shared.photos = SearchData.photos.photo
                self.performSegue(withIdentifier: "go", sender: self)
            }
        }
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        btn.isEnabled = true
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        btn.isEnabled = true
        perPageField.resignFirstResponder()
        textField.resignFirstResponder()
     }
    


}

