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
    
    var nestData = [NestClass]()
    
    
    var selectedNest: NestClass? {
        didSet {
            loadNest()
        }
    }

    @IBOutlet weak var nestLabel: UILabel!
    @IBOutlet weak var penLabel: UILabel!
    @IBOutlet weak var contentsCollectionView: UICollectionView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nestLabel.text = nestData[0].id
        penLabel.text = nestData[0].parentCategory?.id
        

        
        
        contentsCollectionView.delegate = self
        contentsCollectionView.dataSource = self
        contentsCollectionView.layer.backgroundColor = .none
        
        contentsCollectionView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
                
        self.dismiss(animated: true, completion: nil)
    }
    
    func clearBordersForCurrentPen() {
        var nests = selectedNest?.parentCategory?.nests?.allObjects as! [NestClass]
        
        nests = nests.map({ (nest) -> NestClass in
            nest.border = false
            return nest
        })
        
        saveData()
        
        
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
            
            if contents == "E" || contents == "EE" || contents == "A" || contents == "AA" || contents == "B" || contents == "BB" || contents == "C" || contents == "CC" || contents == "D" || contents == "DD" {
                nestData[0].inventoryCode = contents
                nestData[0].color = K.color.inventoryColor
                
                nestData[0].mortCode = ""
                nestData[0].productionAmount = 0
                nestData[0].mort2WkAmount = 0
                nestData[0].mort4WkAmount = 0
            } else {
            
            
                switch contents {
                case "Clear":
                    nestData[0].mortCode = ""
                    nestData[0].productionAmount = 0
                    nestData[0].mort2WkAmount = 0
                    nestData[0].mort4WkAmount = 0
                    nestData[0].color = K.color.cellDefault
                
                    
                case "X":
                    nestData[0].mortCode = contents
                    nestData[0].mort2WkAmount = 1
                    nestData[0].color = K.color.deadColor
                    
                    nestData[0].productionAmount = 0
                    nestData[0].mort4WkAmount = 0
                    nestData[0].inventoryCode = nil
                case "XX":
                    nestData[0].mortCode = contents
                    nestData[0].mort2WkAmount = 2
                    nestData[0].color = K.color.deadColor
                    
                    nestData[0].productionAmount = 0
                    nestData[0].mort4WkAmount = 0
                    nestData[0].inventoryCode = nil
                case "Y":
                    nestData[0].mortCode = contents
                    nestData[0].mort4WkAmount = 1
                    nestData[0].color = K.color.deadColor
                    
                    nestData[0].productionAmount = 0
                    nestData[0].mort2WkAmount = 0
                    nestData[0].inventoryCode = nil
                case "YY":
                    nestData[0].mortCode = contents
                    nestData[0].mort4WkAmount = 2
                    nestData[0].color = K.color.deadColor
                    
                    nestData[0].productionAmount = 0
                    nestData[0].mort2WkAmount = 0
                    nestData[0].inventoryCode = nil

                case "1 Squab":
                    nestData[0].productionAmount = 1
                    nestData[0].color = K.color.squabColor
                    
                    nestData[0].mort2WkAmount = 0
                    nestData[0].mort4WkAmount = 0
                    nestData[0].inventoryCode = nil
                case "2 Squab":
                    nestData[0].productionAmount = 2
                    nestData[0].color = K.color.squabColor
                    
                    nestData[0].mort2WkAmount = 0
                    nestData[0].mort4WkAmount = 0
                    nestData[0].inventoryCode = nil
                default:
                    nestData[0].color = "red"
                }
            }
            
            
            
            nestData[0].border = true
            nestData[0].dateModified = Date()
            saveData()
            
            
            self.delegate?.didUpdateNestContents()
            
            
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




//MARK: - Data Manipulation Methods

extension SelectionViewController {
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadNest(with request: NSFetchRequest<NestClass> = NestClass.fetchRequest()) {


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
