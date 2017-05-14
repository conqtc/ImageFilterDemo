//
//  FilterOperation.swift
//  ImageFilterDemo
//
//  Created by Alex Truong on 5/13/17.
//  Copyright © 2017 Alex Truong. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class FilterOperation: Operation {
    
    let inputImage: UIImage!
    let intensity: Float
    
    var outputImage: UIImage?
    
    init(inputImage: UIImage!, intensity: Float) {
        self.inputImage = inputImage
        self.intensity = intensity
    }
    
    func applyFilter() {
        
        if self.isCancelled {
            return
        }
        
        let context = CIContext()
        let ciImage = CIImage(data: UIImagePNGRepresentation(inputImage)!)
        let filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(intensity, forKey: kCIInputIntensityKey)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        if self.isCancelled {
            return
        }
        
        let result = filter.outputImage!
        if let cgImage = context.createCGImage(result, from: result.extent) {
            outputImage = UIImage(cgImage: cgImage)
        }
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        applyFilter()
    }
}
