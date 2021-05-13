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
        return sorted
    }
    func sortCounselor(couselors: [String]) -> [String] {
        return couselors.sorted()
    }
    func getYearNumbers() {
        loadDatabaseIDNums()
        for ids in idnum[0..<idnum.count]{
            
            yearNumbers.append(String(ids[1...2]))
            uniqueValues = Array(Set(yearNumbers))
        }
        finalYears.append(contentsOf: uniqueValues)
        
        finalYears = Array(Set(uniqueValues))
        finalYears.sort()
        finalYears.append("Entire School")
        
        
    }
    
    
    
    override func viewDidLoad() {
        tableView1.allowsSelection = true
        tableView1.allowsSelectionDuringEditing = true
        loadDatabaseIDNums()
        
        tableView1.dataSource = self
        tableView1.delegate = self
        super.viewDidLoad()
        let yesAction = UIAlertAction(title: "Yes", style: .default) {  _ in
            let message = self.storyboard!.instantiateViewController(identifier: "messageVC") as! messageVC
            if self.selectedRow != 4 && self.studentsByYear[self.selectedRow].isEmpty {
                self.sortByYears()
            }
            if self.selectedRow == 4 {
                message.idnum = self.idnum
            }
            else{
                message.idnum = self.studentsByYear[self.selectedRow]
            }
            print(message.idnum)
            self.present(message, animated: true, completion: nil)
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
            let thirdvc = self.storyboard!.instantiateViewController(identifier: "thirdvc") as! ThirdViewController
            //add specifications for different rows
            if self.selectedRow != 4 && self.studentsByYear[self.selectedRow].isEmpty {
                self.sortByYears()
            }
            if self.selectedRow == 4 {
                thirdvc.idnum = self.idnum
            }
            else{
                thirdvc.idnum = self.studentsByYear[self.selectedRow]
            }
            print(thirdvc.idnum)
            self.present(thirdvc, animated:true, completion: nil)
        }
        messageAlert.addAction(yesAction)
        messageAlert.addAction(noAction)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalYears.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView1.indexPathForSelectedRow!
        selectedRow = indexPath.row
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
            uniqueValues.sort()
            for year in 0...3{
                if stuYear == uniqueValues[year]{
                    studentsByYear[year].append(id)
                }
            }
            
        }
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
