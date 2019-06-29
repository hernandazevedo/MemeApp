//
//  ViewController.swift
//  MemeApp
//
//  Created by Hernand Azevedo on 23/06/19.
//  Copyright © 2019 Hernand Azevedo. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: ImagePicker!
    
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2.0
    ]
    fileprivate func configureTextFields() {
        self.textFieldTop.delegate = self
        self.textFieldTop.defaultTextAttributes = memeTextAttributes
        self.textFieldTop.borderStyle = .none
        self.textFieldBottom.delegate = self
        self.textFieldBottom.defaultTextAttributes = memeTextAttributes
        self.textFieldBottom.borderStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        configureTextFields()
    }

    @IBAction func pickImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
}

extension ViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
