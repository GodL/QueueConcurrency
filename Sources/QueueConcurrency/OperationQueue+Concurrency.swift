//
//  OperationQueue+Concurrency.swift
//
//
//  Created by L God on 2024/1/21.
//

import Foundation

extension OperationQueue {
    public func run<T>(isBarrier: Bool = false, _ block: @escaping () -> T) async -> T {
        await withCheckedContinuation { continuation in
            if isBarrier {
                self.addBarrierBlock {
                    continuation.resume(returning: block())
                }
            }else {
                self.addOperation {
                    continuation.resume(returning: block())
                }
            }
        }
    }
    
    public func run<T>(isBarrier: Bool = false, _ block: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            if isBarrier {
                self.addBarrierBlock {
                    continuation.resume(with: Result(catching: block))
                }
            }else {
                self.addOperation {
                    continuation.resume(with: Result(catching: block))
                }
            }
        }
    }
}
