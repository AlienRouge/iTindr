import UIKit

class ChatListController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    private let reuseIdentifier = "ChatListItem"
    var overlay: UIView? = nil

    var chats: [ChatItem] = [ChatItem]()


    func setupView() {
        collectionView.collectionViewLayout = generateLayout()
        overlay = Overlay.getOverlay(view: view)
        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func fetchData() {
        showOverlay()
        UserActions.getChats(
                successCallback: { data in
                    print(data)
                    self.chats.append(contentsOf: data)
                    self.collectionView.reloadData()
                    self.hideOverlay()
                },
                errorCallBack: {
                    self.hideOverlay()
                })
    }

    func showOverlay() {
        if let controller = tabBarController {
            controller.view.addSubview(overlay!)
        } else {
            view.addSubview(overlay!)
        }
    }

    func hideOverlay() {
        overlay?.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatListItem
        let chat = chats[indexPath.row]
        cell.setupCell(chat: chat)

        return cell
    }

//    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == chats.count - 1 && lastFetchCount != 0 {
//            currentPage = currentPage + 1
//            fetchData(page: currentPage)
//        }
//    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let profile = profiles[indexPath.row]
//        Store.setCurrentUserProfile(profile: profile)
//
//        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
//        let nextVC = storyboard.instantiateViewController(identifier: "UserProfile")
//
//        show(nextVC, sender: self)
//    }

    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))

        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
                top: 5,
                leading: 10,
                bottom: 5,
                trailing: 5)


        let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(1 / 4)),
                subitem: fullPhotoItem,
                count: 1
        )

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


