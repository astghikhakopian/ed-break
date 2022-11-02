//
//  ChildQRViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.10.22.
//

import UIKit

final class ChildQRViewModel: ChildQRViewModeling, Identifiable {
    
    @Published var isLoading: Bool = false
    
    private var checkConnectionUseCase: CheckConnectionUseCase
    private let localStorageService: LocalStorageService
    
    private var timer: Timer?
    private let timeInterval = 3.0
    
    init(checkConnectionUseCase: CheckConnectionUseCase, localStorageService: LocalStorageService) {
        self.checkConnectionUseCase = checkConnectionUseCase
        self.localStorageService = localStorageService
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            self?.checkConnection { success in
                if success {
                    timer.invalidate()
                }
            }
        }
    }
    
    func checkConnection(compleated: @escaping (Bool)->()) {
        isLoading = true
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
        checkConnectionUseCase.execute(payload: PairChildPayload(id: -1, deviceToken: uuid)) { [weak self] result in
            switch result {
            case .success(let token):
                self?.localStorageService.setObject(token, forKey: .ChildUser.token)
                self?.localStorageService.setPrimitive(true, forKey: .ChildUser.isLoggedIn)
                compleated(true)
                DispatchQueue.main.async { self?.isLoading = false }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}


// MARK: - Preview

final class MockChildQRViewModel: ChildQRViewModeling, Identifiable {
    
    var isLoading = false
    
    func checkConnection(compleated: @escaping (Bool)->()) { }
}
