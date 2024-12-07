//
//  popView.swift
//  MyApp
//
//  Created by Hiren Varu on 07/12/24.
//

import UIKit

class popView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     }
    
    //MARK: - Button Action
    @IBAction func hidePopUp(_ sender: UIButton){
        dismiss(animated: true)        
    } 
    
    @IBAction func createClickes(_ sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreatePlaylistPopup") as! CreatePlaylistPopup
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
