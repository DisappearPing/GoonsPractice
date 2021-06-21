//
//  ViewController.swift
//  GoonsPractice
//
//  Created by billHsiao on 2021/6/21.
//

import UIKit

class ViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}


extension ViewController {
    
    @IBAction func toNextPageAction(_ sender: Any) {
        
        let nextPageVC = MoveUpDownVC()
        
        self.navigationController?.pushViewController(nextPageVC, animated: true)
        
    }
    
}

