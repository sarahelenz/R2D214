//
//  messageVC.swift
//  R2D214
//
//  Created by Niko on 3/2/21.
//  Copyright © 2021 user178354. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
class messageVC: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var sendButtnon: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([""])//will need to complete line with email address from firebase once available
            mail.setMessageBody("<p>\(field.text!)</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    @IBAction func sendAct(_ sender: Any) {
        sendEmail()//needs testing once emails added from firebase
    }    
}
