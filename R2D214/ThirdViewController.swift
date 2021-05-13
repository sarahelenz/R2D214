//
//  ThirdViewController.swift
//  R2D214
//
//  Created by Samantha Corley on 3/12/21.
//  Copyright © 2021 user178354. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class ThirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableview:UITableView!
    let counselorArr = ["Bialeschki","Bowen","Deppen","Galarza","Mo","Muck","Waller"]
    var counselorStudents = [[],[],[],[],[],[],[]]
    let messageAlert = UIAlertController(title: "", message: "Is this the group you would like to send a message to?", preferredStyle: .alert)
    var idnum:[String] = []
    var studentArr:[String:String] = [:]
    var studentsToSend:[[String]] = [[],[],[],[],[],[],[]]
    var selectedRow = 0
    var str1 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableview.delegate = self
        tableview.dataSource = self
        
        // Do any additional setup after loading the view.
        let yesAction = UIAlertAction(title: "Yes", style: .default) {  _ in
           
            let message = self.storyboard!.instantiateViewController(identifier: "messageVC") as! messageVC
            if(self.studentsToSend[self.selectedRow].isEmpty){
                self.sortByCounselor()
            }
            message.idnum = self.studentsToSend[self.selectedRow]
            self.present(message, animated:true, completion: nil)
            
        }
        let noAction = UIAlertAction(title: "No", style: .default) {  _ in
            
            let allStudents = self.storyboard!.instantiateViewController(identifier: "AllStudentsViewController") as! AllStudentsViewController
            if(self.studentsToSend[self.selectedRow].isEmpty){
                self.sortByCounselor()
            }
            allStudents.idnum = self.studentsToSend[self.selectedRow]
            self.present(allStudents, animated:true, completion: nil)
        }
        messageAlert.addAction(yesAction)
        messageAlert.addAction(noAction)
    }
    
    //function handles row selection and presents the messageAlert so the user can decide whether to send the message to that group or not
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        present(messageAlert, animated: true, completion: nil)
    }
    
    //function pulls down counselors for each ID number from Firebase and creates a dictionary with ID numbers as the keys and counselor names as the values
    func getData(){
        for i in idnum {
            let reference = Database.database().reference().child(String(i))
            reference.observeSingleEvent(of: .value) { [self] (snapshot) in
                let counselorDict = snapshot.value as! Dictionary<String, String>
                let counselor = counselorDict["Counselor"]!
                studentArr[i] = counselor
            }
        }
        
    }
    
    //function sorts ID numbers by what counselor they have and creates student arrays for each counselor
    func sortByCounselor(){
        for (id,counselor) in studentArr{
            let stuCounselor = counselor
            for x in 0...6{
                if(counselorArr[x] == stuCounselor){
                    counselorStudents[x].append(id)
                    studentsToSend[x].append(id)
                    break
                }
            }
            
        }
    }

    //function puts values of counselor names into TableView rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        cell.textLabel?.text = counselorArr[indexPath.row]
        return cell
    }
    
    //function defines number of rows in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}

