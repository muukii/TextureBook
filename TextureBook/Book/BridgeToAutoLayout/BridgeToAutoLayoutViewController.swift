//
//  BridgeToAutoLayoutViewController.swift
//  TextureBook
//
//  Created by muukii on 9/9/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit

import AsyncDisplayKit
import TypedTextAttributes
import EasyPeasy

final class BridgeToAutoLayoutViewController : UIViewController {

  private let changeTextButton = UIButton(type: .system)
  private let nodeView = NodeView(wrappedNode: ComponentNode())

  override func viewDidLoad() {
    super.viewDidLoad()

    changeTextButton.setTitle("Change Text", for: .normal)

    view.backgroundColor = .appWhite
    view.addSubview(changeTextButton)
    view.addSubview(nodeView)

    changeTextButton.easy.layout([
      CenterX(),
      Bottom(32).to(view.safeAreaLayoutGuide, .bottom)
      ])

    nodeView.easy.layout([
      Top(32).to(view.safeAreaLayoutGuide, .top),
      CenterX(),
      Left(>=32),
      Right(<=32),
      Bottom(<=0).to(changeTextButton, .top),
      ])

    changeTextButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
  }

  @objc
  private dynamic func didTap() {

    nodeView.wrappedNode.set(text: Lorem.ipsum(Int(arc4random_uniform(50) + 10)))
  }
}

extension BridgeToAutoLayoutViewController {

  private final class ComponentNode : ASDisplayNode {

    private let textNode = ASTextNode()

    override init() {
      super.init()

      backgroundColor = .appGray003
      automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      return ASInsetLayoutSpec(
        insets: .init(top: 8, left: 8, bottom: 8, right: 8),
        child: textNode
      )
    }

    func set(text: String) {

      textNode.attributedText = text.attributed {
        TextAttributes()
          .font(UIFont.preferredFont(forTextStyle: .headline))
          .foregroundColor(.appNavy001)
      }
    }
  }
}
