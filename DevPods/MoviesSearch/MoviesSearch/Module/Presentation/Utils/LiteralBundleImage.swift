//
//  Image+LiteralBundle.swift
//  MoviesSearch-framework
//
//  Created by Oleh Kudinov on 10.12.19.
//

import Foundation

final class LiteralBundleImage: _ExpressibleByImageLiteral {
    let image: UIImage?
    
    required init(imageLiteralResourceName name: String) {
        image = UIImage(named: name, in: Bundle(for: Self.self).resource, compatibleWith: nil)
    }
}
