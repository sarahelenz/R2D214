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
    var idnum:[Int] = [621006,621092,623182] //need to set equal to id numbers recieved from previous view controller
    @IBOutlet weak var field: UITextField!
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
                for dataa in snapshot.children.allObjects as! [DataSnapshot] {
                    let email = dataa.value as! String
                    print(email)
                    if email.contains("d214") {
                        self.emails.append(email)
                        print(self.emails)
                    }
                }
            }
        }
        print("emails: ",emails.count,emails)
    }
    func sendEmail() {
        loadDatabase()
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            print("emailfunc",emails)
            mail.setToRecipients(emails)
            mail.setMessageBody("<p>\(field.text!)</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            return
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    @IBAction func sendAct(_ sender: Any) {
        sendEmail()
    }
}
