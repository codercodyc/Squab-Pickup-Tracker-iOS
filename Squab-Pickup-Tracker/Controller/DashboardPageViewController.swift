//
//  DashboardPageViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/11/20.
//

import UIKit

class DashboardPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    
    var viewControllerList: [UIViewController] {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = sb.instantiateViewController(identifier: "dashboardMain") // as! DashboardViewController
        let vc2 = sb.instantiateViewController(identifier: "orange") // as! DashboardViewController

        
        return [vc1, vc2]
    }
    
    
    //let dataSource = ["https://dkcpigeons.tk/dashapp/", "https://dkcpigeons.tk/dashapp/", "https://dkcpigeons.tk/dashapp/"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
    
      
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else { return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]

    }
    
 

}


