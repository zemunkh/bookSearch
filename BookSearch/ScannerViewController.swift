//
//  ScannerViewController.swift
//  BookSearch
//
//  Created by Zorigbold  Munkh-Erdene on 27/05/2017.
//  Copyright © 2017 Zorigbold  Munkh-Erdene. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScannerDelegate {
    var barcode : String { get }
    func barcodeScanData(_: barcode)
}


class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var topbar: UIView!
    
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var barcodeFrameView: UIView?
    
    
    // I don't know exactly what is going on this protocol usage
    var delegate: ScannerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            //Initialize the captureSession object
            captureSession = AVCaptureSession()
            // set input device on capture session
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
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
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if Metaobjects array  is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            barcodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get metadata object
        
        let metadataObj  = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeEAN13Code {
            // if the found is equal to the Barcode metadata then update the status label
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            barcodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                
                if delegate != nil {
                    delegate?.barcodeScanData()
                }
                
            }
        }
    }

    
    
    

}
