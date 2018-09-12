//
//  AsyncListViewController.swift
//  TextureBook
//
//  Created by muukii on 9/9/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit

import AsyncDisplayKit
import TextAttributes
import EasyPeasy

//class MyListViewController : UIViewController {
//
//  let collectionNode: ASCollectionNode!
//
//  override func viewDidLoad() {
//
//    let collectionView = collectionNode.view
//
//    view.addSubview(collectionView)
//
//    // Setup AutoLayout to CollectionView
//
//  }
//}
//
//extension MyListViewController :
//  ASCollectionDataSource,
//  ASCollectionDelegateFlowLayout
//{
//
//  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
//
//
//  }
//
//}

final class AsyncListViewController : UIViewController {

  private let collectionNode: ASCollectionNode = {

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    let node = ASCollectionNode(collectionViewLayout: layout)

    return node
  }()

  private let items = DummyModel.preset

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionNode.view)
    collectionNode.view.easy.layout(Edges())
    collectionNode.delegate = self
    collectionNode.dataSource = self

  }
}

extension AsyncListViewController : ASCollectionDataSource, ASCollectionDelegateFlowLayout {

  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {

    let model = items[indexPath.item]

    return {
      CellNode(model: model)
    }
  }

  func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
    return ASSizeRange(
      min: CGSize(width: collectionNode.bounds.width, height: 0),
      max: CGSize(width: collectionNode.bounds.width, height: .infinity)
    )
  }

}

extension AsyncListViewController {

  private final class CellNode : ASCellNode {

    private let imageContainerNode = ASDisplayNode()
    private let text1Node = ASTextNode()
    private let text2Node = ASTextNode()
    private let button1Node = ASDisplayNode()
    private let button2Node = ASDisplayNode()
    private let button3Node = ASDisplayNode()
    private let topRightNode = ASDisplayNode()

    init(model: DummyModel) {
      super.init()
      automaticallyManagesSubnodes = true

      imageContainerNode.backgroundColor = .appGray003
      button1Node.backgroundColor = .appGray003
      button2Node.backgroundColor = .appGray003
      button3Node.backgroundColor = .appGray003
      topRightNode.backgroundColor = .appGray002

      text1Node.attributedText = model.text1.attributed {
        TextAttributes()
          .font(UIFont.preferredFont(forTextStyle: .body))
          .foregroundColor(.appNavy001)
      }

      text2Node.attributedText = model.text2.attributed {
        TextAttributes()
          .font(UIFont.preferredFont(forTextStyle: .body))
          .foregroundColor(.appNavy001)
      }

    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      button1Node.style.preferredSize = CGSize(width: 36, height: 36)
      button2Node.style.preferredSize = CGSize(width: 36, height: 36)
      button3Node.style.preferredSize = CGSize(width: 36, height: 36)
      topRightNode.style.preferredSize = CGSize(width: 44, height: 44)

      return
        ASStackLayoutSpec(
          direction: .vertical,
          spacing: 0,
          justifyContent: .start,
          alignItems: .stretch,
          children: [
            ASOverlayLayoutSpec(
              child: ASRatioLayoutSpec(
                ratio: 1,
                child: imageContainerNode
              ),
              overlay: ASInsetLayoutSpec(
                insets: .init(top: 8, left: .infinity, bottom: .infinity, right: 8),
                child: topRightNode
              )
            ),
            ASInsetLayoutSpec(
              insets: .init(top: 16, left: 20, bottom: 0, right: 20),
              child: ASStackLayoutSpec(
                direction: .horizontal,
                spacing: 8,
                justifyContent: .start,
                alignItems: .start,
                children: [
                  button1Node,
                  button2Node,
                  button3Node,
                  ]
              )
            ),
            ASInsetLayoutSpec(
              insets: .init(top: 8, left: 20, bottom: 0, right: 20),
              child: text1Node
            ),
            ASInsetLayoutSpec(
              insets: .init(top: 8, left: 20, bottom: 20, right: 20),
              child: text2Node
            ),
          ]
      )

    }

  }
}
