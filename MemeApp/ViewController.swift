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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
