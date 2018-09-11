//
//  CornerRoundingViewController.swift
//  TextureBook
//
//  Created by muukii on 9/11/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit
import AsyncDisplayKit

final class CornerRoundingViewController : CodeBasedViewController {

  private let node = ContainerNode()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    node.frame = .init(x: 100, y: 100, width: 30, height: 30)
    node.cornerRadius = 10


    view.addSubnode(node)

  }
}

extension CornerRoundingViewController {

  final class ContainerNode : ASDisplayNode {

    private let innerNode = ASDisplayNode()

    override init() {
      super.init()

      addSubnode(innerNode)
      isLayerBacked = true
      backgroundColor = .white
      cornerRoundingType = .precomposited

      innerNode.backgroundColor = .appNavy001
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      return ASWrapperLayoutSpec(layoutElement: innerNode)
    }

  }
}


