//
//  ShowGameDetail.swift
//  GameDB
//
//  Created by Cem Kılıç on 6.03.2022.
//

import UIKit

class ShowGameDetail: UIViewController {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var favButton: UIImageView!
    @IBOutlet weak var nameOfGame: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var labelVeiw: UIView!
    @IBOutlet weak var descriptionAboutGame: UITextView!
    
    
    public var IDforGameDetail : Int = -1
    public var thumbsUp : UIImage?
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            self.present(showSpinner(delayBeforeClosing: 1), animated: false, completion: nil)
        }
        view.isHidden = true
        gameRequests.getGame(query: gameDetailLink + String(IDforGameDetail) + APIkey) { Result in
            switch Result {
            case .success(let gameResult):
                self.nameOfGame.text = gameResult.name
                self.releaseDate.text = gameResult.released
                self.rating.text = String(gameResult.rating!)
                self.descriptionAboutGame.text = gameResult.descriptionRaw
                let url = URL(string: gameResult.backgroundImage ?? "")
                let data = try? Data(contentsOf: url!)
                self.gameImage.image = UIImage(data: data!)
                self.view.isHidden = false
            case .failure(let failResult):
                print(failResult)
            }
        }
        
        labelVeiw.layer.borderColor = UIColor.systemOrange.cgColor
        labelVeiw.layer.borderWidth = 2
        labelVeiw.layer.cornerCurve = .continuous
        labelVeiw.layer.cornerRadius = 10
    }
    
    func isFavourite() -> Bool {
        for i in favouriteGames{
            if i == IDforGameDetail{
                return true
            }
        }
        return false
    }
    
    ///when thumbsup imageview tapped it changes favourites situation and saves to the user defaults
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        DispatchQueue.main.async {
            let tappedImage = tapGestureRecognizer.view as! UIImageView
            if self.isFavourite(){
                for (index,i) in favouriteGames.enumerated() {
                    if i==self.IDforGameDetail{
                        favouriteGames.remove(at: index)
                        break
                    }
                }
                self.favButton.image = self.thumbsUp!.colorized(with: .white)
                self.favButton.image = self.favButton.image!.stroked(with:.systemGreen, thickness: CGFloat(1))
                setFavouriteGamesToUserDefault()
            }
            else{
                favouriteGames.append(self.IDforGameDetail)
                self.favButton.image = self.thumbsUp!.colorized(with: .white)
                self.favButton.image = self.favButton.image!.stroked(with:.systemRed, thickness: CGFloat(1))
                setFavouriteGamesToUserDefault()  
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        thumbsUp = UIImage(systemName: "hand.thumbsup.fill")
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.systemOrange.cgColor
        
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        gameImage.layer.cornerRadius = 15
        gameImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40).isActive = true
        favButton.image = thumbsUp
        favButton.image = favButton.image!.colorized(with: .white)
        if isFavourite(){
            favButton.image = favButton.image!.stroked(with: .systemRed, thickness: CGFloat(1))
        }
        else{
            favButton.image = favButton.image!.stroked(with: .systemGreen, thickness: CGFloat(1))
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        favButton.isUserInteractionEnabled = true
        favButton.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
}
