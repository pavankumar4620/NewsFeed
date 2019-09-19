//
//  LoadingCell.swift
//  NewsFeed
//
//  Created by Gamenexa_iOS3 on 19/09/19.
//  Copyright © 2019 Gamenexa_iOS3. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
