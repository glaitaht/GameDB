//
//  OnboardingCollectionViewCell.swift
//  GameDB
//
//  Created by Cem Kılıç on 11.03.2022.
//

import UIKit

class OnboardingCollectionViewCell : UICollectionViewCell {
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLbl: UILabel!
    @IBOutlet weak var slideDescriptionLbl: UILabel!
    
    func setup(_ slide: OnboardSlider) {
        slideTitleLbl.text = slide.title
        slideDescriptionLbl.text = slide.description
        
        slideImageView.heightAnchor.constraint(equalToConstant: frame.height*0.55).isActive = true
        slideImageView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        
        guard let confettiImageView = UIImageView.fromGif(
            frame: CGRect(
                x: slideImageView.layer.bounds.origin.x,
                y: slideImageView.layer.bounds.origin.y,
                width: frame.width,
                height: frame.height*0.6),
            resourceName: slide.image!) else { return }
        confettiImageView.contentMode = .scaleAspectFit
        slideImageView.addSubview(confettiImageView)
        confettiImageView.startAnimating()
        
        
    }
}
