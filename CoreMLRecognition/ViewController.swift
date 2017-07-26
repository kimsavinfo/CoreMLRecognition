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

class ViewController: UIViewController, FrameExtractorDelegate{
    // MARK: Properties
    var image:UIImage?
    var frameExtractor: FrameExtractor!
    
    // MARK: Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageCaption: UITextField!
    
    // MARK: Setup App
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupApp()
    }
    
    func setupApp() {
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
    }
    
    // MARK: Delegate - FrameExtractor
    func captured(image: UIImage) {
        self.imageView.image = image
        
        detectScene(image: CIImage(image: image)!)
    }
    
    func detectScene(image: CIImage) {
        imageCaption.text = "detecting scene..."
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else {
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
                self?.imageCaption.text = "it's a \(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
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
}

