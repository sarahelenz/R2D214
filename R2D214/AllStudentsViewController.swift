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

class AllStudentsViewController:UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview:UITableView!
    var studentArr:Dictionary<String,String> = [:]
    var idnum:[String] = []
    var searching = false
    var studentList = [String]()
    var searchedStudent = [String]()
    var num = 0
    
    override func viewDidLoad() {
        tableview.dataSource = self
        tableview.delegate = self
        getData()
        super.viewDidLoad()
        self.searchBar.showsCancelButton = true
    }
    
    //idk what this function does
    func listofStudents() {
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Student not found for code: \(code)"
            studentList.append(name)
            tableview.reloadData()
        }
    }
    
    //function sets number of rows in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedStudent.count
        } else {
            return idnum.count
        }
    }
    
    //function puts students' names into cells of TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        if studentArr.count == idnum.count{
            for (student,_) in studentArr{
                studentList.append(student)
            }
            cell.textLabel?.text = studentList[indexPath.row]
        }
        else{
            tableview.reloadData()
        }
        return cell
    }
    
    //function handles selection of row and presents message view controller to user to send a message to an individual student
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            let selectedStudent = searchedStudent[indexPath.row]
        } else {
            let selectedStudent = studentList[indexPath.row]
        }
        self.searchBar.searchTextField.endEditing(true)
        let message = self.storyboard!.instantiateViewController(identifier: "messageVC") as! messageVC
        let indexPath = tableview.indexPathForSelectedRow!
        let cell = tableview.cellForRow(at: indexPath)!
        let id = studentArr[(cell.textLabel!.text)!]!
        let oneStudentArr = [id]
        message.idnum = oneStudentArr
        self.present(message, animated:true, completion: nil)
    }

    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchedStudent = studentList.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
    
    searching = true
    tableview.reloadData()
    }
    
    //function pulls down student names from Firebase and creates dictionary with student names as keys and ID numbers as values
    func getData(){
        for i in idnum {
            let reference = Database.database().reference().child(String(i))
            reference.observeSingleEvent(of: .value) { [self] (snapshot) in
                let valDict = snapshot.value as! Dictionary<String, String>
                let firstName = valDict["First Name"]!
                let lastName = valDict["Last Name"]!
                let name = firstName + " " + lastName
                studentArr[name] = i
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searching = false
    searchBar.text = ""
    tableview.reloadData()
    
    }


}
