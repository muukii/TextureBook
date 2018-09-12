//
//  SingleCardViewController.swift
//  TextureBook
//
//  Created by muukii on 9/11/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit
import AsyncDisplayKit

final class SingleCardViewController : CodeBasedViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    let node = CardNode(
      image: UIImage(named: "sample")!,
      title: "Lorem Ipsum",
      detail: "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
    )

    let layout = node.layoutThatFits(
      ASSizeRange(
        min: .init(width: 0.0, height: 250),
        max: .init(width: 240.0, height: .infinity)
      )
    )

    view.addSubview(node.view)

    node.frame.size = layout.size

    node.view.center.x = view.bounds.midX
    node.view.center.y = view.bounds.midY

  }
}

extension SingleCardViewController {

  final class CardNode : ASDisplayNode {

    private let imageNode: ASImageNode = .init()
    private let titleNode: ASTextNode = .init()
    private let detailNode: ASTextNode = .init()

    init(image: UIImage, title: String, detail: String) {

      super.init()

      backgroundColor = UIColor(white: 0, alpha: 0.02)

      titleNode.attributedText = NSAttributedString(
        string: title,
        attributes: [
          .font : UIFont.preferredFont(forTextStyle: .headline),
          .foregroundColor : UIColor.appNavy001,
          ]
      )

      detailNode.attributedText = NSAttributedString(
        string: detail,
        attributes: [
          .font : UIFont.preferredFont(forTextStyle: .subheadline),
          .foregroundColor : UIColor.appNavy001,
          ]
      )

      imageNode.image = image

      automaticallyManagesSubnodes = true

    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      let imageSpec = ASRatioLayoutSpec(
        ratio: 1,
        child: imageNode
      )
      
      let body = ASStackLayoutSpec(
        direction: .vertical,
        spacing: 8,
        justifyContent: .end,
        alignItems: .start,
        children: [
          imageSpec,
          titleNode,
          detailNode
        ]
      )

      return
        ASInsetLayoutSpec(
          insets: .init(
            top: 8,
            left: 8,
            bottom: 8,
            right: 8
          ),
          child: body
      )
    }
  }
}
