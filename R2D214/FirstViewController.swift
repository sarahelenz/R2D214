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
    var finalYears: [String] = []
    var yearNumbers: [String] = []
    var uniqueValues: [String] = []
    var studentsByYear: [[String]] = [[],[],[],[]]
    var selectedRow:Int = 0

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
                DispatchQueue.main.async {
                    self.tableView1.reloadData()
                }
            }
        }
        
    }
    func sortNames(students:[String]) -> [String] {
        var sorted:[String] = []
        var firstnames:[String] = []
        var lastnames:[String] = []
        var studReverse:[String] = []
        for student in students {
            let ind = student.firstIndex(of: " ")
            let range = student.startIndex ... ind!
            let end = student.endIndex
            let endindex = student.index(end, offsetBy: -1)
            let range2 = ind! ... endindex
            var student2 = student
            student2.removeSubrange(range)
            lastnames.append(student2)
            var student3 = student
            student3.removeSubrange(range2)
            firstnames.append(student3)
            let sreverse = student2 + " " + student3
            studReverse.append(sreverse)
        }
        sorted = studReverse.sorted { $0 < $1 }
        print(sorted)
        print("last", lastnames)
        print("first", firstnames)
        return sorted
    }
    func sortCounselor(couselors: [String]) -> [String] {
        print(couselors.sorted())
        return couselors.sorted()
    }
    func getYearNumbers() {
        loadDatabaseIDNums()
        print(idnum)
        for ids in idnum[0..<idnum.count]{
            
            yearNumbers.append(String(ids[1...2]))
            uniqueValues = Array(Set(yearNumbers))
        }
        finalYears.append(contentsOf: uniqueValues)
        
        finalYears = Array(Set(uniqueValues))
        finalYears.sort()
        finalYears.append("Entire School")
        print(finalYears)
        print(finalYears.count)
        
        
    }
    
    
    
    override func viewDidLoad() {
        tableView1.allowsSelection = true
        tableView1.allowsSelectionDuringEditing = true
        loadDatabaseIDNums()
        
        tableView1.dataSource = self
        tableView1.delegate = self
        super.viewDidLoad()
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [self, unowned messageAlert] _ in
            self.performSegue(withIdentifier: "segueToMessage1", sender: self)
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { [unowned messageAlert] _ in
            let thirdvc = ThirdViewController(nibName: "ThirdViewController", bundle: nil)
            self.navigationController?.pushViewController(thirdvc, animated: true)
        }
        messageAlert.addAction(yesAction)
        messageAlert.addAction(noAction)
        // getYearNumbers()
//        sortNames(students: ["Joe A", "BoB C", "Jill B", "Test Z", "Test D"])
//        sortCounselor(couselors: ["name6","name1","name6","gal","smith","gal","smith"])
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
//                   self.fullNames.append("\(self.arrayOf.firstName)" + " " + "\(self.arrayOf.lastName)")
                    DispatchQueue.main.async {
                        self.tableView1.reloadData()
                    }
                }
                self.tableView1.reloadData()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalYears.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("yes you did select the row")
        let indexPath = tableView1.indexPathForSelectedRow
        selectedRow = indexPath!.row
        print(selectedRow)
        present(messageAlert, animated: true, completion: nil)
    }
    func prepare(for segue: UIStoryboardSegue, sender: UIAlertController) {
        sortByYears()
        let nvc = segue.destination as! ThirdViewController
        if selectedRow == 4{
            nvc.idnum = self.idnum
        }
        else{
            nvc.idnum = self.studentsByYear[selectedRow]
        }
    }
    
    func sortByYears(){
        DispatchQueue.main.async {
            self.tableView1.reloadData()
        }
        for id in idnum{
            let stuYear = id[1...2]
            for year in 0...3{
                if stuYear == yearNumbers[year]{
                    studentsByYear[year].append(id)
                }
            }
            
        }
    }
    func prepare(for segue: UIStoryboardSegue, sender: UIButton) {
        sortByYears()
        let nvc = segue.destination as! messageVC
        nvc.idnum = self.idnum
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadDatabaseIDNums()
        DispatchQueue.main.async {
            self.tableView1.reloadData()
        }
        let classTitles = ["Class of \(finalYears[0])", "Class of \(finalYears[1])", "Class of \(finalYears[2])", "Class of \(finalYears[3])", "Entire School"]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.text = "\(classTitles[indexPath.row])"
        
        return cell
        
    }
   
}
