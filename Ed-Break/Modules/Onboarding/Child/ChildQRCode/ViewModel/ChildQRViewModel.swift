//
//  ChildQRViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.10.22.
//

import UIKit

final class ChildQRViewModel: ChildQRViewModeling, Identifiable {
    
    @Published var isLoading: Bool = false
    
    private var pairChildUseCase: PairChildUseCase
    
    private var timer: Timer?
    private let timeInterval = 3.0
    
    init(pairChildUseCase: PairChildUseCase) {
        self.pairChildUseCase = pairChildUseCase
        
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
        pairChildUseCase.execute(payload: PairChildPayload(id: -1, deviceToken: uuid)) { error in
            if let error = error {
                compleated(false)
                print(error.localizedDescription)
                return
            }
            DispatchQueue.main.async { self.isLoading = false }
            compleated(true)
        }
    }
}


// MARK: - Preview

final class MockChildQRViewModel: ChildQRViewModeling, Identifiable {
    
    var isLoading = false
    
    func checkConnection(compleated: @escaping (Bool)->()) { }
}
