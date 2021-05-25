//
//  SecondViewController.swift
//  R2D214
//
//  Created by user178354 on 2/25/21.
//  Copyright © 2021 user178354. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView2: UITableView!
    let messageAlert = UIAlertController(title: "", message: "Is this the group you would like to send a message to?", preferredStyle: .alert)
    let arrayOf = ArrayOf()
    var numOfRows = 0
    var counter = 000001
    var check = 1
    var idsel = ""
    var IDNumber: [String] = []
    var firstNameDictionary: [String] = []
    var lastNameDictionary: [String] = []
     var selectedRow:Int = 0
    
    public func getData(){
        
        arrayOf.IDNumber = []
        arrayOf.counselor = []
        arrayOf.Email = []
        arrayOf.firstName = []
        arrayOf.lastName = []
        
        var check = 1
        if check == 1 {
            IDNumber = []
            check = 2
        }
        
        let reference = Database.database().reference()
        print(reference)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let ID = data.key
                if self.IDNumber.contains(ID) {
                    //     let dictionary = data.value as! NSDictionary
                }
                else {
                    self.IDNumber.append(ID)
                    print("id: ",ID)
                    print(self.IDNumber.count)
                    print(self.arrayOf.IDNumber)
                    
                    print(self.IDNumber)
                    
                    let dictionary = data.value as! NSDictionary
                    let firstName = dictionary["First Name"] as! String
                    let lastName = dictionary["Last Name"] as! String
                    self.firstNameDictionary.append(firstName)
                    self.lastNameDictionary.append(lastName)
                }
                DispatchQueue.main.async {
                    self.tableView2.reloadData()
                    
                    print(self.firstNameDictionary)
                    print(self.IDNumber.count)
                    
                }
                
            }
        }
        
    }
      override func viewDidLoad() {
            tableView2.allowsSelection = true
            tableView2.allowsSelectionDuringEditing = true
            getData()
            tableView2.dataSource = self
            tableView2.delegate = self
            super.viewDidLoad()
        
                   let yesAction = UIAlertAction(title: "Yes", style: .default) {  _ in
                       let message = self.storyboard!.instantiateViewController(identifier: "messageVC") as! messageVC
                           message.idnum = self.IDNumber
                       }
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
        let thirdvc = self.storyboard!.instantiateViewController(identifier: "thirdvc") as! ThirdViewController
        if self.selectedRow != 4 && self.IDNumber[self.selectedRow].isEmpty {
        }
        }
            
        messageAlert.addAction(yesAction)
               messageAlert.addAction(noAction)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let indexPath = tableView2.indexPathForSelectedRow!
           selectedRow = indexPath.row
           present(messageAlert, animated: true, completion: nil)
       }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView2.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstNameDictionary.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        DispatchQueue.main.async {
            self.tableView2.reloadData()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = "\(firstNameDictionary[indexPath.row])"
        cell.detailTextLabel?.text = "\(lastNameDictionary[indexPath.row])"
        return cell
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let nvc = segue.destination as! FirstViewController
//        let classYears = nvc.finalYears
//        let counselors = nvc.arrayOf.counselor
//        //yearNumbers.append(contentsOf: classYears)
//    }
}

