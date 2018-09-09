//
//  StackScrollNode.swift
//  TextureBook
//
//  Created by muukii on 9/9/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit
import AsyncDisplayKit

open class StackScrollNode : ASDisplayNode {

  open var scrollViewDidScroll: (_ scrollView: UIScrollView) -> Void = { _ in }
  open var scrollViewDidEndDecelerating: (_ scrollView: UIScrollView) -> Void = { _ in }
  open var scrollViewDidEndDragging: (_ scrollView: UIScrollView, _ willDecelerate: Bool) -> Void = { _, _ in }

  open var shouldWaitUntilAllUpdatesAreCommitted: Bool = false

  open var isScrollEnabled: Bool {
    get {
      return collectionNode.view.isScrollEnabled
    }
    set {
      collectionNode.view.isScrollEnabled = newValue
    }
  }

  open var scrollView: UIScrollView {
    return collectionNode.view
  }

  open var collectionViewLayout: UICollectionViewLayout {
    return collectionNode.view.collectionViewLayout
  }

  open private(set) var nodes: [ASCellNode] = []

  /// It should not be accessed unless there is special.
  internal let collectionNode: ASCollectionNode

  public init(layout: UICollectionViewFlowLayout) {

    collectionNode = ASCollectionNode(collectionViewLayout: layout)
    collectionNode.backgroundColor = .clear

    super.init()
  }

  public override convenience init() {

    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.sectionInset = .zero

    self.init(layout: layout)
  }

  open func append(nodes: [ASCellNode]) {

    self.nodes += nodes

    collectionNode.reloadData()
    if shouldWaitUntilAllUpdatesAreCommitted {
      collectionNode.waitUntilAllUpdatesAreProcessed()
    }
  }

  open func removeAll() {
    self.nodes = []

    collectionNode.reloadData()
    if shouldWaitUntilAllUpdatesAreCommitted {
      collectionNode.waitUntilAllUpdatesAreProcessed()
    }
  }

  open func replaceAll(nodes: [ASCellNode]) {

    self.nodes = nodes

    collectionNode.reloadData()
    if shouldWaitUntilAllUpdatesAreCommitted {
      collectionNode.waitUntilAllUpdatesAreProcessed()
    }
  }

  open override func didLoad() {

    super.didLoad()

    addSubnode(collectionNode)

    collectionNode.delegate = self
    collectionNode.dataSource = self
    collectionNode.view.alwaysBounceVertical = true
  }

  open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    return ASWrapperLayoutSpec(layoutElement: collectionNode)
  }
}

extension StackScrollNode: ASCollectionDelegate {

  public func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {

    return ASSizeRange(
      min: .init(width: collectionNode.bounds.width, height: 0),
      max: .init(width: collectionNode.bounds.width, height: .infinity)
    )
  }

  open func scrollViewDidScroll(_ scrollView: UIScrollView) {

    scrollViewDidScroll(scrollView)
  }

  open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    scrollViewDidEndDecelerating(scrollView)
  }

  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    scrollViewDidEndDragging(scrollView, decelerate)
  }
}

extension StackScrollNode: ASCollectionDataSource {
  open var numberOfSections: Int {
    return 1
  }

  public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {

    return nodes.count
  }

  public func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
    return nodes[indexPath.item]
  }
}
