//
//  ScannerViewController.swift
//  BookSearch
//
//  Created by Zorigbold  Munkh-Erdene on 27/05/2017.
//  Copyright © 2017 Zorigbold  Munkh-Erdene. All rights reserved.
//

import UIKit
import AVFoundation


protocol ScannerViewControllerDelegate: class {
    
    func sendISBN(isbn: String?)
    
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //Protocol part: Delegate declaration
    weak var delegate: ScannerViewControllerDelegate?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var topbar: UIView!
    
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var barcodeFrameView: UIView?
    
    var isbnData: String? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            //Initialize the captureSession object
            captureSession = AVCaptureSession()
            // set input device on capture session
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            //Start video capture
            captureSession?.startRunning()
            
            
            //Initialize QR Code Frame to highlight the QR code
            barcodeFrameView = UIView()
            if let barcodeFrameView = barcodeFrameView {
                barcodeFrameView.layer.borderColor = UIColor.green.cgColor
                barcodeFrameView.layer.borderWidth = 2
                view.addSubview(barcodeFrameView)
                view.bringSubview(toFront: barcodeFrameView)
            }
            
            
            
        } catch {
            print(error)
            return
        }
        
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: topbar)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func metadataOutput(captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if Metaobjects array  is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            barcodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No ISBN is detected"
            return
        }
        
        // Get metadata object
        
        let metadataObj  = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.ean13 {
            // if the found is equal to the Barcode metadata then update the status label
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            barcodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                isbnData = messageLabel.text
                delegate?.sendISBN(isbn: isbnData)
                print("#######READ ISBN######")
                navigationController?.popViewController(animated: true)
            }
        }
    }

    

}
