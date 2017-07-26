//
//  ViewController.swift
//  CoreMLRecognition
//
//  Created by Kim SAVAROCHE on 23/07/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreImage
import AVFoundation
import CoreML
import Vision

//class ViewController: UIViewController, FrameExtractorDelegate {
class ViewController: UIViewController {
    func detectScene(image: CIImage) {
        imageCaption.text = "detecting scene..."
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else {
            fatalError("can't load Places ML model")
        }
        
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            // Update UI on main queue
            // let article = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"
            DispatchQueue.main.async { [weak self] in
                self?.imageCaption.text = "\(Int(topResult.confidence * 100))% it's a \(topResult.identifier)"
            }
        }
        
        // Run the Core ML GoogLeNetPlaces classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    
    
/*
     // MARK: Object Model
     //let objectModel = SqueezeNet()
     
    // MARK: Update Caption
    func caption(image:CVPixelBuffer) throws -> String {
        let predictionOutput = try self.objectModel.prediction(image: image)
        return "\(predictionOutput.classLabel)"
        
        //let element = predictionOutput.classLabelProbs.max { a, b in a.value < b.value }
        //return "\(element)"
    }
    
    //MARK: Delegat camera function
    func captured(image: UIImage) {
        // let newSize = CGSize(width: CGFloat(227), height: CGFloat(227))
        let newSize = CGSize(width: CGFloat(224), height: CGFloat(224))
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int((newImage?.size.width)!), Int((newImage?.size.height)!), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return print("Pixel buffer error");
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        
        
        var captionTxt = "???"
        
        do {
            captionTxt = try caption(image: pixelBuffer!)
        } catch {
            captionTxt = "error"
        }
        
        imageCaption.text = captionTxt
        // imageView.image = newImage
    }
 */
    
    // MARK: Setup App
    func setupApp() {
        //frameExtractor = FrameExtractor()
        //frameExtractor.delegate = self
        
        //captured(image: imageView.image!)
        
        
        let ciImage = CIImage(image: imageView.image!)
        detectScene(image: ciImage!)
    }
    
    // MARK: Properties
    var image:UIImage?
    var frameExtractor: FrameExtractor!
    
    // MARK: Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageCaption: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupApp()
    }
}

