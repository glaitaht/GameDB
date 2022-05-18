//
//  Spinner.swift
//  GameDB
//
//  Created by Cem Kılıç on 7.03.2022.
//
 
import UIKit

class Spinner: UIViewController{
    
    var delayBeforeClosing : Double = 1
    
    override func viewDidLoad() {
        var dispTime =  DispatchTime.now() + delayBeforeClosing
        DispatchQueue.main.asyncAfter(deadline: dispTime ) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
