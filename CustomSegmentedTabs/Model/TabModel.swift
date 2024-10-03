//
//  TabModel.swift
//  CustomSegmentedTabs
//
//  Created by Govind on 02/10/24.
//

import Foundation

struct TabModel: Identifiable, Hashable {
    let id = UUID().uuidString
    let name: String
}
