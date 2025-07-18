//
//  WebsiteURL.swift
//  Inclusivity Inspector
//
//  Created by James Froggatt on 2025.07.18.
//

import Foundation

extension String {
    var websiteURL: URL? {
        if !contains("://") {
            URL(string: "https://" + self)
        } else {
            URL(string: self)
        }
    }
}
