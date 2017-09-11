//
//  PhotoTableCell.swift
//  Tumblr
//
//  Created by Syed Hakeem Abbas on 9/9/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class PhotoTableCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
