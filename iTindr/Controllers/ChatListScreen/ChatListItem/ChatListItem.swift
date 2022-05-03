import UIKit

class ChatListItem: UICollectionViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    var chatData: ChatItem? = nil
    
    func setupCell(chat: ChatItem){
        chatData = chat
        if chat.chat.title == ""{
            title.text = "Name placeholder"
        }
        else{
            title.text = chat.chat.title
        }

        lastMessage.text = chat.lastMessage?.text ?? ""

        userImage.layoutIfNeeded()
        userImage.layer.cornerRadius = userImage.bounds.width / 2

        if let url = URL(string: chat.chat.avatar ?? "") {
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
