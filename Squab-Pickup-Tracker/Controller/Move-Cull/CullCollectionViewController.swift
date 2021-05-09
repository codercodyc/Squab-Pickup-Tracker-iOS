//
//  CullCollectionViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/4/20.
//

import UIKit
import Charts


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
            
            var entries = [ChartDataEntry]()
            var randomData: [Double] = []
            for _ in 0...12 {
                let number = Double(Int.random(in: 0...3))
                randomData.append(number)

            }
            for i in 0..<randomData.count {
                let value = ChartDataEntry(x: Double(i), y: randomData[i])
                entries.append(value)
                
            }
            
            
            safeCell.chart.plotProduction(with: entries)
            
            cell = safeCell
        }
        
        return cell
    }
    

   


}

//MARK: - UI Collection View Delegate Flow Layout

extension CullCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    
}
