//
//  Favourites.swift
//  GameDB
//
//  Created by Cem Kılıç on 7.03.2022.
//

import UIKit

final class Favourites : UIViewController {
    @IBOutlet weak var gameTableView: UICollectionView!
    
    var gameDetails = [GameDetail](){
        didSet {
            DispatchQueue.main.async {
                self.gameTableView.reloadData()
            }
        }
    }
    
    func initializeFunction(){
        gameTableView.delegate = self
        gameTableView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: 89)
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        gameTableView.setCollectionViewLayout(layout, animated: true)
        gameTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        gameTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        gameTableView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFunction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRecentFavouriteGames()
    }
    
    private func getRecentFavouriteGames(){
        gameDetails.removeAll()
        for game in favouriteGames{
            GameRequest().getGame(query: gameDetailLink + String(game) + APIkey) { [weak self] Result in
                switch Result {
                case .success(let gameResult):
                    self?.gameDetails.append(gameResult)
                case .failure(let failResult):
                    print(failResult)
                }
            }
        }
    }
}

extension Favourites : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCell else{
            return UICollectionViewCell()
        }
        cell.configure(game: Game(gameDetails[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let ID = self.gameDetails[indexPath.row].id else{
            return
        }
        guard let gameDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowGameDetail") as? ShowGameDetail else{
            return
        }
        gameDetailVC.IDforGameDetail = ID
        present(gameDetailVC, animated: true, completion: nil)
    }
    
}
