//
//  SecondViewController.swift
//  R2D214
//
//  Created by user178354 on 2/25/21.
//  Copyright © 2021 user178354. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController:UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    let arrayOf = ArrayOf()
    var counter = 000001
    var check = 1
    var IDNumber: [String] = []
    override func viewDidLoad(){
        super.viewDidLoad()
        getData()
    }
            public func getData()
            {
                arrayOf.IDNumber = []
                arrayOf.counselor = []
                arrayOf.Email = []
                arrayOf.firstName = []
                arrayOf.lastName = []
                
                let reference = Database.database().reference()
                print(reference)
                
                reference.observeSingleEvent(of: .value) { (snapshot) in
//
//                    for i in self.counter...999999 {
//                        snapshot.childSnapshot(forPath: String(i))
//                        self.arrayOf.IDNumber.append(String(i))
//                var secondID = snapshot.childSnapshot(forPath: "621092")
//                var thirdID = snapshot.childSnapshot(forPath: "623182")
//                        self.counter += 000001
//                    }
                    for data in snapshot.children.allObjects as! [DataSnapshot] {
                        func loadDatabaseIDNums() {
                            if self.check == 1 {
                                self.IDNumber = []
                                self.check = 2
                               }
                               let reference = Database.database().reference()
                               reference.observeSingleEvent(of: .value) { [self] (snapshot) in
                                   for dataa in snapshot.children.allObjects as! [DataSnapshot] {
                                       let id = dataa.key
                                       if id.contains("6") {
                                           if self.IDNumber.contains(id) {
                                               
                                           }
                                           else {
                                               self.IDNumber.append(id)
                                               print("id: ",id)
                                               print(self.IDNumber)
                                           }

                        
                    
                        let IDNumber = data.key
                        print(self.arrayOf.IDNumber)
                        let dictionary = data.value as! NSDictionary
                        let CounselorDictionary = dictionary["counselor"] as! String
                        let EmailDictionary = dictionary["E-mail"] as! String
                        let firstNameDictionary = dictionary["First Name"] as! String
                        let lastNameDictionary = dictionary["Last Name"] as! String
                    }
//                    self.tableView.reloadData()
                    }
                
    }
}
}
}
}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
}

