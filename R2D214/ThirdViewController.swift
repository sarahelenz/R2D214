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
    let studentArr = [["IDNumber":"621006","Counselor":"Deppen","First Name":"Sam","Last Name":"Corley"]]
    var studentsToSend:[[String]] = [[],[],[],[],[],[],[]]
    //data segued from Sarah's code, will need to be all students in a grade
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // Do any additional setup after loading the view.
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [unowned messageAlert] _ in
            let messageVCC = messageVC(nibName: "messageVC", bundle: nil)
            self.navigationController?.pushViewController(messageVCC, animated: true)
            
        }
        let noAction = UIAlertAction(title: "No", style: .default) { [unowned messageAlert] _ in
            return
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
    func prepare(for segue: UIStoryboardSegue, sender: UITableViewCell) {
        sortByCounselor()
        let indexPath = tableview.indexPathForSelectedRow
        let selectedRow = indexPath?.row
        let nvc = segue.destination as! messageVC
        let selectedStudents:[String] = self.studentsToSend[selectedRow!]
        nvc.idnum = selectedStudents
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

