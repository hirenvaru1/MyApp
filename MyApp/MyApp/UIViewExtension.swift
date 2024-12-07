//
//  UIViewExtension.swift
//  MyApp
//
//  Created by Hiren Varu on 07/12/24.
//

import UIKit

extension UIView {
        @IBInspectable var cornerRadius:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var Round:Bool {
        set {
            self.layer.cornerRadius = self.frame.size.height / 2.0
            self.clipsToBounds = true
        }
        get {
            self.clipsToBounds = true
            return self.layer.cornerRadius == self.frame.size.height / 2.0
        }
    }
    
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
}

extension UIViewController{
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
} 

func saveLibraryDataToUserDefaults(libraryData: AllYourLibrary) {
    let encoder = JSONEncoder()
    do {
        let encodedData = try encoder.encode(libraryData)
        UserDefaults.standard.set(encodedData, forKey: "AllYourLibraryData")
    } catch {
        print("Failed to save data to UserDefaults: \(error)")
    }
}

func loadLibraryDataFromUserDefaults() -> AllYourLibrary? {
    if let savedData = UserDefaults.standard.data(forKey: "AllYourLibraryData") {
        let decoder = JSONDecoder()
        do {
            let decodedLibrary = try decoder.decode(AllYourLibrary.self, from: savedData)
            return decodedLibrary
        } catch {
            print("Failed to decode data: \(error)")
        }
    }
    return nil
}
