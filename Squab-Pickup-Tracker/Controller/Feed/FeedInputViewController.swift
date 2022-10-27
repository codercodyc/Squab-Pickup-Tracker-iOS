//
//  FeedInputViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 8/20/22.
//

import UIKit
import CoreData

class FeedInputViewController: UIViewController {

    
    var selectedSession: Session? {
        didSet {
            
        }
    }
    
    
    
   
    @IBOutlet weak var feedInputTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedInputTableView.delegate = self
        feedInputTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - UITableViewDataSource

extension FeedInputViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = selectedSession?.pens?.count ?? nil {
         return count
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let safeCell = tableView.dequeueReusableCell(withIdentifier: K.penFeedCell) as? FeedInputTableViewCell {
//            safeCell.penLabel = "305"
         
            
            cell = safeCell
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    
}


//MARK: - UITableViewDelegate

extension FeedInputViewController: UITableViewDelegate {
    
}
