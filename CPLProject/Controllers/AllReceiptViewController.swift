//
//  AllReceiptViewController.swift
//  CPLProject
//
//  Created by Kaur, Simerjeet on 13/06/21.
//  Copyright © 2021 com.cpl. All rights reserved.
//

import UIKit

class AllReceiptViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var allReceiptsTableView: UITableView!
    let showProfileGroupSegueIdentifier = "showProfileGroupItemSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

          var cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
              if (cell == nil) {
          cell = UITableViewCell(
          style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellId")
          }
        cell?.textLabel?.text = String(format: "Receipt %i",(indexPath.row + 1))
              return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as? GroupTableViewController
        if segue.identifier == showProfileGroupSegueIdentifier {
            destination!.title = "Left Menu"
        }
    }
}
