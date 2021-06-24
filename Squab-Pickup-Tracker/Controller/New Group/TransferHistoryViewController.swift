//
//  TransferHistoryViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/22/21.
//

import UIKit
import CoreData

//enum transferType: String {
//    case move = "arrow.left.arrow.right.square.fill"
//    case new = "plus.square.fill"
//    case cull = "minus.square.fill"
//}
//
//enum moveType: String {
//    case moveIn = "arrow.down.right.circle.fill"
//    case moveOut = "arrow.up.right.circle.fill"
//}

class TransferHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let transferDataManager = TransferDataManager()
    
    private var transfers = [PairLocationChange]()
    
    
    @IBOutlet weak var transfersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionView()
        
        transfersCollectionView.dataSource = self
        transfersCollectionView.delegate = self
        
        transfers = transferDataManager.loadTranferData()
        
        // Register Nib

        // Do any additional setup after loading the view.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transfers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let safeCell = transfersCollectionView.dequeueReusableCell(withReuseIdentifier: K.transferDataCell, for: indexPath) as? TransferCollectionViewCell {
            safeCell.pairIdLabel.text = String(transfers[indexPath.row].pairId)
            safeCell.penNestLabel.text = "\(transfers[indexPath.row].pen ?? "")-\(transfers[indexPath.row].nest ?? "")"
            
            safeCell.transferDateLabel.text = formateDate(date: transfers[indexPath.row].eventDate)
            
            if transfers[indexPath.row].transferType == "Move In" || transfers[indexPath.row].transferType == "Move Out" {
                safeCell.transferTypeImage.image = UIImage(systemName: "arrow.left.arrow.right.square.fill" )
                safeCell.transferTypeImage.tintColor = UIColor(named: K.color.move)
                safeCell.transferTypeLabel.text = "MOVE"
                
            } else if transfers[indexPath.row].transferType == "New Pair" {
                safeCell.transferTypeImage.image = UIImage(systemName: "plus.square.fill" )
                safeCell.transferTypeImage.tintColor = UIColor(named: K.color.newPair)
                safeCell.transferTypeLabel.text = "NEW"

            } else if transfers[indexPath.row].transferType == "Cull" {
                safeCell.transferTypeImage.image = UIImage(systemName: "minus.square.fill" )
                safeCell.transferTypeImage.tintColor = UIColor(named: K.color.cull)
                safeCell.transferTypeLabel.text = "CULL"

            }
            
            if transfers[indexPath.row].inOut == "In" {
                safeCell.inOutImage.image = UIImage(systemName: "arrow.down.right.circle.fill")
                safeCell.inOutImage.tintColor = UIColor(named: K.color.inTransfer)
                safeCell.inOutLabel.text = "IN"
            } else if transfers[indexPath.row].inOut == "Out" {
                safeCell.inOutImage.image = UIImage(systemName: "arrow.up.right.circle.fill")
                safeCell.inOutImage.tintColor = UIColor(named: K.color.outTransfer)
                safeCell.inOutLabel.text = "OUT"

            }
            
            
            
            
            cell = safeCell
        }
        
        return cell
    }
    
    
    func initCollectionView() {
        let nib = UINib(nibName: "TransferCollectionViewCell", bundle: nil)
        transfersCollectionView.register(nib, forCellWithReuseIdentifier: K.transferDataCell)
    }
    
    func formateDate(date input: Double) -> String {
        let date = Date(timeIntervalSince1970: input)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.timeZone = TimeZone(abbreviation: "PT")
        dateFormatter.setLocalizedDateFormatFromTemplate("MM-dd-yyyy, HH:mm")
        
        return dateFormatter.string(from: date)
    }
}


extension TransferHistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("resized cell")
        return CGSize(width: view.frame.width - view.safeAreaInsets.right - view.safeAreaInsets.left - 30, height: 240)
    }
}
