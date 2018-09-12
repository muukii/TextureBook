//
//  CornerRoundingNode.swift
//  TextureBook
//
//  Created by muukii on 9/12/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit

import AsyncDisplayKit

open class CornerRoundingNode<D: ASDisplayNode>: ASDisplayNode {

  public let embedNode: D
  private let _cornerRadius: CGFloat
  private let _cornerRoundingColor: UIColor
  private let _overlayNode = ASImageNode()
  private let has1pxSemitransparentGrayColorBorder: Bool

  private let borderLayerNode = ASDisplayNode.init { CAShapeLayer() }

  private var borderLayer: CAShapeLayer {
    return borderLayerNode.layer as! CAShapeLayer
  }

  @available(*, unavailable, message: "Don't touch me")
  open override var cornerRadius: CGFloat {
    didSet {

    }
  }

  open var roundingBorderColor: UIColor = .clear {
    didSet {
      updateBorder()
    }
  }

  open var roundingBorderWidth: CGFloat = 0 {
    didSet {
      updateBorder()
    }
  }

  public init(
    embedNode: D,
    cornerRoundingColor: UIColor,
    cornerRadius: CGFloat,
    has1pxSemitransparentGrayColorBorder: Bool = false
    ) {

    self.embedNode = embedNode
    self._cornerRoundingColor = cornerRoundingColor
    self._cornerRadius = cornerRadius
    self.has1pxSemitransparentGrayColorBorder = has1pxSemitransparentGrayColorBorder

    super.init()

    _overlayNode.isLayerBacked = true

    addSubnode(embedNode)
    addSubnode(borderLayerNode)
    addSubnode(_overlayNode)

    let key = "\(_cornerRadius):\(cornerRoundingColor), border:\(self.has1pxSemitransparentGrayColorBorder)" as NSString

    if let cachedImage = Static.cache.object(forKey: key) {
      _overlayNode.image = cachedImage
    } else {
      let renderedImage = CornerRoundingNode.createCircleMaskImage(fillColor: _cornerRoundingColor, cornerRadius: _cornerRadius, has1pxSemitransparentGrayColorBorder: self.has1pxSemitransparentGrayColorBorder)

      let inset = renderedImage.size.width / 2

      let resizableImage = renderedImage.resizableImage(withCapInsets: .init(
        top: inset,
        left: inset,
        bottom: inset,
        right: inset
        )
      )

      _overlayNode.image = resizableImage
      Static.cache.setObject(resizableImage, forKey: key)
    }
  }

  open override func layoutDidFinish() {
    super.layoutDidFinish()
    updateBorder()
  }

  open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    return
      ASOverlayLayoutSpec(
        child: embedNode,
        overlay: ASWrapperLayoutSpec(
          layoutElements: [
            borderLayerNode,
            _overlayNode,
            ]
        )
    )
  }

  private func updateBorder() {

    guard roundingBorderWidth > 0 else {
      borderLayer.path = nil
      clipsToBounds = false
      return
    }

    clipsToBounds = true

    let path = CornerRoundingNode.createBorderPath(
      rect: bounds,
      cornerRadius: _cornerRadius,
      lineWidth: roundingBorderWidth
    )

    borderLayer.path = path
    borderLayer.lineWidth = roundingBorderWidth * 2 // make double. Because border will be rendered on center line.
    borderLayer.strokeColor = roundingBorderColor.cgColor
    borderLayer.fillColor = UIColor.clear.cgColor
  }

  private static func createBorderPath(rect: CGRect, cornerRadius: CGFloat, lineWidth: CGFloat) -> CGPath {

    let path = UIBezierPath(
      roundedRect: rect,
      cornerRadius: cornerRadius
    )

    return path.cgPath
  }

  private static func createCircleMaskImage(fillColor: UIColor, cornerRadius: CGFloat, has1pxSemitransparentGrayColorBorder: Bool) -> UIImage {

    let scale = UIScreen.main.scale

    let __cornerRadius = cornerRadius * scale
    let __width = __cornerRadius * 2
    let __height = __cornerRadius * 2

    let imageSize = CGSize(width: __width, height: __height )

    UIGraphicsBeginImageContextWithOptions(imageSize, false, 1)

    guard let context = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return UIImage()
    }

    if let layer = CGLayer(context, size: imageSize, auxiliaryInfo: nil),
      let layerContext = layer.context {

      UIGraphicsPushContext(layerContext)

      let rectPath = UIBezierPath(rect: CGRect(origin: .zero, size: imageSize))
      fillColor.setFill()
      rectPath.fill()

      let circlePath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize), cornerRadius: __cornerRadius)
      layerContext.setBlendMode(.clear)
      UIColor.clear.setFill()
      circlePath.fill()

      if has1pxSemitransparentGrayColorBorder {
        let lineWidth: CGFloat = 1
        let borderRect = CGRect(origin: .zero, size: imageSize).insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let borderLine = UIBezierPath(roundedRect: borderRect, cornerRadius: __cornerRadius - lineWidth)

        layerContext.setBlendMode(.normal)
        UIColor(white: 0, alpha: 0.05).setStroke()
        borderLine.lineWidth = lineWidth
        borderLine.stroke(with: .hue, alpha: 1)
      }

      UIGraphicsPopContext()

      context.draw(layer, at: .zero)
    }

    let image = UIGraphicsGetImageFromCurrentImageContext()
      .flatMap { $0.cgImage }
      .map {
        UIImage(cgImage: $0, scale: scale, orientation: .up)
          .resizableImage(withCapInsets: .zero, resizingMode: .stretch)
    }

    UIGraphicsEndImageContext()
    let _image = image ?? UIImage()

    return _image
  }
}

fileprivate enum Static {
  static let cache = NSCache<NSString, UIImage>()
}
