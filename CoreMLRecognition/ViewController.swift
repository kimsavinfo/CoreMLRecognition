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

class ViewController: UIViewController, FrameExtractorDelegate {
    // MARK: Object Model
    //let objectModel = SqueezeNet()
    
    // MARK: Update Caption
    func caption(image:CVPixelBuffer) throws -> String {
        /*
        let prediction = try self.objectModel.prediction(image: image)
        let predictionInfo = "\(prediction.classLabel)  (\(prediction.classLabelProbs) )"
        return predictionInfo
         */
        
        return "???"
    }
    
    //MARK: Delegat camera function
    func captured(image: UIImage) {
        imageView.image = image
    }
    
    func getImageBuffer(imageBuffer: CVPixelBuffer) {
        var captionTxt = "???"
        
        do {
            captionTxt = try caption(image: imageBuffer)
        } catch {
            captionTxt = "???"
        }
        
        imageCaption.text = captionTxt
    }
    
    // MARK: Setup App
    func setupApp() {
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
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

