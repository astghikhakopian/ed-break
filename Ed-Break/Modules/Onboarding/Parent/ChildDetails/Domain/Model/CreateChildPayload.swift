//
//  CreateChildPayload.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import UIKit

struct CreateChildPayload {
    let name: String
    let grade: Grade
    let restrictionTime: Int?
    let intervalBetweenIncorrect: Int?
    let interruption: Int?
    let subjects: [Int]?
    let photo: UIImage?
}
