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
    //below will be data segued from thirdviewcontroller - must be all students within one counselor
    let studentArr = [["IDNumber":"621006","Counselor":"Deppen","First Name":"Sam","Last Name":"Corley"],["IDNumber":"621007","Counselor":"Deppen","First Name":"Bob","Last Name":"Anderson"]]
    var idnum:[String] = []
    var searching = false
    var studentList = [String]()
    var searchedStudent = [String]()
    
    override func viewDidLoad() {
        tableview.dataSource = self
        tableview.delegate = self
        super.viewDidLoad()
        self.listofStudents()
        self.searchBar.showsCancelButton = true
    }
    func listofStudents() {
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Student not found for code: \(code)"
            studentList.append(name)
            tableview.reloadData()
        }
    }
    func prepare(for segue: UIStoryboardSegue, sender: UITableViewCell) {
        let nvc = segue.destination as! messageVC
        let indexPath = tableview.indexPathForSelectedRow
        let selectedRow = indexPath?.row
        var oneStudentArr:[String] = []
        oneStudentArr.append(studentArr[selectedRow!]["IDNumber"]!)
        nvc.idnum = oneStudentArr
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedStudent.count
        } else {
            return studentArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        let student = studentArr[indexPath.row]
        let name = student["First Name"]! + " " + student["Last Name"]!
        studentList.append(name)
        cell.textLabel?.text = name
        if searching {
            cell.textLabel?.text = searchedStudent[indexPath.row]
        } else {
            cell.textLabel?.text = name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            let selectedStudent = searchedStudent[indexPath.row]
            print(selectedStudent)
        } else {
            let selectedStudent = studentList[indexPath.row]
            print(selectedStudent)
        }
        self.searchBar.searchTextField.endEditing(true)
        let message = self.storyboard!.instantiateViewController(identifier: "messageVC") as! messageVC
        self.present(message, animated:true, completion: nil)
    }

    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchedStudent = studentList.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
    
    searching = true
    tableview.reloadData()
}
func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searching = false
    searchBar.text = ""
    tableview.reloadData()
    
}


}
