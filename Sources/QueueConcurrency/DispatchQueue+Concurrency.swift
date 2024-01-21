//
//  DispatchQueue+Concurrency.swift
//
//
//  Created by L God on 2024/1/21.
//

import Foundation

extension DispatchQueue {
    public func run<T>(flags: DispatchWorkItemFlags = [], _ block: @escaping () -> T) async -> T {
        await withCheckedContinuation { continuation in
            self.async(flags: flags) {
                continuation.resume(returning: block())
            }
        }
    }
    
    public func run<T>(flags: DispatchWorkItemFlags = [], _ block: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            self.async(flags: flags) {
                continuation.resume(with: Result(catching: block))
            }
        }
    }
}
