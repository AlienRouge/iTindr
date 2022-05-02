//import UIKit
//
//class TestVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//    @IBOutlet var collectionView: UICollectionView! {
//        didSet {
//            // Configure Collection View
//            collectionView.delegate = self
//            collectionView.dataSource = self
//
//            // Create Collection View Layout
//            collectionView.collectionViewLayout = createCollectionViewLayout()
//
//            // Register Episode Collection View Cell
//            let xib = UINib(nibName: EpisodeCollectionViewCell.nibName, bundle: .main)
//            collectionView.register(xib, forCellWithReuseIdentifier: EpisodeCollectionViewCell.reuseIdentifier)
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//
//}
