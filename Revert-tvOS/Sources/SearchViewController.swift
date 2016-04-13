//
//  Copyright © 2016 Itty Bitty Apps. All rights reserved.

import UIKit

final class SearchViewController: UICollectionViewController {
  required init?(coder aDecoder: NSCoder) {
    self.dataSource = CollectionDataSource(
      collection: CollectableCollection<HomeItem>(items: .Home, flatten: true),
      configureCell: self.dynamicType.configureCell,
      cellIdentifier: Storyboards.Cell.HomeCollection
    )

    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.collectionView?.dataSource = self.dataSource
    self.collectionView?.remembersLastFocusedIndexPath = true
  }

  //MARK: Private

  private let dataSource: CollectionDataSource<HomeItem, HomeCollectionCell>

  private var searchText: String? {
    didSet {
      guard searchText != oldValue else {
        // We don't want to keep reloading contents if the search text has not changed.
        return
      }

      if let string = searchText where string.isEmpty == false {
        self.dataSource.filter({
          $0.title.localizedStandardContainsString(string)
        })
      } else {
        self.dataSource.filter(nil)
      }

      self.collectionView?.reloadData()
    }
  }
}

private extension SearchViewController {
  static func configureCell(cell: HomeCollectionCell, withItem item: HomeItem) {
    cell.titleLabel.text = item.title
    cell.imageView.image = UIImage(named: item.iconName)
  }
}

// MARK:- UICollectionViewDelegate

extension SearchViewController {
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let item = self.dataSource[indexPath]

    self.performSegueWithIdentifier(item.segueIdentifier, sender: indexPath)
  }
}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    self.searchText = searchController.searchBar.text
  }
}
