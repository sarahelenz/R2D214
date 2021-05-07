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
import Firebase
import FirebaseDatabase
class messageVC: UIViewController, MFMailComposeViewControllerDelegate {
    var emails:[String] = []
    var check = 1
    var idnum:[String] = []
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var sendButtnon: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatabase()
    }
    func loadDatabase() {
        if check == 1 {
            emails = []
            check = 2
        }
        for i in idnum {
            let reference = Database.database().reference().child(String(i))
            reference.observeSingleEvent(of: .value) { [self] (snapshot) in
                    let emailDict = snapshot.value as! Dictionary<String,String>
                    let email = emailDict["E-mail"]!
                    self.emails.append(email)
                    print(self.emails)
                    }
        }
    }
    func sendEmail() {
        loadDatabase()
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            print("emailfunc",emails)
            mail.setToRecipients(emails)
            mail.setMessageBody("<p>\(field.text!)</p>", isHTML: true)
            mail.setSubject(subject.text ?? "Message from your Counselor")
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Message Failed", message: "Your device cannot send mail", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        switch result{
        case .cancelled:
            let alert = UIAlertController(title: "Message Not Sent", message: "You cancelled the message.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        case .saved:
            let alert = UIAlertController(title: "Message Not Sent", message: "You saved a draft.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        case .sent:
            let alert = UIAlertController(title: "Message Sent", message: "Your message is on the way!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        case .failed:
            let alert = UIAlertController(title: "Message Failed", message: "Your message failed to send", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)            
        @unknown default:
            return
        }
    }
    @IBAction func sendAct(_ sender: Any) {
            sendEmail()
    }
}
