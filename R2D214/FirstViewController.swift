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
    var tableViewCount = [1,2,3,4,5]
    
    override func viewDidLoad() {
        
        tableView1.dataSource = self
        super.viewDidLoad()
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [unowned messageAlert] _ in
            let messageVCC = messageVC(nibName: "messageVC", bundle: nil)
            self.navigationController?.pushViewController(messageVCC, animated: true)
            
        }
        let noAction = UIAlertAction(title: "No", style: .default) { [unowned messageAlert] _ in
            return
        }
        messageAlert.addAction(yesAction)
        messageAlert.addAction(noAction)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let classYears = arrayOf.IDNumber[0]
//        print(arrayOf.IDNumber)
//        var yearNumbers: [Int] = []
//        for year in classYears{
//            yearNumbers.append(year)
//            if classYears.contains(year){
//                break
//            }
//        }
//        let classTitles = ["Class of \(yearNumbers[0])", "Class of \(yearNumbers[1])", "Class of \(yearNumbers[2])", "Class of \(yearNumbers[3])", "Entire School"]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
//        cell.textLabel?.text = "\(classTitles[indexPath.row])"
//
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(messageAlert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as! ArrayOf
        
    }
}

