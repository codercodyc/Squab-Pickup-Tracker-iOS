//
//  SelectionViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

protocol SelectionViewControllerDelegate {
    func didUpdateNestContents(pen: String, nest: String, nestContents: String, color: UIColor)
}

class SelectionViewController: UIViewController {
    
    var delegate: SelectionViewControllerDelegate?

    @IBOutlet weak var nestLabel: UILabel!
    @IBOutlet weak var penLabel: UILabel!
    @IBOutlet weak var contentsCollectionView: UICollectionView!
    
    let nestContents = ["" ,"Clear", "E", "EE", "A", "AA", "B", "BB", "C", "CC", "D", "DD", "X", "XX", "Y", "YY", "1 Squab", "2 Squab"]
    
    let nestContentColors: [String: String] = [
        "E" : K.color.inventoryColor,
        "EE" : K.color.inventoryColor,
        "A" : K.color.inventoryColor,
        "AA" : K.color.inventoryColor,
        "B" : K.color.inventoryColor,
        "BB" : K.color.inventoryColor,
        "C" : K.color.inventoryColor,
        "CC" : K.color.inventoryColor,
        "D" : K.color.inventoryColor,
        "DD" : K.color.inventoryColor,
        "X" : K.color.deadColor,
        "XX" : K.color.deadColor,
        "Y" : K.color.deadColor,
        "YY" : K.color.deadColor,
        "1 Squab" : K.color.squabColor,
        "2 Squab"  : K.color.squabColor,
        "Clear" : K.color.cellDefault,
        "" : "none"
    ]
    
    var nest: String?
    var pen: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nestLabel.text = nest
        penLabel.text = pen
        

        
        
        contentsCollectionView.delegate = self
        contentsCollectionView.dataSource = self
        contentsCollectionView.layer.backgroundColor = .none
        
        contentsCollectionView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
                
        self.dismiss(animated: true, completion: nil)
    }
    
   
}

extension SelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nestContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contents = nestContents[indexPath.row]
        let color = UIColor(named: nestContentColors[contents]!)
        var cell = UICollectionViewCell()
        if let tempCell = contentsCollectionView.dequeueReusableCell(withReuseIdentifier: K.ContentsCellIdentifier, for: indexPath) as? ContentsCell {
            tempCell.updateContentsLabel(contents)
            tempCell.backgroundColor = color
            tempCell.layer.cornerRadius = 10
            cell = tempCell
        }
        
        
        return cell
    }
    
    
}

extension SelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = contentsCollectionView.cellForItem(at: indexPath) as? ContentsCell {
            if var contents = cell.contentsLabel.text, let currentPen = penLabel.text, let currentNest = nestLabel.text, let currentColor = cell.backgroundColor {
                if contents == "Clear" {
                   contents = ""
                }
                self.delegate?.didUpdateNestContents(pen: currentPen, nest: currentNest, nestContents: contents, color: currentColor)
            }
            
                
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        contentsCollectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(named: K.color.highlightColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        contentsCollectionView.reloadItems(at: [indexPath])
    }
}
