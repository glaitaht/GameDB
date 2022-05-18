//
//  CustomAlert.swift
//  GameDB
//
//  Created by Cem Kılıç on 6.03.2022.
//

import UIKit
class NoConnection: UIViewController {
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var littleView: UIView!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.view.sendSubviewToBack(bigView)
        bigView.layer.cornerRadius = 10
        bigView.layer.borderColor = UIColor.systemOrange.cgColor
        //bigView.layer.borderWidth = 2
        littleView.layer.borderWidth = 2
        littleView.layer.cornerRadius = 10
        littleView.layer.borderColor = UIColor.systemOrange.cgColor
    }
    
}
