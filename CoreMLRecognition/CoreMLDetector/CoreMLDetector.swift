//
//  CoreMLDetector.swift
//  CoreMLRecognition
//
//  Created by Kim SAVAROCHE on 27/07/2017.
//  Copyright © 2017 Kim SAVAROCHE. All rights reserved.
//

import Foundation
import CoreML
import Vision

protocol CoreMLDetectorDelegate: class {
    func found(output: String)
}

class CoreMLDetector {
    var model:VNCoreMLModel!
    weak var delegate: CoreMLDetectorDelegate?
    
    init(model: MLModel) {
        do {
            self.model = try VNCoreMLModel(for: SqueezeNet().model)
        } catch {
            print("Can not load Core ML model")
        }
        
    }
    
    func detect(image: CIImage) {
        let request = VNCoreMLRequest(model: self.model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("Unexpected result type from VNCoreMLRequest")
            }
            
            DispatchQueue.main.async { [weak self] in
                let outputText = "It might be a \(topResult.identifier) (\(Int(topResult.confidence * 100))%)"
                self?.delegate?.found(output: outputText)
            }
        }
        
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
