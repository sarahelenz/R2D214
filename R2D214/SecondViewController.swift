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
                    var firstName = dictionary["First Name"] as! String
                    var lastName = dictionary["Last Name"] as! String
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
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView2.dataSource = self
        getData()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView2.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(numOfRows)
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
}
