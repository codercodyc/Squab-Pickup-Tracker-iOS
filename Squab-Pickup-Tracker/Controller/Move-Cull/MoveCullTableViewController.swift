//
//  MoveCullTableViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/3/20.
//

import UIKit

class MoveCullTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.MoveCullCellIdentifier, for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pairs to Cull"
        } else {
            return "Pair Move/Cull History"
        }
    }
    
    

    

}
