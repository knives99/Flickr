//
//  ViewController.swift
//  FlickerDemo
//
//  Created by Knivesnine on 2021/9/28.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    
    var text = "123"
    var page = ""
    var photos = [Photo]()
    @IBOutlet var textField: UITextField!
    @IBOutlet var perPageField: UITextField!
    @IBOutlet var btn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        self.perPageField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange),
                                  for: .editingChanged)
        perPageField.addTarget(self, action: #selector(textFieldDidChange),
                                  for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        if textField.text!.isEmpty || perPageField.text!.isEmpty{
                    btn.isEnabled = false
                    btn.backgroundColor = .red
        }else{
            btn.isEnabled = true
            btn.backgroundColor = .blue
        }
    }

    @IBAction func btnPressed(_ sender: Any) {
        guard  let text = textField.text else {return}
        guard let page = perPageField.text else {return}
        self.text = text
        self.page = page
        FlickerStore.shared.fetchData(text:self.text,page:self.page) { (SearchData) in
            self.photos = SearchData.photos.photo
            self.performSegue(withIdentifier: "go", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "go" {
            if let photoVC = segue.destination as? PhotoViewController {
                photoVC.photos = photos
                photoVC.text = text
                photoVC.page = page
            }
        }
    }
    


}

