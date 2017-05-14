//
//  ViewController.swift
//  ImageFilterDemo
//
//  Created by Alex Truong on 5/13/17.
//  Copyright © 2017 Alex Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var applyCaptionButton: UIButton!
    
    @IBOutlet weak var intensityLabel: UILabel!
    lazy var filterQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "FilterOperationQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let imagePicker = UIImagePickerController()
    var image: UIImage!
    var filteredImage: UIImage?
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openImagePicker(source: UIImagePickerControllerSourceType) {
        imagePicker.sourceType = source
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: source)!
        self.present(imagePicker, animated: true)
    }

    @IBAction func showActions(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = self.view
        
        let cameraAction = UIAlertAction(title: "Take picture", style: .default) { alert in
            self.openImagePicker(source: .camera)
        }
        
        let libraryAction = UIAlertAction(title: "Import from library", style: .default) { alert in
            self.openImagePicker(source: .photoLibrary)
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
    
    func startFilterAnimation() {
        activityIndicator.backgroundColor = UIColor.darkGray
        activityIndicator.layer.cornerRadius = 5.0
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = holderView.center
        activityIndicator.center.y = activityIndicator.center.y / 2
        holderView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopFilterAnimation() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

    @IBAction func intensityChanged(_ sender: UISlider) {
        intensityLabel.text = String(format: "%.1f", sender.value)
    }
    
    @IBAction func applyFilter(_ sender: UIBarButtonItem) {
        let filter = FilterOperation(inputImage: self.image, intensity: intensitySlider.value)
        filter.completionBlock = {
            DispatchQueue.main.async {
                self.stopFilterAnimation()
                self.applyCaptionButton.isEnabled = true
                self.filteredImage = filter.outputImage
                UIView.transition(with: self.imageView,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { self.imageView.image = filter.outputImage },
                                  completion: nil)
            }
        }
        
        filterQueue.addOperation(filter)
        
        startFilterAnimation()
        filterButton.isEnabled = false
        captionTextField.isEnabled = true
        captionTextField.becomeFirstResponder()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        picker.dismiss(animated: true) {
            UIView.transition(with: self.imageView,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { self.imageView.image = self.image },
                              completion: nil)
            self.captionTextField.isEnabled = false
            self.applyCaptionButton.isEnabled = false
        }

        filterButton.isEnabled = true
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? FilteredImageViewController {
            if let caption = captionTextField.text, !caption.isEmpty {
                controller.caption = caption
            } else {
                controller.caption = "EMPTY CAPTION"
            }
            controller.image = filteredImage
        }
    }
}
