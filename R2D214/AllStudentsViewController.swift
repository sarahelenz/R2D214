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
    func listofStudents() {
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Student not found for code: \(code)"
            studentList.append(name)
            tableview.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedStudent.count
        } else {
            return idnum.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        if studentArr.count == idnum.count{
            for (student,_) in studentArr{
                print(student)
                studentList.append(student)
            }
            cell.textLabel?.text = studentList[indexPath.row]
        }
        else{
            tableview.reloadData()
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
        print("is this function even calling")
        let indexPath = tableview.indexPathForSelectedRow!
        let cell = tableview.cellForRow(at: indexPath)!
        let id = studentArr[(cell.textLabel!.text)!]!
        let oneStudentArr = [id]
        message.idnum = oneStudentArr
        print(message.idnum)
        self.present(message, animated:true, completion: nil)
    }

    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchedStudent = studentList.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
    
    searching = true
    tableview.reloadData()
}
    func getData(){
        for i in idnum {
            let reference = Database.database().reference().child(String(i))
            reference.observeSingleEvent(of: .value) { [self] (snapshot) in
                let valDict = snapshot.value as! Dictionary<String, String>
                let firstName = valDict["First Name"]!
                let lastName = valDict["Last Name"]!
                let name = firstName + " " + lastName
                studentArr[name] = i
                print(studentArr)
            }
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searching = false
    searchBar.text = ""
    tableview.reloadData()
    
}


}
