//
//  TransfersViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/15/21.
//

import UIKit
import CoreData

class TransferSelectorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TransferDataManagerDelegate {

    @IBOutlet weak var newPairButton: UIButton!
    @IBOutlet weak var movePairButton: UIButton!
    @IBOutlet weak var cullPairButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    private let buttonFontSize: CGFloat = 20
    
    // Create Instance of TransferDataManager
    private let transferDataManager = TransferDataManager()
    
    private var transfers = [PairLocationChange]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        transferDataManager.delegate = self
        
        newPairButton.makeMainButton(fontSize: buttonFontSize)
        movePairButton.makeMainButton(fontSize: buttonFontSize)
        cullPairButton.makeMainButton(fontSize: buttonFontSize)
       
        downloadTransfers()
      
        
//        refreshTransferData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        
        downloadTransfers()
        
    }
    
    func didDownloadTransfers() {
        transfers = transferDataManager.loadTranferData()
        collectionView.reloadData()
        print("reloaded")
    }
    
    func didFailWithError(error: Error) {
        let ac = UIAlertController(title: "Unable to get transfers", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    @objc func downloadTransfers() {
        
        DispatchQueue.global().async {
            self.transferDataManager.getTranferData()
        }
        
    }
    
    @IBAction func newTransfer(_ sender: UIButton) {
        print("transfer")
        collectionView.reloadData()
    }
    
    
    
//    //MARK: - Refresh Data
//    private func refreshTransferData() {
//        DispatchQueue.main.async {
//            self.transfers = self.transferDataManager.loadTranferData()
//        }
//    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transfers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let safeCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.transferDataCell, for: indexPath) as? TransferCollectionViewCell {
            safeCell.pairIdLabel.text = String(transfers[indexPath.row].pairId)
            safeCell.penNestLabel.text = "\(transfers[indexPath.row].pen ?? "")-\(transfers[indexPath.row].nest ?? "")"
            
            safeCell.transferDateLabel.text = formateDate(date: transfers[indexPath.row].eventDate)
            
            if transfers[indexPath.row].transferType == "Move In" || transfers[indexPath.row].transferType == "Move Out" {
                safeCell.transferTypeImage.image = UIImage(systemName: "arrow.left.arrow.right.square.fill" )
                safeCell.transferTypeImage.tintColor = UIColor(named: K.color.move)
//                safeCell.transferTypeLabel.text = "MOVE"
                
            } else if transfers[indexPath.row].transferType == "New Pair" {
                safeCell.transferTypeImage.image = UIImage(systemName: "plus.square.fill" )
                safeCell.transferTypeImage.tintColor = UIColor(named: K.color.newPair)
//                safeCell.transferTypeLabel.text = "NEW"

            } else if transfers[indexPath.row].transferType == "Cull" {
                safeCell.transferTypeImage.image = UIImage(systemName: "minus.square.fill" )
                safeCell.transferTypeImage.tintColor = UIColor(named: K.color.cull)
//                safeCell.transferTypeLabel.text = "CULL"

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
            collectionView.register(nib, forCellWithReuseIdentifier: K.transferDataCell)
    }
    
    func formateDate(date input: Double) -> String {
        let date = Date(timeIntervalSince1970: input)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.timeZone = TimeZone(abbreviation: "PT")
        dateFormatter.setLocalizedDateFormatFromTemplate("MM-dd-yyyy, HH:mm")
        
        return dateFormatter.string(from: date)
    }
    
    
    // MARK: - UI Collection View Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.layoutMarginsGuide.layoutFrame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return view.safeAreaInsets
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
}



    
    

