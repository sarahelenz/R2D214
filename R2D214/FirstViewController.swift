//
//  FirstViewController.swift
//  R2D214
//
//  Created by user178354 on 2/25/21.
//  Copyright © 2021 user178354. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let messageAlert = UIAlertController(title: "", message: "Is this the group you would like to send a message to?", preferredStyle: .alert)
    @IBOutlet weak var tableView1: UITableView!    
    
    override func viewDidLoad() {
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.text = ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(messageAlert, animated: true, completion: nil)
    }
}
