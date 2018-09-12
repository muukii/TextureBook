//
//  CornerRoundingNode.swift
//  TextureBook
//
//  Created by muukii on 9/12/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit
import AsyncDisplayKit

open class ClippingCornerRoundingNode<D: ASDisplayNode>: ASDisplayNode {

  public let embedNode: D

  private let borderLayerNode = ASDisplayNode.init { CAShapeLayer() }

  private var borderLayer: CAShapeLayer {
    return borderLayerNode.layer as! CAShapeLayer
  }

  @available(*, unavailable)
  open override var cornerRoundingType: ASCornerRoundingType {
    didSet {}
  }

  open var roundingBorderColor: UIColor = .clear {
    didSet {
      //      updateBorder()
    }
  }

  open var roundingBorderWidth: CGFloat = 0 {
    didSet {
      //      updateBorder()
    }
  }

  public init(
    embedNode: D,
    cornerRoundingColor: UIColor,
    cornerRadius: CGFloat
    ) {

    self.embedNode = embedNode

    super.init()

//    self.isLayerBacked = true
//    self.backgroundColor = cornerRoundingColor
//    super.cornerRoundingType = .clipping
//    self.cornerRadius = cornerRadius

    embedNode.backgroundColor = .red
  }

  open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    return ASWrapperLayoutSpec(layoutElement: embedNode)
  }
}
