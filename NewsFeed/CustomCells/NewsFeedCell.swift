//
//  NewsFeedCell.swift
//  NewsFeed
//
//  Created by Gamenexa_iOS3 on 18/09/19.
//  Copyright © 2019 Gamenexa_iOS3. All rights reserved.
//

import UIKit

class NewsFeedCell: UITableViewCell {

    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var picImgView: UIImageView!
    
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var likesLbl: UILabel!
    
    @IBOutlet weak var comtLbl: UILabel!
    
    @IBOutlet weak var shareLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.masksToBounds = false
        bgView.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
