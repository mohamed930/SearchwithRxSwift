//
//  Cell.swift
//  SearchTableView
//
//  Created by Mohamed Ali on 18/07/2021.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserStatusLabel: UILabel!
    @IBOutlet weak var UserImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func ConfigureCell(_ User: UserModel) {
        UserNameLabel.text = User.UserName
        UserImageView.image = UIImage(named: User.UserImage)
        UserStatusLabel.text = User.UserStatus
    }

}
