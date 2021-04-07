//
//  AllStudentsViewController.swift
//  R2D214
//
//  Created by Samantha Corley on 3/29/21.
//  Copyright © 2021 user178354. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AllStudentsViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableview:UITableView!
    //below will be data segued from thirdviewcontroller - must be all students within one counselor
    let studentArr = [["IDNumber":"621006","Counselor":"Deppen","First Name":"Sam","Last Name":"Corley"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        let student = studentArr[indexPath.row]
        let name = student["First Name"]! + student["Last Name"]!
        cell.textLabel?.text = name
        return cell
    }
}