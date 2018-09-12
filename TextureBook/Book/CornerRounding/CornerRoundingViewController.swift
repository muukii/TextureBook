//
//  CornerRoundingViewController.swift
//  TextureBook
//
//  Created by muukii on 9/11/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import EasyPeasy

final class CornerRoundingViewController : CodeBasedViewController {

  private let stackScrollNode = StackScrollNode()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubnode(stackScrollNode)
    stackScrollNode.view.easy.layout(Edges())
    stackScrollNode.collectionNode.view.delaysContentTouches = false

    view.backgroundColor = .white

    stackScrollNode.append(nodes: [
      InlineCellNode { node in
        let n = PrecompositeNode()
        node.addSubnode(n)

        node.layoutSpecBlock = { _, _ in

          n.style.preferredSize = CGSize(width: 60, height: 60)
          return ASInsetLayoutSpec(
            insets: .init(top: 32, left: .infinity, bottom: 32, right: .infinity),
            child: n
          )

        }
      },
      InlineCellNode { node in
        let n = ClippingNode()
        node.addSubnode(n)

        node.layoutSpecBlock = { _, _ in

          n.style.preferredSize = CGSize(width: 60, height: 60)
          return ASInsetLayoutSpec(
            insets: .init(top: 32, left: .infinity, bottom: 32, right: .infinity),
            child: n
          )

        }
      },
      InlineCellNode { node in
        let n = CustomClippingNode()
        node.addSubnode(n)

        node.layoutSpecBlock = { _, _ in

          n.style.preferredSize = CGSize(width: 60, height: 60)
          return ASInsetLayoutSpec(
            insets: .init(top: 32, left: .infinity, bottom: 32, right: .infinity),
            child: n
          )

        }
      },
      InlineCellNode { node in
        let n = Custom2ClippingNode()
        node.addSubnode(n)

        node.layoutSpecBlock = { _, _ in

          n.style.preferredSize = CGSize(width: 60, height: 60)
          return ASInsetLayoutSpec(
            insets: .init(top: 32, left: .infinity, bottom: 32, right: .infinity),
            child: n
          )

        }
      }
      ])

  }
}

extension CornerRoundingViewController {

  class BaseNode : ASDisplayNode {

    override func didLoad() {
      super.didLoad()

      let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))

      view.addGestureRecognizer(tap)
    }

    @objc private dynamic func didTap() {
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 0.0,
        options: [.allowUserInteraction],
        animations: {
          self.view.transform = .init(scaleX: 0.9, y: 0.9)
//          self.transform = CATransform3DMakeScale(0.9, 0.9, 1)
      },
        completion: { _ in
          UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.0,
            options: [.allowUserInteraction],
            animations: {
              self.view.transform = .identity
//              self.transform = CATransform3DIdentity
          },
            completion: nil
          )
      })
    }
  }

  final class PrecompositeNode : BaseNode {

    private let innerNode = ASImageNode()

    override init() {
      super.init()

//      innerNode.isLayerBacked = true
      innerNode.image = UIImage(named: "sample")

      addSubnode(innerNode)
      innerNode.backgroundColor = .clear
      innerNode.cornerRoundingType = .precomposited
      innerNode.cornerRadius = 10

    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      return ASWrapperLayoutSpec(layoutElement: innerNode)
    }


  }

  final class ClippingNode : BaseNode {

    final class _ClippingNode : ASDisplayNode {

      private let innerNode = ASImageNode()

      override init() {
        super.init()

        addSubnode(innerNode)
        isLayerBacked = true
        backgroundColor = .white
        cornerRoundingType = .clipping
        cornerRadius = 10

        innerNode.image = UIImage(named: "sample")
      }

      override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        return ASWrapperLayoutSpec(layoutElement: innerNode)
      }

    }

    private let innerNode = _ClippingNode()

    override init() {
      super.init()

      addSubnode(innerNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      return ASWrapperLayoutSpec(layoutElement: innerNode)
    }
  }

  final class CustomClippingNode : BaseNode {

    private let innerNode = ClippingCornerRoundingNode<ASImageNode>(embedNode: ASImageNode(), cornerRoundingColor: .white, cornerRadius: 10)

    override init() {
      super.init()

      innerNode.embedNode.image = UIImage(named: "sample")
      addSubnode(innerNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      return ASWrapperLayoutSpec(layoutElement: innerNode)
    }
  }

  final class Custom2ClippingNode : BaseNode {

    private let innerNode = CornerRoundingNode<ASImageNode>(embedNode: ASImageNode(), cornerRoundingColor: .white, cornerRadius: 10)

    override init() {
      super.init()

      innerNode.embedNode.image = UIImage(named: "sample")
      addSubnode(innerNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      return ASWrapperLayoutSpec(layoutElement: innerNode)
    }
  }
}


