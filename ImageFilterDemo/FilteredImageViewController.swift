//
//  FilteredImageViewController.swift
//  ImageFilterDemo
//
//  Created by Alex Truong on 5/13/17.
//  Copyright © 2017 Alex Truong. All rights reserved.
//

import UIKit

class FilteredImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            if imageView != nil {
                imageView.image = image
            }
        }
    }
    
    var caption: String? {
        didSet {
            if captionButton != nil {
                captionButton.setTitle(caption, for: .normal)
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        captionButton.setTitle(caption, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func captionDismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
