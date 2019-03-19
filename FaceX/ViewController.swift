//
//  ViewController.swift
//  FaceX
//
//  Created by Yash Nayak on 19/03/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//


import UIKit
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var previewImg: UIImageView!
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    let mlModel = Friends()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importButton.addTarget(self, action: #selector(importFromCameraRoll), for: .touchUpInside)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func importFromCameraRoll() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            previewImg.image = image
            // checking image with mlmodel
            if let buffer = image.buffer(with: CGSize(width:224, height:224)) {
                guard let prediction = try? mlModel.prediction(image: buffer) else {fatalError("Unexpected runtime error")}
                descriptionLbl.text = prediction.classLabel
                print(prediction.classLabelProbs)
            }else{
                print("failed buffer")
            }
        }
        dismiss(animated:true, completion: nil)
    }
    
}
