//
//  ViewController.swift
//  TextureBook
//
//  Created by muukii on 9/8/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit

import AsyncDisplayKit
import TypedTextAttributes
import EasyPeasy

final class ViewController: UIViewController {

  private let stackScrollNode = StackScrollNode()

  override func viewDidLoad() {
    super.viewDidLoad()

    // This is like `view.addSubview(stackScrollNode.view)`
    view.addSubnode(stackScrollNode)
    stackScrollNode.view.easy.layout(Edges())
    stackScrollNode.collectionNode.view.delaysContentTouches = false

    stackScrollNode.append(nodes: [
      CellNode(title: "ListViewController", detail: "UIKit") { [unowned self] in
        let storyboard = UIStoryboard(name: "ListViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ListViewController")
        self.navigationController?.pushViewController(controller, animated: true)
        
      },
      CellNode(title: "AsyncListViewController", detail: "Texture") { [unowned self] in
        let c = AsyncListViewController()
        self.navigationController?.pushViewController(c, animated: true)
      },
      CellNode(title: "BridgeToAutoLayoutViewController", detail: "Texture") { [unowned self] in
        let c = BridgeToAutoLayoutViewController()
        self.navigationController?.pushViewController(c, animated: true)
      },
      CellNode(title: "CardView", detail: "Texture") { [unowned self] in
        let c = SingleCardViewController()
        self.navigationController?.pushViewController(c, animated: true)
      },
      CellNode(title: "CardListView", detail: "Texture") { [unowned self] in
        let c = CardListViewController()
        self.navigationController?.pushViewController(c, animated: true)
      },
      CellNode(title: "CornerRounding", detail: "Texture") { [unowned self] in
        let c = CornerRoundingViewController()
        self.navigationController?.pushViewController(c, animated: true)
      },
      
      ])
  }

}

extension ViewController {

  private final class OnePixelHorizontalSeparatorNode : ASCellNode {

    private let separator: ASDisplayNode = .init()

    override init() {
      super.init()
      addSubnode(separator)
    }

    override var backgroundColor: UIColor? {
      get {
        return separator.backgroundColor
      }
      set {
        separator.backgroundColor = newValue
      }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      let scale = UIScreen.main.scale
      let onePixel = 1 / scale

      separator.style.height = .init(unit: .points, value: onePixel)

      return
        ASInsetLayoutSpec(
          insets: .init(top: onePixel / scale, left: 0, bottom: 0, right: 0),
          child: separator
      )

    }

  }

  private final class CellNode : ASCellNode {

    private let titleNode: ASTextNode = .init()
    private let detailNode: ASTextNode = .init()
    private let separator: OnePixelHorizontalSeparatorNode = .init()
    private let _didTap: () -> Void

    init(title: String, detail: String, didTap: @escaping () -> Void) {

      self._didTap = didTap

      super.init()

      automaticallyManagesSubnodes = true
      backgroundColor = .white

      titleNode.attributedText = title.attributed {
        TextAttributes()
          .font(UIFont.preferredFont(forTextStyle: .headline))
      }

      detailNode.attributedText = detail.attributed {
        TextAttributes()
          .font(UIFont.preferredFont(forTextStyle: .caption1))
      }

      separator.backgroundColor = UIColor(white: 0, alpha: 0.05)
    }

    override var isHighlighted: Bool {
      didSet {
        UIView.animate(
          withDuration: 0.2,
          delay: 0,
          options: [.beginFromCurrentState],
          animations: {

            if self.isHighlighted {
              self.backgroundColor = UIColor(white: 0.96, alpha: 1)
            } else {
              self.backgroundColor = .white
            }

        }, completion: nil)
      }
    }

    override func didLoad() {
      super.didLoad()

      let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
      view.addGestureRecognizer(tap)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

      let space = ASLayoutSpec()
      space.style.height = .init(unit: .points, value: 8)

      let body = ASStackLayoutSpec(
        direction: .vertical,
        spacing: 0,
        justifyContent: .start,
        alignItems: .start,
        children: [
          titleNode,
          space,
          detailNode,
        ]
      )

      return
        ASStackLayoutSpec(
          direction: .vertical,
          spacing: 0,
          justifyContent: .start,
          alignItems: .stretch,
          children: [
            ASInsetLayoutSpec(
              insets: .init(top: 20, left: 20, bottom: 20, right: 20),
              child: body
            ),
            separator
          ]
      )

    }

    @objc
    private dynamic func didTap() {
      self._didTap()
    }

  }
}
