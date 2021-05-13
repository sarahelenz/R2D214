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
            self.present(message, animated: true, completion: nil)
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
            let thirdvc = self.storyboard!.instantiateViewController(identifier: "thirdvc") as! ThirdViewController
            if self.selectedRow != 4 && self.studentsByYear[self.selectedRow].isEmpty {
                self.sortByYears()
            }
            if self.selectedRow == 4 {
                thirdvc.idnum = self.idnum
            }
            else{
                thirdvc.idnum = self.studentsByYear[self.selectedRow]
            }
            self.present(thirdvc, animated:true, completion: nil)
        }
        messageAlert.addAction(yesAction)
        messageAlert.addAction(noAction)
        
    }
    
    //function sets the number of rows in the TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalYears.count
    }
    
    //function handles selection of a row and presents messageAlert to select whether user wants to send message to this group or not 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView1.indexPathForSelectedRow!
        selectedRow = indexPath.row
        present(messageAlert, animated: true, completion: nil)
    }
   
    //function pulls down data from Firebase and puts all ID numbers into array idnum
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
    
    //function takes all ID numbers and sorts them by class year, then creates array uniqueValues with all of the unique year numbers
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
    
    //function sorts all student ID numbers by what class year they belong to
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
    
    //function puts class year values into the TableView cells
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
