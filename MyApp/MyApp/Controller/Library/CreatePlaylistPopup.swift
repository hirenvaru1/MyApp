//
//  CreatePlaylist.swift
//  MyApp
//
//  Created by Hiren Varu on 07/12/24.
//

import UIKit

class CreatePlaylistPopup: UIViewController {

    @IBOutlet weak var txtCreate : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCreate.becomeFirstResponder()
        txtCreate.placeholder = "My first library"
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        txtCreate.attributedPlaceholder = NSAttributedString(string: txtCreate.placeholder ?? "", attributes: attributes)
    }
    
    //MARK: - Button Action
    @IBAction func ConfirmClicked(_ sender: UIButton){
        if let text = txtCreate.text, !text.isEmpty {
            dismissToRoot(from: self)
            let userInfo: [String: Any] = ["playlistName": self.txtCreate.text ?? ""]
            NotificationCenter.default.post(name: Notification.Name("navigateToCreatePlaylist"), object: nil, userInfo: userInfo)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Please enter playlist name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

func dismissToRoot(from viewController: UIViewController) {
    if let presentingVC = viewController.presentingViewController {
        viewController.dismiss(animated: false) {
            dismissToRoot(from: presentingVC)
        }
    } 
}
