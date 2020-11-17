//
//  PickupPenViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit
import CoreData

protocol PickupPenViewControllerDelegate {
    
    func didSelectNest(nest: Nest)
    
}

class PickupPenViewController: UIViewController {
    
    
    var penData = [Pen]()
    var nestData = [Nest]()
    
    var selectedSesssion: Session? {
        didSet {
            //print(selectedSesssion?.dateCreated)
            loadPens()
            //print(penData.count)
            
            
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: PickupPenViewControllerDelegate?

    @IBOutlet weak var penCollectionView: UICollectionView!
    @IBOutlet weak var penLabel: UILabel!
    @IBOutlet weak var nextPenButton: UIButton!
    @IBOutlet weak var previousPenButton: UIButton!
    @IBOutlet weak var penView: UIView!
    @IBOutlet weak var penStackViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var penStackView: UIStackView!
    
    
        
    let nestNames = ["1A", "1B", "1C","2A","2B","2C","3A","3B","3C","4A","4B","4C","5A","5B","5C","6A","6B","6C","7A","7B","7C","7D"]
    var currentPen = ""
    var currentPenIndex = 1
    
    let cellPaddingH = CGFloat(15)
    let cellPaddingV = CGFloat(15)
    
    var cellToReload: IndexPath = .init()
    var selectedNest: Nest?
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        penLabel.text = penData[currentPenIndex].id
        currentPen = penLabel.text!
        loadNests()
        
        penCollectionView.delegate = self
        penCollectionView.backgroundColor = .none
        penCollectionView.dataSource = self
        penCollectionView.reloadData()
        
        penView.clipsToBounds = true
        
        
        
        
        
        
        
    }
    
    
//MARK: - Change Pens Actions

    @IBAction func nextPenPressed(_ sender: UIButton) {
        if currentPenIndex + 1 < penData.count {
            currentPenIndex += 1

            animatePenNameChange(changeDirection: "Next")
        }
    
        
    }
    
    @IBAction func previousPenPressed(_ sender: UIButton) {
        if currentPenIndex - 1 >= 0 {
            currentPenIndex -= 1
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
            self.penLabel.text = self.penData[self.currentPenIndex].id
            self.loadNests()
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
    
//MARK: - penLongPressed
    
    @IBAction func penLongPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            

            
            self.performSegue(withIdentifier: K.segue.segueToPenPopupIdentifier, sender: self)
            
            
            
            
            
        }
        
    }
    
    
   //MARK: - Prepare for Segue
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.segueToSelectionIdentifier {
            let destinationVC = segue.destination as! SelectionViewController
            destinationVC.delegate = self
            destinationVC.selectedNest = selectedNest
          
            
        } else if segue.identifier == K.segue.segueToPenPopupIdentifier {
            let destinationVC = segue.destination as! PenPopupViewController
            destinationVC.delegate = self
            destinationVC.popoverPresentationController?.delegate = self
            destinationVC.penData = penData
            
        }
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        penCollectionView.reloadData()
    }
    
//MARK: - Save and Load methods
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        penCollectionView.reloadData()
    }
    
    func loadPens(with request: NSFetchRequest<Pen> = Pen.fetchRequest(), pen: String? = nil) {
        
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let sessionPredicate = NSPredicate(format: "parentCategory.dateCreated == %@", selectedSesssion!.dateCreated! as CVarArg)
        
        
        request.predicate = sessionPredicate
        
        
        do {
            penData =  try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
    }
    
    func loadNests(with request: NSFetchRequest<Nest> = Nest.fetchRequest(), reload: Bool = true) {
        
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        
        let sessionPredicate = NSPredicate(format: "parentCategory.parentCategory.dateCreated == %@", selectedSesssion!.dateCreated! as CVarArg)
        
        let penPredicate = NSPredicate(format: "parentCategory.id MATCHES %@", penLabel.text!)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [sessionPredicate, penPredicate])
        
        do {
            nestData =  try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
        if reload {
            penCollectionView.reloadData()

        }
    }


}

//MARK: - UICollectionViewDataSource

extension PickupPenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return pigeonData.pen[currentPen]?.nest.count ?? 0
        return nestData.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        
        if let currentNest = nestData[indexPath.row].id, let color = nestData[indexPath.row].color {
            let mortString = nestData[indexPath.row].mortCode ?? ""
            var productionString = ""
            if nestData[indexPath.row].productionAmount != 0 {
                productionString = "\(nestData[indexPath.row].productionAmount) Squab"
            }
            let inventoryString = nestData[indexPath.row].inventoryCode ?? ""
            
            let contents = "\(mortString)\(productionString)\(inventoryString)"
        
            
            if let tempCell = penCollectionView.dequeueReusableCell(withReuseIdentifier: K.nestCellIdentifier, for: indexPath) as? nestCell {
                tempCell.updateNestLabel(currentNest)
                tempCell.updateContentsLabel(contents)
                tempCell.backgroundColor = UIColor(named: color)
                if nestData[indexPath.row].border {
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

        
        cellToReload = indexPath
        
        selectedNest = nestData[indexPath.row]
        self.performSegue(withIdentifier: K.segue.segueToSelectionIdentifier, sender: self)
        
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

//MARK: - UICollectionViewDelegateFlowLayout

extension PickupPenViewController: UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat((penCollectionView.frame.width - cellPaddingH * 4) / 3)
        let cellHeight = CGFloat((penCollectionView.frame.height - cellPaddingV * 9) / 8)
        
        
        return CGSize(width: cellWidth, height: cellHeight)
 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellPaddingV, left: cellPaddingH, bottom: cellPaddingV, right: cellPaddingH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPaddingV
    }
    
}


//MARK: - SelectionViewControllerDelegate

extension PickupPenViewController: SelectionViewControllerDelegate {
    func didUpdateNestContents() {
   
        loadNests(reload: false)
    
   
        UIView.animate(withDuration: 0.75) {
            let cellIndexPaths = self.penCollectionView.indexPathsForVisibleItems
            self.penCollectionView.reloadItems(at: cellIndexPaths)
            
        }
        
        

        
        
        
        
    }
    
    
}

//MARK: - PenPopupViewControllerDelegate



extension PickupPenViewController: PenPopupViewControllerDelegate {
    func didSelectPen(pen: String) {
        currentPen = pen
        penLabel.text = pen
        currentPenIndex = K.penIDs.firstIndex(of: pen)!
        loadNests()
    }
    
    
}

//MARK: - UIPopoverPresentationControllerDelegate


extension PickupPenViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}





