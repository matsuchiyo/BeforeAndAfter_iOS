//
//  AddRecordViewModel.swift
//  BeforeAndAfter
//
//  Created by 松島勇貴 on 2020/02/21.
//

import Foundation
import Combine

class AddRecordViewModel: ObservableObject {
    // MARK: - Input
    enum Input {
        case onSaveButtonTapped(record: Record)
    }
    func apply(_ input: Input) {
        switch input {
        case .onSaveButtonTapped(let record):
            onSaveButtonTappedSubject.send(record)
        }
    }
    private var onSaveButtonTappedSubject = PassthroughSubject<Record, Never>()
    
    // MARK: - Output
    
    // MARK: - Other
    private var cancellables: [AnyCancellable] = []
    private let recordRepository: RecordRepositoryProtocol
    
    // MARK: - Intermediate
    private var saveSubject = PassthroughSubject<Void, Never>()

    init(recordRepository: RecordRepositoryProtocol = RecordRepository()) {
        self.recordRepository = recordRepository
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        let saveStream = onSaveButtonTappedSubject
            .flatMap { [recordRepository] record in
                recordRepository.add(record: record)
            }
        .share()
        .subscribe(saveSubject)
        cancellables.append(saveStream)
    }
    
    private func bindOutputs() {
        // do nothing
    }
}
