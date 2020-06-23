//
//  ShareTableViewCell.swift
//  PDFPresenter
//
//  Created by Sam Ding on 3/20/20.
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import UIKit

class ShareTableViewCell: UITableViewCell {

    @IBOutlet weak var checkMark: UIImageView!
    var addedToShareList = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
