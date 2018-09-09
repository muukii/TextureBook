//
//  Dummy.swift
//  TextureBook
//
//  Created by muukii on 9/9/18.
//  Copyright © 2018 muukii. All rights reserved.
//

import Foundation

struct DummyModel {

  let text1: String
  let text2: String

  static let preset: [DummyModel] = gen(count: 200)

  static func gen(count: Int) -> [DummyModel] {

    return
      (0..<count).map { _ in
        DummyModel(
          text1: Lorem.ipsum(Int(arc4random_uniform(21) + 10)),
          text2: Lorem.ipsum(Int(arc4random_uniform(200) + 10))
        )
    }
  }
}

// MARK: - Lorem
enum Lorem {
  // MARK: Public

  static func ipsum(_ length: Int) -> String {

    var string = lorem
    while string.count < length {

      string += ("\n" + lorem)
    }
    return String(string.prefix(length))
  }

  // MARK: Private
  private static let lorem: String = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sodales tristique elit et fringilla. Etiam eget justo non libero rhoncus placerat. Ut augue enim, gravida vitae consectetur ac, porta sit amet justo. Proin sed tristique dui. Vivamus at justo iaculis, dapibus tellus at, vestibulum arcu. Mauris et augue dictum ex rhoncus ultrices. Morbi ac diam eget leo consequat sodales. Phasellus sed luctus sem. Vestibulum sit amet dapibus nulla. Vivamus facilisis non dolor sed ornare.

            Phasellus malesuada diam ac magna feugiat, et malesuada ligula euismod. Donec at commodo ipsum. Etiam nisl lorem, commodo sed condimentum non, mattis accumsan tellus. Donec mollis, quam nec euismod commodo, mi mi dapibus ipsum, sit amet molestie leo mi non erat. Curabitur nec porttitor libero. Sed a rutrum sem. Quisque non tellus aliquet, bibendum elit nec, porta ante. Aenean nibh sapien, euismod id dapibus eu, auctor a nulla. Quisque ultricies sollicitudin dolor, sit amet lobortis justo pellentesque nec. Nulla facilisi. Duis rutrum orci pellentesque felis ultricies venenatis. Donec ullamcorper dui nisl, nec auctor lacus consectetur sit amet. Ut libero ipsum, por ttitor non pellentesque volutpat, accumsan at erat. Quisque at tempor libero. Ut aliquet sem at sem dictum commodo.

            Curabitur commodo varius finibus. Vivamus vestibulum sodales orci, ut consequat augue vestibulum quis. Nunc tempus vulputate dapibus. In euismod, risus at congue rhoncus, magna diam ornare enim, eget semper nunc ipsum vel nisl. Nulla tincidunt, lorem sit amet imperdiet aliquam, magna arcu gravida quam, eu malesuada purus nulla quis odio. Maecenas quis eros tincidunt, tempor leo volutpat, commodo ligula. Vivamus vulputate massa at tellus hendrerit, non congue lacus ullamcorper. Aenean sit amet sem nec nunc molestie mattis. Nam facilisis rutrum mi in mattis. In nec efficitur turpis, sed hendrerit ipsum. Nunc et fermentum tellus. Sed aliquet ligula at elit dictum, eget eleifend leo auctor. Morbi tempus finibus est vel rhoncus. Integer feugiat porttitor justo. Aliquam at nisi quis lorem aliquet faucibus.

            Fusce sodales facilisis felis sed pretium. Nullam arcu nunc, malesuada sit amet mollis eu, semper eu quam. Suspendisse est tellus, tincidunt nec purus vel, ultricies condimentum nulla. Praesent purus arcu, maximus at commodo id, volutpat id erat. Mauris nec erat nec erat vestibulum ultrices sed in dolor. Aliquam lacus ante, feugiat sit amet sapien id, semper pellentesque lacus. Morbi justo massa, molestie nec nulla a, hendrerit vehicula odio. Etiam sollicitudin est quis urna convallis, non maximus quam pharetra.

            Donec at leo a lectus dapibus commodo eu id dui. Cras tristique mauris sed pharetra congue. Duis nisl magna, mollis eget volutpat et, dignissim at neque. Sed in enim eu nisi fermentum hendrerit. Pellentesque sollicitudin, nibh eu auctor iaculis, quam mi pulvinar metus, eget posuere elit dolor ac dolor. Quisque ultricies consequat magna eu semper. Nulla placerat volutpat augue, ut tempus mi tincidunt id. Nunc in sollicitudin orci. Sed at justo at metus luctus scelerisque at sed arcu. Maecenas pulvinar dui a consequat rutrum. Etiam interdum ligula felis. In eu auctor magna, finibus aliquam massa. Integer finibus quam tellus, quis porta metus vehicula vitae. Aliquam id odio interdum, consectetur augue vitae, interdum dolor.
            """
}
