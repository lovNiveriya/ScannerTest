//
//  ViewController.swift
//  ScannerTest
//
//  Created by lov niveriya on 19/07/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate{
    
@IBOutlet weak var ImageView: UIImageView!
    
    //session
    let session = AVCaptureSession()
  
    
    //preview layer
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // define capture type
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            
           if let SafecaptureDevice = captureDevice
           {
            let input  = try AVCaptureDeviceInput(device: SafecaptureDevice)
            session.addInput(input)
           }
           else{
            print("error wile setuping input")
           }
            
        }
        catch{
            print(error.localizedDescription)
        }
        
        let outPut = AVCaptureMetadataOutput()
        session.addOutput(outPut)
        outPut.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        outPut.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        ImageView.layer.borderWidth = 4
        ImageView.layer.borderColor = UIColor.brown.cgColor
        self.view.bringSubviewToFront(ImageView)
        session.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        session.stopRunning()
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first{
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject
            else {
                return
            }
            print("readableObject:\(readableObject.stringValue!)")
            session.stopRunning()
        }
    }

}

