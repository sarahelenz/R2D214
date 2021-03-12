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
    let counselorStudents = [[],[],[],[],[],[],[]]
    override func viewDidLoad() {
        super.viewDidLoad()
        let studentArr = [["IDNumber":621006,"Counselor":"Deppen","First Name":"Sam","Last Name":"Corley"]] //data segued from Sarah's code, will need to be all students in a grade
        // Do any additional setup after loading the view.
        
        for student in studentArr{
            let stuCounselor = student["Counselor"]
            
            
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

