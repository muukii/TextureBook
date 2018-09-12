//
//  InlineCellNode.swift
//  TextureBook
//
//  Created by muukii on 9/12/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class InlineCellNode : ASCellNode {

  init(_ setup: (InlineCellNode) -> Void) {
    super.init()
    setup(self)
  }
}
