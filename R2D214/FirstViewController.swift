//
//  FirstViewController.swift
//  R2D214
//
//  Created by user178354 on 2/25/21.
//  Copyright © 2021 user178354. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let arrayOf = ArrayOf()
    
    let messageAlert = UIAlertController(title: "", message: "Is this the group you would like to send a message to?", preferredStyle: .alert)
    @IBOutlet weak var tableView1: UITableView!
    var check = 1
    var level = 0
    var tableViewCount = [1,2,3,4,5]
    var idnum: [String] = []
     var uniqueValues: [Int] = []
   
     var yearNumbers: [String] = []
    
    override func viewDidLoad() {
        loadDatabaseIDNums()
        tableView1.dataSource = self
        super.viewDidLoad()
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [unowned messageAlert] _ in
            let messageVCC = messageVC(nibName: "messageVC", bundle: nil)
            self.navigationController?.pushViewController(messageVCC, animated: true)
            
        }
        let noAction = UIAlertAction(title: "No", style: .default) { [unowned messageAlert] _ in
            return
        }
        messageAlert.addAction(yesAction)
        messageAlert.addAction(noAction)
        loadDatabaseIDNums()
         //       getYearNumbers()
    }
    func getData()
    {
        arrayOf.IDNumber = []
        arrayOf.counselor = []
        arrayOf.Email = []
        arrayOf.firstName = []
        arrayOf.lastName = []
        let reference = Database.database().reference()
        reference.observeSingleEvent(of: .value) { (snapshot) in
            let students : [String:Any] = ["First Name" : "", "Last Name" : "", "Counselor" : "", "Email" : ""]
            reference.child("r2d214-a33ff-default-rtdb").childByAutoId().setValue(students)
            reference.observeSingleEvent(of: .value) { (snapshot) in
                //     print (snapshot)
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    let IDNumber = data.key
                    let dictionary = data.value as! NSDictionary
                    let CounselorDictionary = dictionary["counselor"] as! String
                    let EmailDictionary = dictionary["E-mail"] as! String
                    let firstNameDictionary = dictionary["First Name"] as! String
                    let lastNameDictionary = dictionary["Last Name"] as! String
                    
                    self.idnum.append(contentsOf: self.arrayOf.IDNumber)
                    
                }
                self.tableView1.reloadData()
            }
        }
    }
    
    
//    func getYearNumbers(){
//        print("testyn")
//        var yearNumbers: [String] = []
//        print("yn",idnum)
//        for ids in idnum[0..<idnum.count]{
//
//
//        }
//        print(yearNumbers)
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // loadDatabaseIDNums()
       // getYearNumbers()
      
    //    let classTitles = ["Class of \(uniqueValues[0])", "Class of \(uniqueValues[1])", "Class of \(uniqueValues[2])", "Class of \(uniqueValues[3])", "Entire School"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
    //      cell.textLabel?.text = "\(classTitles[indexPath.row])"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(messageAlert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! FirstViewController
        nvc.level = 0
        
        
    }
    func loadDatabaseIDNums() {
        if check == 1 {
            idnum = []
            check = 2
        }
        let reference = Database.database().reference()
        reference.observeSingleEvent(of: .value) { [self] (snapshot) in
            for dataa in snapshot.children.allObjects as! [DataSnapshot] {
                let id = dataa.key
                if id.contains("6") {
                    if self.idnum.contains(id) {
                        
                    }
                    else {
                        self.idnum.append(id)
                        print("id: ",id)
                        print(self.idnum)
                        self.getYearNumbers()
                    }
                }
            }
        }
    }
    func getYearNumbers(){
          loadDatabaseIDNums()
       
          print(idnum)
          for ids in idnum[0..<idnum.count]{
            yearNumbers.append(String(ids[1...2]))
            var uniqueValues = Array(Set(yearNumbers))
            uniqueValues.sort()
            
            print(uniqueValues)
            print(uniqueValues.count)
        }
        
        
      }

}
