//
//  OfflineChildSavingViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.08.23.
//

import SwiftUI
import Combine
import CoreData

final class OfflineChildSavingViewModel: OfflineChildSavingViewModeling {
    
    @Published var isLoading: Bool = false
    @Published var onError: Error? = nil
    @Published var onSuccess: Bool? = nil
    
    private var getOfflineModeChildUseCase: GetOfflineModeChildUseCase
    
    private let getOfflineChildUseCase: GetOfflineChildUseCase
    private let addOfflineChildUseCase: AddOfflineChildUseCase
    private let updateOfflineChildUseCase: UpdateOfflineChildUseCase
    private let deleteOfflineChildUseCase: DeleteOfflineChildUseCase
    private let context: NSManagedObjectContext
    
    private var cancelables = Set<AnyCancellable>()
    
    init(
        getOfflineModeChildUseCase: GetOfflineModeChildUseCase,
        offlineChildProviderProtocol: OfflineChildProvideerProtocol,
        context: NSManagedObjectContext
    ) {
        self.getOfflineModeChildUseCase = getOfflineModeChildUseCase
        self.getOfflineChildUseCase = GetOfflineChildUseCase(offlineChildProvider: offlineChildProviderProtocol)
        self.addOfflineChildUseCase = AddOfflineChildUseCase(offlineChildProvider: offlineChildProviderProtocol)
        self.updateOfflineChildUseCase = UpdateOfflineChildUseCase(offlineChildProvider: offlineChildProviderProtocol)
        self.deleteOfflineChildUseCase = DeleteOfflineChildUseCase(offlineChildProvider: offlineChildProviderProtocol)
        self.context = context
    }
    
    func updateOfflineChild() {
        getOfflineChild { [weak self] childModel in
            guard let self = self else { return }
            self.getLocalOfflineChild { [weak self] childMO in
                guard let self = self else { return }
                if let childMO = childMO {
                    self.updateLocalOfflineChild(childMO: childMO, by: childModel)
                } else {
                    self.addLocalOfflineChild(childModel)
                }
            }
        }
    }
    
    private func getOfflineChild(completion: @escaping (OfflineChildModel) -> Void) {
        DispatchQueue.main.async { self.isLoading = true }
        getOfflineModeChildUseCase.execute { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let model):
                completion(model)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func getLocalOfflineChild(completion: @escaping (OfflineChildMO?) -> Void) {
        getOfflineChildUseCase.execute(in: context)
            .sink { result in
                switch result {
                case .finished: break
                case .failure:
                    completion(nil)
                }
            } receiveValue: { success in
                completion(success)
            }.store(in: &cancelables)
    }
    
    private func addLocalOfflineChild(_ childModel: OfflineChildModel) {
        addOfflineChildUseCase.execute(childModel: childModel, in: context)
            .sink { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError = error
                    }
                }
            } receiveValue: { success in
                DispatchQueue.main.async {
                    self.onSuccess = success
                }
            }.store(in: &cancelables)
    }
    
    private func updateLocalOfflineChild(childMO: OfflineChildMO, by childModel: OfflineChildModel) {
        updateOfflineChildUseCase.execute(childMO: childMO, by: childModel, in: context)
            .sink { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError = error
                    }
                }
            } receiveValue: { success in
                DispatchQueue.main.async {
                    self.onSuccess = success
                }
            }.store(in: &cancelables)
    }
}
