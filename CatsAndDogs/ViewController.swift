/******************
 * Copyright 2017-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License. A copy of the License is located at
 *
 *     http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
 * language governing permissions and limitations under the License.
 *
 * @author Ahmad R. Khan [ahmakhan@amazon.com] and Huy Huynh [huynhz@amazon.com]
 *
 * ViewController.swift
 * CatsAndDogs - Example iOS app used for re:Invent 2017 Workshop MCL311: Accelerating Apache MXNet
 * Models on Apple Platforms Using Core ML
 *
 ******************/

import CoreML
import Vision
import AVFoundation
import UIKit

enum Species {
    case Cat
    case Dog
}

class ViewController: UIViewController, FrameExtractorDelegate {
    
    var frameExtractor: FrameExtractor!
    var testImages: [String] = ["cat1", "cat2", "cat3", "dog1", "dog2", "dog3"]
    var randomPic: Int = 0
    var useTestCaptured: Bool = false
    var lag = 1
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var iSee: UILabel!
    
    
    @IBAction func buttonTapped(button: UIButton)
    {
        self.useTestCaptured = true
        self.randomPic = Int(arc4random_uniform(5))
        previewImage.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleWidth]
        previewImage.contentMode = .scaleAspectFit
        previewImage.clipsToBounds = true
        print("random pic: " + self.testImages[self.randomPic])
        let image = UIImage(named: self.testImages[self.randomPic])
        self.test_captured(image: image!)
    }
    
    @IBAction func cameraButtonTapped(button: UIButton)
    {
        self.useTestCaptured = false
    }
    
    var settingImage = false
    
    var currentImage: CIImage? {
        didSet {
            if let image = currentImage{
                self.detectScene(image: image)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
    }
    
    func captured(image: UIImage) {
        if !self.useTestCaptured {
            self.previewImage.image = image
            if let cgImage = image.cgImage, !settingImage {
                settingImage = true
                DispatchQueue.global(qos: .userInteractive).async {[unowned self] in
                    self.lag=1
                    self.currentImage = CIImage(cgImage: cgImage)
                }
            }
        }
    }
    
    func test_captured(image: UIImage) {
        self.previewImage.image = image
        if let cgImage = image.cgImage, !settingImage {
            settingImage = true
            DispatchQueue.global(qos: .userInteractive).async {[unowned self] in
                self.lag=0
                self.currentImage = CIImage(cgImage: cgImage)
            }
        }
    }
    
    func detectScene(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: coreml().model) else {
            fatalError()
        }
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { [unowned self] request, error in
            guard let results = request.results as? [VNCoreMLFeatureValueObservation],
                let _ = results.first
                else {
                    self.settingImage = false
                    return
            }
            //print((results.first?.featureValue.multiArrayValue?[0])!)
            DispatchQueue.main.async { [unowned self] in
                
                let mlresults = results.first?.featureValue.multiArrayValue
                if Double(mlresults![0].doubleValue) > 0.9 && Double(mlresults![1].doubleValue) < 0.7{
                    self.iSee.text = "I see a cat with confidence \(Double(mlresults![0].doubleValue))"
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.lag), execute: {
                        self.settingImage = false
                    })
                } else if Double(mlresults![1].doubleValue) > 0.9 && Double(mlresults![0].doubleValue) < 0.7{
                    self.iSee.text = "I see a dog with confidence \(Double(mlresults![1].doubleValue))"
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.lag), execute: {
                        self.settingImage = false
                    })
                } else {
                    self.iSee.text = "Not a dog nor a cat with confidence \(String(describing: mlresults))"
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(self.lag), execute: {
                        self.settingImage = false
                    })
                }
                
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

