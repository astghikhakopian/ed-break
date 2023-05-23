import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

private let _DataModel = DataModel()

class DataModel: ObservableObject {
    let store = ManagedSettingsStore()
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection
    @Published var remindingMinutes: Int
    
    var threshold: DateComponents
    
    var isDiscourageEmpty: Bool {
        selectionToDiscourage.applicationTokens.isEmpty &&
        selectionToDiscourage.applications.isEmpty &&
        selectionToDiscourage.categories.isEmpty &&
        selectionToDiscourage.categoryTokens.isEmpty
    }
    
   
    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
        threshold = DateComponents()
        remindingMinutes = 0
    }
    
    class var shared: DataModel {
        return _DataModel
    }
    
    func setShieldRestrictions() {
        let applications = DataModel.shared.selectionToDiscourage
        
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications.categoryTokens.isEmpty
        ? nil
        : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
    }
}
