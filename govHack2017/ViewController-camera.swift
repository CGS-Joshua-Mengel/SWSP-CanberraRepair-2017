//
//  ViewController-camera.swift
//  govHack2017
//
//  Created by Joshua Mengel on 29/7/17.
//  Copyright © 2017 Joshua Mengel. All rights reserved.
//

import UIKit
import MessageUI
import Photos
import MapKit

class ViewController_camera: UIViewController, MFMailComposeViewControllerDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickedImaged: UIImageView!
    
    var userLocation : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timer: Timer!
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {_ in
            self.cameraButtonAction(nil)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cameraButtonAction(_ sender: UIButton?) {
        print("working?")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
            //RARE
            
            let mailComposeViewController = configureMailController()
            
            if MFMailComposeViewController.canSendMail() {
                
                self.present(mailComposeViewController, animated: true, completion: nil)
                
            } else {
                
                showReportError()
                
            }
        }
    }
    
    
    
    
    func sendEmail() {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showReportError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        
        let reportEmailVC = MFMailComposeViewController()
        reportEmailVC.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
        reportEmailVC.setToRecipients(["canberrarepair@gmail.com"])
        reportEmailVC.setSubject("Report Email")
        reportEmailVC.setMessageBody("Damage has been reported at \(String(describing: String(userLocation))) \n \n Any additional details?", isHTML: false)
        
        return reportEmailVC
        
    }
    
    func showReportError() {
        
        let sendMailErrorAlert = UIAlertController(title: "Could not send mail", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func photoLibraryAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        let imageData = UIImageJPEGRepresentation(pickedImaged.image!, 0.5)
        //let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.5)
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        
        sendEmail()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        pickedImaged.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
}


    //Rare
    

