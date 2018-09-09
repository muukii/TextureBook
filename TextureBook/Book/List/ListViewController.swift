//
//  ListViewController.swift
//  TextureBook
//
//  Created by muukii on 9/9/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import UIKit

import TextAttributes

final class ListViewController : UIViewController {

  @IBOutlet private weak var collectionView: UICollectionView!

  private let items = DummyModel.preset

  override func viewDidLoad() {
    super.viewDidLoad()

    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize

    view.layoutIfNeeded()

    collectionView.dataSource = self
    collectionView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
}

extension ListViewController : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListCell
    let model = items[indexPath.item]

    cell.set(width: collectionView.bounds.width)
    cell.set(model: model)

    return cell
  }
}

extension ListViewController : UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .zero
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

final class ListCell : UICollectionViewCell {

  @IBOutlet private weak var imageContainerView: UIView!
  @IBOutlet private weak var label1: UILabel!
  @IBOutlet private weak var label2: UILabel!

  @IBOutlet private weak var button1: UIView!
  @IBOutlet private weak var button2: UIView!
  @IBOutlet private weak var button3: UIView!
  @IBOutlet private weak var topRightView: UIView!

  private var width: CGFloat?

  override func awakeFromNib() {
    super.awakeFromNib()

    imageContainerView.backgroundColor = UIColor.appGray003

    button1.backgroundColor = .appGray003
    button2.backgroundColor = .appGray003
    button3.backgroundColor = .appGray003

    topRightView.backgroundColor = .appGray002

    label1.numberOfLines = 0
    label2.numberOfLines = 0
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    label1.attributedText = nil
    label2.attributedText = nil
  }

  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

    guard let width = self.width else {
      return super.preferredLayoutAttributesFitting(layoutAttributes)
    }

    let targetSize = CGSize(width: width, height: UILayoutFittingCompressedSize.height)

    let size = contentView.systemLayoutSizeFitting(
      targetSize,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )

    layoutAttributes.frame.size = size

    return layoutAttributes
  }

  func set(model: DummyModel) {

    label1.attributedText = model.text1.attributed {
      TextAttributes()
        .font(UIFont.preferredFont(forTextStyle: .body))
        .foregroundColor(.appNavy001)
    }

    label2.attributedText = model.text2.attributed {
      TextAttributes()
        .font(UIFont.preferredFont(forTextStyle: .body))
        .foregroundColor(.appNavy001)
    }

    contentView.layoutIfNeeded()

  }

  func set(width: CGFloat) {
    self.width = width
  }
}
