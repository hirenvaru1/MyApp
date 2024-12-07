//
//  songListCell.swift
//  MyApp
//
//  Created by Hiren Varu on 07/12/24.
//

import UIKit

class songListCell: UITableViewCell {
 
    @IBOutlet weak var imgIcon : UIImageView!
    @IBOutlet weak var lblAlbumName : UILabel!
    @IBOutlet weak var lblSubName : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
