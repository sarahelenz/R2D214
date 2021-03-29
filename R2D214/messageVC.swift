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
            let alert = UIAlertController(title: "Message Failed", message: "Your device cannot send mail", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    //function below needs to be tested -- have not set it up to run within the app
    func sendEmailToClass(year:Int) {
        loadDatabase()
        let emailArr = sortEmailsByYear(year: year)
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            print("emailfunc",emailArr)
            mail.setToRecipients(emailArr)
            mail.setMessageBody("<p>\(field.text!)</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Message Failed", message: "Your device cannot send mail", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    //function below needs to be tested -- have not set it up to run within the app
    func sortEmailsByYear(year:Int) -> Array<String> {
        let yearNumbers = ["21","22","23","24"] //replace with year number array
        var yearIds:[String] = []
        var emailsyear:[String] = []
        for id in idnum {
            if String(id)[1...2] == yearNumbers[year] {
                yearIds.append(String(id))
            }
        }
        for id1 in yearIds{
            let reference = Database.database().reference().child(String(id1))
            reference.observeSingleEvent(of: .value) { (snapshot) in
                for dataa in snapshot.children.allObjects as! [DataSnapshot] {
                    let email = dataa.value as! String
                    print(email)
                    if email.contains("d214") {
                        emailsyear.append(email)
                        print(emailsyear)
                    }
                }
            }
        }
        return emailsyear
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
        }
    }
    @IBAction func sendAct(_ sender: Any) {
        sendEmail()
    }
}
