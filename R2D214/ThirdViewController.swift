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

class ThirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableview:UITableView!
    let counselorArr = ["Bialeschki","Bowen","Deppen","Galarza","Mo","Muck","Waller"]
    var counselorStudents = [[],[],[],[],[],[],[]]
    let messageAlert = UIAlertController(title: "", message: "Is this the group you would like to send a message to?", preferredStyle: .alert)
    var idnum:[String] = []
    let studentArr = [["IDNumber":"621006","Counselor":"Deppen","First Name":"Sam","Last Name":"Corley"]]
    var studentsToSend:[[String]] = [[],[],[],[],[],[],[]]
    var segue1 = UIStoryboardSegue.init(identifier: "toStudent", source: ThirdViewController(), destination: AllStudentsViewController())
    var segue2 = UIStoryboardSegue.init(identifier: "toMessageVC", source: ThirdViewController(), destination: messageVC())
    var selectedRow = 0
    var str1 = ""
    //data segued from Sarah's code, will need to be all students in a grade
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        // Do any additional setup after loading the view.
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [unowned messageAlert] _ in
            self.str1 = "yes"
            //let messageVCC = messageVC(nibName: "messageVC", bundle: nil)
            //self.navigationController?.pushViewController(messageVCC, animated: true)
            self.prepare(for: self.segue1, sender: self.messageAlert)
            self.performSegue(withIdentifier: "toStudent", sender: self.messageAlert)
        }
        let noAction = UIAlertAction(title: "No", style: .default) { [unowned messageAlert] _ in
            self.str1 = "no"
            self.prepare(for: self.segue2, sender: self.messageAlert)
            self.performSegue(withIdentifier: "toMessageVC", sender: self.messageAlert)
        }
        messageAlert.addAction(yesAction)
        messageAlert.addAction(noAction)
        
//        for student in studentArr{
//            let stuCounselor = student["Counselor"]
//            for x in 0...6{
//                if(counselorArr[x] == stuCounselor){
//                    counselorStudents[x].append(student)
//                    break
//                }
//            }
//
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        present(messageAlert, animated: true, completion: nil)
    }
    func sortByCounselor(){
        for student in studentArr{
            let stuCounselor = student["Counselor"]
            for x in 0...6{
                if(counselorArr[x] == stuCounselor){
                    counselorStudents[x].append(student)
                    studentsToSend[x].append(student["IDNumber"]!)
                    break
                }
            }
            
        }
    }
    func prepare(for segue: UIStoryboardSegue, sender: UIAlertController) {
        sortByCounselor()
        if segue.destination == ThirdViewController(){
            let nvc = segue.destination as! ThirdViewController
            let selectedStudents:[String] = self.studentsToSend[selectedRow]
            nvc.idnum = selectedStudents
        }
        else{
            let nvc = segue.destination as! messageVC
            let selectedStudents:[String] = self.studentsToSend[selectedRow]
            nvc.idnum = selectedStudents
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        cell.textLabel?.text = counselorArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}

