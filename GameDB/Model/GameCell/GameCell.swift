//
//  GameCell.swift
//  GameDB
//
//  Created by Cem Kılıç on 6.03.2022.
//

import UIKit

class GameCell: UICollectionViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameReleaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gameReleaseDateLabel.widthAnchor.constraint(equalToConstant: CGFloat(frame.width/4) ).isActive = true
    }
    
    
    
    
    func configure(game: Game){
        self.gameNameLabel.text = game.name
        gameRatingLabel.text = String(game.rating!)
        gameReleaseDateLabel.text = game.released
        if let image = getSavedImage(named: game.name!+"x200.png") {
            self.gameImage.image = image
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: game.backgroundImage ?? "")
            let data = try? Data(contentsOf: url!)
            saveImage(image: UIImage(data: data!)!, name: game.name!, savingName: "xFS")
            var image = resizeImage(image: UIImage(data: data!)!, targetSize: CGSize(width: 200, height: 200))
            DispatchQueue.main.async() {
                self.gameImage.image = image
            }
            saveImage(image: image, name: game.name!, savingName: "x200")
        }
        
    }
    
}
