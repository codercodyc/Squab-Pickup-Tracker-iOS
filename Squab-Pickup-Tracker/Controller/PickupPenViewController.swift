//
//  PickupPenViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

protocol PickupPenViewControllerDelegate {
    func passPigeonData(data: PigeonData)
}

class PickupPenViewController: UIViewController {
    
    var delegate: PickupPenViewControllerDelegate?

    @IBOutlet weak var penCollectionView: UICollectionView!
    @IBOutlet weak var penLabel: UILabel!
    @IBOutlet weak var nextPenButton: UIButton!
    @IBOutlet weak var previousPenButton: UIButton!
    @IBOutlet weak var penView: UIView!
    @IBOutlet weak var penStackViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var penStackView: UIStackView!
    
    
    var pigeonData = PigeonData()
    
    let nestNames = ["1A", "1B", "1C","2A","2B","2C","3A","3B","3C","4A","4B","4C","5A","5B","5C","6A","6B","6C","7A","7B","7C","7D"]
    var nestInfo = NestData(pen: "", nest: "")
    var currentPen = ""
    var currentPenIndex = 1
    
    
    var cellToReload: IndexPath = .init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        penLabel.text = pigeonData.penNames[currentPenIndex]
        currentPen = penLabel.text ?? ""
        penCollectionView.delegate = self
        penCollectionView.backgroundColor = .none
        penCollectionView.dataSource = self
        penCollectionView.reloadData()
        
        penView.clipsToBounds = true
        
        
    }
    
  
    
    

    @IBAction func nextPenPressed(_ sender: UIButton) {
        if currentPenIndex + 1 < pigeonData.penNames.count {
            currentPenIndex += 1
//            penLabel.text = pigeonData.penNames[currentPenIndex]
//            currentPen = penLabel.text!
            
            //penCollectionView.reloadData()
            animatePenNameChange(changeDirection: "Next")
        }
    
        
    }
    
    @IBAction func previousPenPressed(_ sender: UIButton) {
        if currentPenIndex - 1 >= 0 {
            currentPenIndex -= 1
//            penLabel.text = pigeonData.penNames[currentPenIndex]
//            currentPen = penLabel.text!
            //penCollectionView.reloadData()
            animatePenNameChange(changeDirection: "Previous")
        }
        
    }
    
    
    
    func animatePenNameChange(changeDirection: String) {
        var direction = CGFloat(0)
        
        if changeDirection == "Next" {
            direction = CGFloat(1)
        } else if changeDirection == "Previous" {
            direction = CGFloat(-1)
        }
        
        let animationTime = 0.5
        
        let penViewWidth = penView.frame.width
        

        let initialConstant = penStackViewCenterX.constant
        let width = penStackView.frame.width
        let moveDistance = (penViewWidth / 2 + width / 2 + 5) * direction

        penStackViewCenterX.constant -= moveDistance

        
        UIView.animate(withDuration: animationTime) {
            self.penView.layoutIfNeeded()
            self.penCollectionView.alpha = 0.25
            
        } completion: { (done) in
            self.penLabel.text = self.pigeonData.penNames[self.currentPenIndex]
            self.currentPen = self.penLabel.text!
            self.penCollectionView.reloadData()
            self.penStackViewCenterX.constant += moveDistance * 2
            self.penView.layoutIfNeeded()
            self.penStackViewCenterX.constant = initialConstant
            self.penCollectionView.alpha = 1

            
            UIView.animate(withDuration: animationTime) {
                self.penView.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func penLongPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            

            
            self.performSegue(withIdentifier: K.segue.segueToPenPopupIdentifier, sender: self)
            
            
            
            
            
        }
        
    }
    
    
    
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.segueToSelectionIdentifier {
            let destinationVC = segue.destination as! SelectionViewController
            destinationVC.delegate = self
            destinationVC.nest = nestInfo.nest
            destinationVC.pen = nestInfo.pen
        } else if segue.identifier == K.segue.segueToPenPopupIdentifier {
            let destinationVC = segue.destination as! PenPopupViewController
            destinationVC.delegate = self
            destinationVC.popoverPresentationController?.delegate = self
            self.delegate?.passPigeonData(data: pigeonData)
        }
        
    }
    

}

//MARK: - UICollectionViewDataSource

extension PickupPenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pigeonData.pen[currentPen]?.nest.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        let currentNest = nestNames[indexPath.row]
        if let contents = pigeonData.pen[currentPen]?.nest[currentNest]?.contents, let color = pigeonData.pen[currentPen]?.nest[currentNest]?.color, let borderCondition = pigeonData.pen[currentPen]?.nest[currentNest]?.isMostRecent {
            
            
            if let tempCell = penCollectionView.dequeueReusableCell(withReuseIdentifier: K.nestCellIdentifier, for: indexPath) as? nestCell {
                tempCell.updateNestLabel(currentNest)
                tempCell.updateContentsLabel(contents)
                tempCell.backgroundColor = color
                if borderCondition {
                    tempCell.layer.borderWidth = 3
                } else {
                    tempCell.layer.borderWidth = 0
                }
                
                
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
        if let previousCell = penCollectionView.cellForItem(at: cellToReload) as? nestCell {
            let previousNest = previousCell.nestLabel.text!
            pigeonData.pen[currentPen]?.nest[previousNest]?.isMostRecent = false
            penCollectionView.reloadItems(at: [cellToReload])
        }
        
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
        penCollectionView.reloadItems(at: [cellToReload])
        
        pigeonData.pen[pen]?.nest[nest]?.color = color
        pigeonData.pen[pen]?.nest[nest]?.isMostRecent = true
        
//        for currentNest in pigeonData.pen[pen]?.nest.count {
//            currentNest.issele
//        }
        
        UIView.animate(withDuration: 0.75) {
            self.penCollectionView.reloadItems(at: [self.cellToReload])

        }
        
        penCollectionView.reloadData()
    }
    
    
}


extension PickupPenViewController: PenPopupViewControllerDelegate {
    func didSelectPen(pen: String) {
        currentPen = pen
        penLabel.text = pen
        currentPenIndex = pigeonData.penNames.firstIndex(of: pen)!
        penCollectionView.reloadData()
    }
    
    
}


extension PickupPenViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}



