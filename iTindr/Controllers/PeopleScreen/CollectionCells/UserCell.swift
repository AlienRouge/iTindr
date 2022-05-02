//
//  UserCell.swift
//  iTindr
//
//  Created by Vladislav on 02.05.2022.
//

import UIKit

class UserCell: UICollectionViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var profileData: ProfileData? = nil

    func setupCell(profile: ProfileData) {
        profileData = profile
        userName.text = profile.name
        userImage.layoutIfNeeded()
        userImage.layer.cornerRadius = frame.size.width / 2.8
        userImage.clipsToBounds = true

        if let url = URL(string: profile.avatar ?? "") {
            if let data = try? Data(contentsOf: url) {
                userImage.image = UIImage(data: data)!
                return
            }
        }

        userImage.image = UIImage(named: "ProfilePlaceholder")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
