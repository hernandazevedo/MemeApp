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
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    var meme = Meme()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2.0
    ]
    
    func configureTextField(_ textFieldName: UITextField,_ initialText: String) {
        textFieldName.delegate = self
        textFieldName.defaultTextAttributes = memeTextAttributes
        textFieldName.borderStyle = .none
        textFieldName.textAlignment = .center
        textFieldName.text = initialText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if textFieldBottom.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        configureTextField(textFieldTop, "TOP")
        configureTextField(textFieldBottom, "BOTTOM")
    }

    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage();
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.save(memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    func save(_ memedImage: UIImage) {
        // Cr_ meme
        self.meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    @IBAction func pickImage(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        changeToolbarAndNavigationBarVisibility(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        changeToolbarAndNavigationBarVisibility(false)
        return memedImage
    }
    
    func changeToolbarAndNavigationBarVisibility(_ isHidden: Bool) {
        navigationBar.isHidden = isHidden
        toolBar.isHidden = isHidden
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
