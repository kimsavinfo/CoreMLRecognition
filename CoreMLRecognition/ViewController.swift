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

class ViewController: UIViewController, FrameExtractorDelegate, CoreMLDetectorDelegate{
    // MARK: Properties
    var image:UIImage?
    var frameExtractor: FrameExtractor!
    var objectDetector: CoreMLDetector!
    
    // MARK: Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageCaption: UITextField!
    
    // MARK: Setup App
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupApp()
    }
    
    func setupApp() {
        self.frameExtractor = FrameExtractor()
        self.frameExtractor.delegate = self
        
        self.objectDetector = CoreMLDetector(model: SqueezeNet().model)
        self.objectDetector.delegate = self
    }
    
    // MARK: Delegate - FrameExtractor
    func captured(image: UIImage) {
        self.imageView.image = image
        
        self.objectDetector.detect(image: CIImage(image: image)!)
    }
    
    // MARK: Delegate - FrameExtractor
    func found(output: String) {
        self.imageCaption.text = output
    }
}

