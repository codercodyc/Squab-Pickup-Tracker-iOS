//
//  SelectionViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit
import CoreData

protocol SelectionViewControllerDelegate {
    func didUpdateNestContents()
}

class SelectionViewController: UIViewController {
    
    var delegate: SelectionViewControllerDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var nestData = [Nest]()
    
    
    var selectedNest: Nest? {
        didSet {
            loadNest()
        }
    }

    @IBOutlet weak var nestLabel: UILabel!
    @IBOutlet weak var penLabel: UILabel!
    @IBOutlet weak var contentsCollectionView: UICollectionView!
    @IBOutlet weak var multipleInputsButton: UIButton!
    
    
    let cellPaddingW = CGFloat(10)
    let cellPaddingH = CGFloat(10)

    
    var cellWidth: CGFloat {
        return (contentsCollectionView.frame.width - cellPaddingW) / 2
    }
    var cellHeight: CGFloat {
        return (contentsCollectionView.frame.height - cellPaddingH * 5) / 5
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nestLabel.text = nestData[0].id
        penLabel.text = nestData[0].parentCategory?.id
        
        multipleInputsButton.setTitleColor(.black, for: .selected)
        
        
        contentsCollectionView.delegate = self
        contentsCollectionView.dataSource = self
        contentsCollectionView.backgroundColor = .none
        
        contentsCollectionView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contentsCollectionView.backgroundColor = .none
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
                
        self.dismiss(animated: false, completion: nil)
    }
    
    func clearBordersForCurrentPen() {
        var nests = selectedNest?.parentCategory?.nests?.allObjects as! [Nest]
        
        nests = nests.map({ (nest) -> Nest in
            nest.border = false
            return nest
        })
        
        saveData()
        
        
    }
    
    
    
    @IBAction func multipleInputsPressed(_ sender: UIButton) {
        multipleInputsButton.isSelected = !multipleInputsButton.isSelected
        
    }
    
        
   
}

//MARK: - UICollectionViewDataSource


extension SelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.nestContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contents = K.nestContents[indexPath.row]
        let color = UIColor(named: K.nestContentColors[contents]!)
        var cell = UICollectionViewCell()
        if let tempCell = contentsCollectionView.dequeueReusableCell(withReuseIdentifier: K.ContentsCellIdentifier, for: indexPath) as? ContentsCell {
            tempCell.updateContentsLabel(contents)
            tempCell.backgroundColor = color
            tempCell.layer.cornerRadius = 10
            
           
            if contents == nestData[0].inventoryCode || contents == nestData[0].mortCode || contents == "\(nestData[0].productionAmount) Squab" {
                tempCell.layer.borderWidth = 3
            } else {
                tempCell.layer.borderWidth = 0
            
            }
            cell = tempCell
        }
        
        
        return cell
    }
    
    
    
    
}


    
//MARK: - UICollectionViewDelegate



extension SelectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = contentsCollectionView.cellForItem(at: indexPath) as? ContentsCell {
            
            clearBordersForCurrentPen()
            
            let contents = cell.contentsLabel.text
            
            if multipleInputsButton.isSelected == false {
                nestData[0].inventoryCode = ""
                nestData[0].mortCode = ""
                nestData[0].productionAmount = 0
            }
            
            
            if contents == "E" || contents == "EE" || contents == "A" || contents == "AA" || contents == "B" || contents == "BB" || contents == "C" || contents == "CC" || contents == "D" || contents == "DD" {
                nestData[0].inventoryCode = contents
                nestData[0].color = K.color.inventoryColor
                
//                nestData[0].mortCode = ""
//                nestData[0].productionAmount = 0

            } else {
            
            
                switch contents {
                case "Clear":
                    nestData[0].mortCode = ""
                    nestData[0].productionAmount = 0
                    nestData[0].inventoryCode = ""
                    nestData[0].color = K.color.cellDefault
                
                    
                case "X":
                    nestData[0].mortCode = contents
                    nestData[0].color = K.color.deadColor
                    
//                    nestData[0].productionAmount = 0
//                    nestData[0].inventoryCode = nil
                case "XX":
                    nestData[0].mortCode = contents
                    nestData[0].color = K.color.deadColor
                    
//                    nestData[0].productionAmount = 0
//                    nestData[0].inventoryCode = nil
                case "Y":
                    nestData[0].mortCode = contents
                    nestData[0].color = K.color.deadColor
                    
//                    nestData[0].productionAmount = 0
//                    nestData[0].inventoryCode = nil
                case "YY":
                    nestData[0].mortCode = contents
                    nestData[0].color = K.color.deadColor
                    
//                    nestData[0].productionAmount = 0
//                    nestData[0].inventoryCode = nil

                case "1 Squab":
                    nestData[0].productionAmount = 1
                    nestData[0].color = K.color.squabColor
             
//                    nestData[0].inventoryCode = nil
                case "2 Squab":
                    nestData[0].productionAmount = 2
                    nestData[0].color = K.color.squabColor
                    
              
//                    nestData[0].inventoryCode = nil
                default:
                    nestData[0].color = "red"
                }
            }
            

            
            
            nestData[0].border = true
            nestData[0].dateModified = Date()
            saveData()
            
            
            self.delegate?.didUpdateNestContents()
            
            
        }
            
                
        
        if multipleInputsButton.isSelected == false {
            self.dismiss(animated: false, completion: nil)
        } else {
            loadNest()
            contentsCollectionView.reloadItems(at: contentsCollectionView.indexPathsForVisibleItems)
        }
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



//MARK: - UICollectionViewFlowLayoutDelegate

extension SelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPaddingH
    }
    
}



//MARK: - Data Manipulation Methods

extension SelectionViewController {
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadNest(with request: NSFetchRequest<Nest> = Nest.fetchRequest()) {


        let sessionPredicate = NSPredicate(format: "parentCategory.parentCategory.dateCreated == %@", selectedNest!.parentCategory!.parentCategory!.dateCreated! as CVarArg)

        let penPredicate = NSPredicate(format: "parentCategory.id MATCHES %@", selectedNest!.parentCategory!.id!)
        
        let nestPredicate = NSPredicate(format: "id MATCHES %@", selectedNest!.id!)

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [sessionPredicate, penPredicate, nestPredicate])

        do {
            nestData =  try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }

    }
    
}
