//
//  CullCollectionViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/4/20.
//

import UIKit


class CullCollectionViewController: UICollectionViewController {

    let cellInsetH: CGFloat = 10
    let cellInsetV: CGFloat = 15
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .clear
    }

    

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let safeCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cullCellIdentifier, for: indexPath) as? CullCollectionViewCell {
            
            safeCell.mainView.setRadius(with: 15)
            safeCell.setShadow()
            
            cell = safeCell
        }
  
            
        
            
//            safeCell.mainView.setShadow()
//            safeCell.mainView.setRadius(with: 15)
        
            
//            safeCell.cellView.setShadow()
//            safeCell.cellView.setRadius(with: 15)
            
        
        
    
        // Configure the cell
    
        return cell
    }
    

   


}

//MARK: - UI Collection View Delegate Flow Layout

extension CullCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: cellInsetV, left: cellInsetH, bottom: cellInsetV, right: cellInsetH)
//    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(0)
//    }
    
    
}
