//
//  ViewController-report.swift
//  govHack2017
//
//  Created by Joshua Mengel on 28/7/17.
//  Copyright © 2017 Joshua Mengel. All rights reserved.
//

import UIKit
import MessageUI

class ViewController_report: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        let mailComposeViewController = configureMailController()
        
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
            
        } else {
            
            showReportError()
            
        }
        
    }
    
    func configureMailController() -> MFMailComposeViewController {
        
        let reportEmailVC = MFMailComposeViewController()
        reportEmailVC.mailComposeDelegate = self
        reportEmailVC.setToRecipients(["edanreynolds@gmail.com"])
        reportEmailVC.setSubject("Report Email")
        reportEmailVC.setMessageBody("Test", isHTML: false)
        
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
    
}
