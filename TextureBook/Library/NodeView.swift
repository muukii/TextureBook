//
//  NodeView.swift
//  TextureBook
//
//  Created by muukii on 9/9/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit
import AsyncDisplayKit

// NodeView port from Pairs Global
open class NodeView<D: ASDisplayNode>: UIView {

  // MARK: - Properties

  public let wrappedNode: D
  private let wrapperNode: WrapperNode

  public var prefferedMaxLayoutWidth: CGFloat?

  open override var intrinsicContentSize: CGSize {

    var range = ASSizeRangeUnconstrained

    if let maxWidth = prefferedMaxLayoutWidth {
      range.min.width = maxWidth
      range.max.width = maxWidth
    }

    let r = wrapperNode.layoutThatFits(range)
    return r.size
  }

  // MARK: - Initializers

  public init(wrappedNode: D, frame: CGRect = .zero) {

    self.wrappedNode = wrappedNode
    self.wrapperNode = WrapperNode(embedNode: wrappedNode)

    super.init(frame: frame)
    addSubnode(wrapperNode)

    wrapperNode.calculatedLayoutDidChangeHandler = { [weak self] in
      self?.invalidateIntrinsicContentSize()
    }

    wrapperNode.layoutDidFinishHandler = { [weak self] in
      self?.invalidateIntrinsicContentSize()
    }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Functions

  open override func layoutSubviews() {

    super.layoutSubviews()

    wrapperNode.frame = bounds
  }
}

private class WrapperNode : ASDisplayNode {

  var calculatedLayoutDidChangeHandler: () -> Void = {}
  var layoutDidFinishHandler: () -> Void = {}

  let embedNode: ASDisplayNode

  init(embedNode: ASDisplayNode) {

    self.embedNode = embedNode

    super.init()
    addSubnode(embedNode)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASWrapperLayoutSpec(layoutElement: embedNode)
  }

  override func calculatedLayoutDidChange() {
    super.calculatedLayoutDidChange()
    calculatedLayoutDidChangeHandler()
  }

  override func layoutDidFinish() {
    super.layoutDidFinish()
    layoutDidFinishHandler()
  }

  override func layout() {
    super.layout()
  }
}
