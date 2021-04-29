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
    let arrayOf = ArrayOf()
    var numOfRows = 0
    var counter = 000001
    var check = 1
    var idsel = ""
    var IDNumber: [String] = []
    var firstNameDictionary: [String] = []
    var lastNameDictionary: [String] = []
    
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
            
            //            for i in self.counter...999999 {
            //                snapshot.childSnapshot(forPath: String(i))
            //                self.arrayOf.IDNumber.append(String(i))
            //                var secondID = snapshot.childSnapshot(forPath: "621092")
            //                var thirdID = snapshot.childSnapshot(forPath: "623182")
            //                self.counter += 000001
            //            }
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let ID = data.key
                if self.IDNumber.contains(ID) {
                    let dictionary = data.value as! NSDictionary
                    self.firstNameDictionary = [dictionary["First Name"] as! String]
                    self.lastNameDictionary = [dictionary["Last Name"] as! String]
                    
                }
                else {
                    self.IDNumber.append(ID)
                    print("id: ",ID)
                    print(self.IDNumber.count)
                    print(self.arrayOf.IDNumber)
                    let dictionary = data.value as! NSDictionary
                    
                    self.numOfRows = dictionary.count
                    
                    print(self.IDNumber)
//                    let CounselorDictionary = dictionary["counselor"] as! String
//                    let EmailDictionary = dictionary["E-mail"] as! String
                 //   self.firstNameDictionary = [dictionary["First Name"] as! String]
                 //   self.lastNameDictionary = [dictionary["Last Name"] as! String]
                }
                DispatchQueue.main.async {
                    self.tableView2.reloadData()
                    print(self.IDNumber.count)
                }
                
                //             self.numOfRows == dictionary.count
            }
        }
        
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView2.dataSource = self
        getData()
        
    }
    
    
    func loadDatabaseIDNums() {
        var check = 1
        if check == 1 {
            IDNumber = []
            check = 2
        }
        let reference = Database.database().reference()
        reference.observeSingleEvent(of: .value) { (snapshot) in
            for dataa in snapshot.children.allObjects as! [DataSnapshot] {
                let id = dataa.key
                if self.IDNumber.contains(id) {
                    
                }
                else {
                    self.IDNumber.append(id)
                    print("id: ",id)
                    print(self.IDNumber.count)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView2.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(numOfRows)
        return IDNumber.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        DispatchQueue.main.async {
            self.tableView2.reloadData()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = "\(IDNumber[indexPath.row])"
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! FirstViewController
        let classYears = nvc.finalYears
        let counselors = nvc.arrayOf.counselor
        //yearNumbers.append(contentsOf: classYears)
    }
}


