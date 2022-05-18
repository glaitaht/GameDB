//
//  ViewController.swift
//  GameDB
//
//  Created by Cem Kılıç on 5.03.2022.
//

import UIKit

class MainbarController: UIViewController {
    @IBOutlet weak var imageScrollPageControl: UIPageControl!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gameTableView: UICollectionView!
    
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var downloadingData = false
    var imagesArray = [UIImage]()
    
    var pages = [Page](){
        didSet {
            DispatchQueue.main.async {
                self.gameTableView.reloadData()
                self.loadImages()
            }
        }
    }
    var isGamesFiltered: Bool = false
    var gamesFiltered: [Game] = [Game]()
    
    ///initialize contraints when function loaded
    func initializeFunction(){
        activityIndicator.backgroundColor = .systemOrange
        activityIndicator.hidesWhenStopped = true
        gameTableView.showsVerticalScrollIndicator = false
        searchBarConstraints()
        collectionViewConstraints()
        imageScrollViewConstraints()
        //general
        self.hideKeyboardWhenTappedAround()
        getFavouriteGamesFromUserDefault()
    }
    
    func searchBarConstraints(){
        searchBar.layer.cornerRadius = 10
        searchBar.layer.cornerCurve = .continuous
        searchBar.layer.borderColor = UIColor.systemOrange.cgColor
        searchBar.layer.borderWidth = 2
    }
    
    func collectionViewConstraints(){
        gameTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.50).isActive = true
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
        gameTableView.register(UINib(nibName: "PaginationCell", bundle: nil), forCellWithReuseIdentifier: "paginationCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: 89)
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        gameTableView.setCollectionViewLayout(layout, animated: true)
        gameTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        gameTableView.layer.cornerRadius = 10
        gameTableView.layer.cornerCurve = .continuous
        gameTableView.layer.borderColor = UIColor.systemOrange.cgColor
        gameTableView.layer.borderWidth = 1
    }
    
    func imageScrollViewConstraints(){
        imagesArray.append(UIImage(named: "NotFound")!)
        imagesArray.append(UIImage(named: "NotFound")!)
        imagesArray.append(UIImage(named: "NotFound")!)
        imageScrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        imageScrollView.isPagingEnabled = true
        imageScrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(imagesArray.count), height: view.frame.height * 0.25 )
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.bottomAnchor.constraint(equalTo: gameTableView.topAnchor).isActive = true
        imageScrollView.delegate = self
        imageScrollView.layer.cornerRadius = 10
        imageScrollView.layer.cornerCurve = .continuous
        imageScrollView.layer.borderColor = UIColor.systemOrange.cgColor
        imageScrollView.layer.borderWidth = 1
    }
    ///Loads images to the image slider and rearrange contraints
    func loadImages(){
        for (index, _) in imagesArray.enumerated(){
            if let imageSlider = Bundle.main.loadNibNamed("ImageSlider", owner: self, options: nil)?.first as? ImageSlider{
                imageSlider.imageSliderLabel.text = self.pages[0].results[index].name!
                imageSlider.imageSliderRating.text = String(self.pages[0].results[index].rating!)
                //containers part
                imageScrollView.addSubview(imageSlider)
                imageSlider.frame.size.width = self.view.bounds.size.width
                imageSlider.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
                imageSlider.imageSliderImage.bottomAnchor.constraint(equalTo: gameTableView.topAnchor ).isActive = true
                imageSlider.imageSliderCardView.layer.borderColor = UIColor.black.cgColor
                imageSlider.imageSliderCardView.layer.borderWidth = 2
                imageSlider.imageSliderCardView.layer.cornerCurve = .continuous
                imageSlider.imageSliderCardView.layer.cornerRadius = 20
                imageSlider.imageSliderCardView.bottomAnchor.constraint(equalTo: gameTableView.topAnchor, constant: -20).isActive = true
                imageSlider.imageSliderCardView.topAnchor.constraint(equalTo: imageScrollView.topAnchor, constant: 20).isActive = true
                imageSlider.imageSliderLabel.topAnchor.constraint(equalTo: imageSlider.imageSliderCardView.topAnchor, constant: imageScrollView.frame.size.height*0.15).isActive = true
                
                imageSlider.imageSliderRating.bottomAnchor.constraint(equalTo: imageSlider.imageSliderCardView.bottomAnchor, constant: -imageScrollView.frame.size.height*0.15).isActive = true
                imageSlider.starSign.bottomAnchor.constraint(equalTo: imageSlider.imageSliderCardView.bottomAnchor, constant: -imageScrollView.frame.size.height*0.15).isActive = true
                // image part
                if let image = getSavedImage(named: self.pages[0].results[index].name!+"xFS.png") {
                    imageSlider.imageSliderImage.image = image
                    continue
                }
                let url = URL(string: self.pages[0].results[index].backgroundImage ?? "")
                let data = try? Data(contentsOf: url!)
                imageSlider.imageSliderImage.image = UIImage(data: data!)
                saveImage(image: UIImage(data: data!)!, name: self.pages[0].results[index].name!, savingName: "xFS")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFunction()
        if(Reachability.isConnectedToNetwork()){
            PageRequest().getPage(query: firstLinkOfApiPage) { [weak self] resultFromRequest in
                switch resultFromRequest {
                case .success(let pageResult):
                    self?.pages.append(pageResult)
                case .failure(_):
                    self?.present(showAlert("CustomAlert", "NoConnection", .overCurrentContext, .crossDissolve), animated: true, completion: nil)
                }
            }
        }
        else{
            DispatchQueue.main.async {
                let imageView = UIImageView(image: (UIImage(named: "NotFound")))
                imageView.frame = self.imageScrollView.bounds
                self.imageScrollView.addSubview(imageView)
                
                self.present(showAlert("CustomAlert", "NoConnection", .overCurrentContext, .crossDissolve), animated: true, completion: nil)
            }
        }
        
        if !isOnboarded(){
            DispatchQueue.main.async {
                self.present(showAlert("Onboarding", "Onboarding", .overCurrentContext, .crossDissolve), animated: true, completion: nil)
            }
        }else{
            DispatchQueue.main.async {
                self.present(showSpinner(delayBeforeClosing: 1), animated: true, completion: nil)
            }
        }
    }
    
    ///while loading next page showing spinner and changin contentoffset.
    ///Parameters : delay -> delay before content changes
    func otherPageLoader(){
        //self.present(showSpinner(delayBeforeClosing: delay), animated: true, completion: nil)
        //let dispTime : DispatchTime = DispatchTime.now() + delay
        DispatchQueue.main.async {
            self.gameTableView.setContentOffset(.zero, animated: false)
            self.downloadingData = false
            self.gameTableView.reloadData()
        }
    }
    ///last cell of collectionview has 2 button, this button take next button's action
    @objc func nextPage(){
        DispatchQueue.main.async { [self] in
            downloadingData = true
            gameTableView.reloadData()
            if(activePage+1 >= pages.count){
                PageRequest().getPage(query: pages[pages.count-1].next!) { [weak self] resultFromRequest in
                    switch resultFromRequest {
                    case .success(let pageResult):
                        self?.pages.append(pageResult)
                        self?.otherPageLoader()
                    case .failure(let failResult):
                        print(failResult)
                    }
                }
                activePage = activePage + 1
                //otherPageLoader(delayTime: 2)
            }
            else{
                activePage = activePage + 1
                otherPageLoader()
                downloadingData = false
            }
        }
    }
    ///last cell of collectionview has 2 button, this button take previous button's action
    @objc func previousPage(){
        if(activePage != 0){
            activePage = activePage - 1
            otherPageLoader()
        }
    }
    
}

extension MainbarController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if downloadingData {
            activityIndicator.startAnimating()
            activityIndicator.center = collectionView.center
            collectionView.backgroundView = activityIndicator
            return 0
        }
        if isGamesFiltered {
            if !gamesFiltered.isEmpty {
                collectionView.backgroundView = nil
            }
            else{
                let customViewSize = CGRect(x: 0, y: 0,
                                            width: collectionView.bounds.size.width,
                                            height: collectionView.bounds.size.height)
                let viewOfNoContent = UIView(frame: customViewSize)
                let imageView = UIImageView(image: UIImage(named: "NotFound"))
                imageView.frame = customViewSize
                viewOfNoContent.addSubview(imageView)
                collectionView.backgroundView = viewOfNoContent
            }
            return gamesFiltered.count
        }
        else{
            if self.pages.count > 0{
                collectionView.backgroundView = nil
                return self.pages[activePage].results.count+1
            }
            else{
                let customViewSize = CGRect(x: 0, y: 0,
                                            width: collectionView.bounds.size.width,
                                            height: collectionView.bounds.size.height)
                let viewOfNoContent = UIView(frame: customViewSize)
                let imageView = UIImageView(image: UIImage(named: "NotFound"))
                imageView.frame = customViewSize
                viewOfNoContent.addSubview(imageView)
                collectionView.backgroundView = viewOfNoContent
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // if cell is the last cell, it is pagination cell
        if indexPath.row == self.pages[activePage].results.count{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paginationCell", for: indexPath) as? PaginationCell else{
                return UICollectionViewCell()
            }
            cell.nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
            cell.previousButton.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
            cell.previousButton.isHidden = false
            if activePage == 0 {
                cell.previousButton.isHidden = true
            }
            cell.pageLabel.text = String(activePage)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCell else{
            return UICollectionViewCell()
        }
        cell.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        var gameToShow : Game = self.pages[activePage].results[indexPath.row]
        if(isGamesFiltered){
            gameToShow = self.gamesFiltered[indexPath.row]
        }
            cell.configure(game: gameToShow)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.pages[activePage].results.count  {
            return
        }
        var ID = self.pages[activePage].results[indexPath.row].id!
        if(isGamesFiltered){
            ID = self.gamesFiltered[indexPath.row].id!
        }
        guard let gameDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowGameDetail") as? ShowGameDetail else{
            return
        }
        gameDetailVC.IDforGameDetail = ID
        present(gameDetailVC, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width , height: 89)
    }
    
}
extension MainbarController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isGamesFiltered = false
        gamesFiltered.removeAll()
        gameTableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isGamesFiltered = false
            gameTableView.reloadData()
        }
        if searchText.count > 2{
            gamesFiltered.removeAll()
            for pageToTakeGames in pages{
                for gameToTake in pageToTakeGames.results{
                    if gameToTake.name!.lowercased().contains(searchText.lowercased()){
                        gamesFiltered.append(gameToTake)
                    }
                }
            }
            isGamesFiltered = true
            gameTableView.reloadData()
        }
    }
}
extension MainbarController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        imageScrollPageControl.currentPage = Int(page)
        
    }
}
