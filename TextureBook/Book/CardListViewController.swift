//
//  CardListViewController.swift
//  TextureBook
//
//  Created by muukii on 9/12/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit

import AsyncDisplayKit
import EasyPeasy

final class CardListViewController : UIViewController {

  struct Model {
    let image: UIImage
    let title: String
    let detail: String
  }

  private let collectionNode: ASCollectionNode = {

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    let node = ASCollectionNode(collectionViewLayout: layout)

    return node
  }()

  private let items: [Model] = [
    Model(image: UIImage(named: "sample")!, title: Lorem.ipsum(30), detail: Lorem.ipsum(30)),
    Model(image: UIImage(named: "sample")!, title: Lorem.ipsum(10), detail: Lorem.ipsum(309)),
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionNode.view)
    collectionNode.view.easy.layout(Edges())
    collectionNode.delegate = self
    collectionNode.dataSource = self

  }
}

extension CardListViewController : ASCollectionDataSource, ASCollectionDelegateFlowLayout {

  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {

    let item = items[indexPath.item]

    return {
      // Call on Background Thread
      CardNode.init(image: item.image, title: item.title, detail: item.detail)
    }
  }

  func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
    return ASSizeRange(
      min: CGSize(width: collectionNode.bounds.width, height: 0),
      max: CGSize(width: collectionNode.bounds.width, height: .infinity)
    )
  }

}

extension CardListViewController {
  final class CardNode : ASCellNode {

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
