//
//  PeopleViewController.swift
//  iTindr
//
//  Created by Vladislav on 02.05.2022.
//

import UIKit

class PeopleViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let reuseIdentifier = "UserCell"
    var overlay: UIView? = nil

    var totalPage: Int = 0
    var currentPage: Int = 0
    var profiles: [ProfileData] = [ProfileData]()
    let pageSize: Int = 20

    func fetchData(page: Int) {
        showOverlay()
        UserActions.getUsers(limit: pageSize, offset: page * pageSize,
                successCallback:
                { data in
                    self.profiles.append(contentsOf: data)
                    self.collectionView.reloadData()
                    self.hideOverlay()
                }, errorCallBack:
        {
        })
    }

    func setupView() {
        collectionView.collectionViewLayout = generateLayout()
        overlay = Overlay.getOverlay(view: view)
        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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
        fetchData(page: 0)
    }
}


extension PeopleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = profiles[indexPath.row]
        cell.setupCell(profile: user)

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == profiles.count - 1 {
            currentPage = currentPage + 1
            fetchData(page: currentPage)
        }
    }

    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1 / 3),
                heightDimension: .fractionalHeight(1.0))

        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
                top: 5,
                leading: 5,
                bottom: 5,
                trailing: 5)

        let central = NSCollectionLayoutItem(layoutSize: itemSize)
        central.contentInsets = NSDirectionalEdgeInsets(
                top: 5,
                leading: 5,
                bottom: 5,
                trailing: 5)
        central.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(0),
                top: .fixed(70),
                trailing: .fixed(0),
                bottom: .fixed(0))

        //2
        let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(1 / 3)),

                subitems: [fullPhotoItem, central, fullPhotoItem]
        )

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
