//
//  PickupPenViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

class PickupPenViewController: UIViewController {

    @IBOutlet weak var penCollectionView: UICollectionView!
    @IBOutlet weak var penLabel: UILabel!
    
    
    let pigeonData = PigeonData()
    
    let nestNames = ["1A", "1B", "1C","2A","2B","2C","3A","3B","3C","4A","4B","4C","5A","5B","5C","6A","6B","6C","7A","7B","7C","7D"]
    var nestInfo = NestData(pen: "", nest: "")
    var currentPen = ""
    
    var cellToReload: IndexPath = .init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPen = penLabel.text ?? ""
        penCollectionView.delegate = self
        penCollectionView.backgroundColor = .none
        penCollectionView.dataSource = self
        penCollectionView.reloadData()
        
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.segueToSelectionIdentifier {
            let destinationVC = segue.destination as! SelectionViewController
            destinationVC.delegate = self
            destinationVC.nest = nestInfo.nest
            destinationVC.pen = nestInfo.pen
        }
    }
    

}

//MARK: - UICollectionViewDataSource

extension PickupPenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return pigeonData.pen[0].nest.count
        return pigeonData.pen["401"]?.nest.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        let currentNest = nestNames[indexPath.row]
        if let contents = pigeonData.pen[currentPen]?.nest[currentNest]?.contents, let color = pigeonData.pen[currentPen]?.nest[currentNest]?.color {
            
            
            if let tempCell = penCollectionView.dequeueReusableCell(withReuseIdentifier: K.nestCellIdentifier, for: indexPath) as? nestCell {
                tempCell.updateNestLabel(currentNest)
                tempCell.updateContentsLabel(contents)
                tempCell.backgroundColor = color
                
                tempCell.layer.cornerRadius = 5
                cell = tempCell
            }
            
        }
        
        
        return cell
    }
 
    
}


//MARK: - UICollectionViewDelegate

extension PickupPenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = penCollectionView.cellForItem(at: indexPath) as? nestCell {
            nestInfo.nest = cell.nestLabel.text ?? ""
            nestInfo.pen = penLabel.text ?? ""
            cellToReload = indexPath
            
                self.performSegue(withIdentifier: K.segue.segueToSelectionIdentifier, sender: self)
            }
        
        
        
        }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        penCollectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor(named: K.color.highlightColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        penCollectionView.reloadItems(at: [indexPath])
        
    }
       
    

    
        
}


//MARK: - SelectionViewControllerDelegate

extension PickupPenViewController: SelectionViewControllerDelegate {
    func didUpdateNestContents(pen: String, nest: String, nestContents: String, color: UIColor) {
        
        pigeonData.pen[pen]?.nest[nest]?.contents = nestContents
        pigeonData.pen[pen]?.nest[nest]?.color = color
        
        UIView.animate(withDuration: 2) {
            self.penCollectionView.reloadItems(at: [self.cellToReload])

        }
        

    }
}





