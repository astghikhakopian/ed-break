//
//  ChildDetailsViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import SwiftUI

protocol ChildDetailsViewModeling: ObservableObject {
    
    var children: [ChildDetailsModel] { get set }
    var grades: [Grade] { get set }
    var interuptions: [Interuption] { get set }
    var subjects: [BottomsheetCellModel] { get set }
    
    var isContentValid: Bool { get set }
    var isLoading: Bool { get set }
    
    func addAnotherChild()
    func updateChild(completion: (()->())?)
    func deleteChild(completion: (()->())?)
    func removeChild(child: ChildDetailsModel)
    func appendChildren()
    func getSubjects()
    func pairChild(id: Int, deviceToken: String, compleated: @escaping (Bool)->())
    func removeDevice(device: DeviceModel, compleated: @escaping (Bool)->())
}
