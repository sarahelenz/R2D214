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
    
        let arrayOf = ArrayOf()
    var counter = 000001
    
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
                  
                    for i in self.counter...999999 {
                snapshot.childSnapshot(forPath: String(i))
                    print(snapshot.childSnapshot(forPath: String(i)))
//                var secondID = snapshot.childSnapshot(forPath: "621092")
//                var thirdID = snapshot.childSnapshot(forPath: "623182")
                        self.counter += 000001
                    }
                    for data in snapshot.children.allObjects as! [DataSnapshot] {


                        
                    
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
