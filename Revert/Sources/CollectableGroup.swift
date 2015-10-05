//
//  Copyright (c) 2015 Itty Bitty Apps. All rights reserved.
//

import Foundation

private enum Attributes: String {
  case Title = "title"
  case Rows = "rows"
}

struct CollectableGroup<I: Collectable>: Collection {
  typealias T = I

  let items: [I]
  let title: String?

  init(dictionary: [String: AnyObject]) {
    guard let rowsData = dictionary[Attributes.Rows.rawValue] as? [[String: AnyObject]] else {
      fatalError("Unable to deserialize Group rows")
    }

    self.title = dictionary[Attributes.Title.rawValue] as? String
    self.items = rowsData.map { I(dictionary: $0) }
  }
}

