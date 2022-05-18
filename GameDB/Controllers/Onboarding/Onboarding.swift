//
//  Onboarding.swift
//  GameDB
//
//  Created by Cem Kılıç on 11.03.2022.
//

import UIKit

class Onboarding : UIViewController {
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    @IBOutlet weak var onboardingButton: UIButton!
    
    var slides: [OnboardSlider] = []
    
    var currentPage = 0 {
            didSet {
                onboardingPageControl.currentPage = currentPage
                if currentPage == slides.count - 1 {
                    onboardingButton.setTitle("Get Started", for: .normal)
                } else {
                    onboardingButton.setTitle("Next", for: .normal)
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
                slides = [
                    OnboardSlider(title: "WIN THE GAME BEFORE IT'S PLAYED", description: "With unlimited amounth knowledge behind couple clicks.", image: "first"),
                    OnboardSlider(title: "Choose your game wisely", description: "You can't judge a fish by its ability to climb a tree. Lets find your ocean together.", image: "second"),
                    OnboardSlider(title: "Just play. Have fun. Enjoy the GAME", description: "Without passion, you are already dead.", image: "third")
                ]
                
        onboardingPageControl.numberOfPages = slides.count

    }
    
    @IBAction func onboardingButton(_ sender: UIButton) {
            if currentPage == slides.count - 1 {
                setOnboarded()
                dismiss(animated: true, completion: nil)
            } else {
                currentPage += 1
                let indexPath = IndexPath(item: currentPage, section: 0)
                onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
}
extension Onboarding : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
