//
//  Functions.swift
//  GameDB
//
//  Created by Cem Kılıç on 11.03.2022.
//

import Foundation
import SystemConfiguration 
import UIKit

func isOnboarded() -> Bool{
    var onboarded : Bool = userDefaults.object(forKey: "onboarded") as? Bool ?? false
    return onboarded
}

func setOnboarded(){
    userDefaults.set(true, forKey: "onboarded")
    userDefaults.synchronize()
}

func getFavouriteGamesFromUserDefault(){
    favouriteGames.removeAll()
    let allFavouritesFromUserDefaults: [Int] = userDefaults.object(forKey: "favourites") as? [Int] ?? []
    for i in allFavouritesFromUserDefaults{
        favouriteGames.append(i)
    }
}

func setFavouriteGamesToUserDefault(){
    userDefaults.set(favouriteGames, forKey: "favourites")
    userDefaults.synchronize()
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
}


@discardableResult func saveImage(image: UIImage, name: String, savingName : String?) -> Bool {
    guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
        return false
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return false
    }
    do {
        var nameToAdd = name
        nameToAdd += savingName ?? ""
        nameToAdd += ".png"
        try data.write(to: directory.appendingPathComponent(nameToAdd)!)
        return true
    } catch {
        print(error.localizedDescription)
        return false
    }
}
