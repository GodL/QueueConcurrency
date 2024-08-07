//
//  DispatchQueue+Concurrency.swift
//
//
//  Created by L God on 2024/1/21.
//

import Foundation

extension DispatchQueue {
    @discardableResult
    public func run<T>(flags: DispatchWorkItemFlags = [], _ block: @escaping @Sendable () -> T) async -> T {
        await withCheckedContinuation { continuation in
            self.async(flags: flags) {
                continuation.resume(returning: block())
            }
        }
    }
    
    @discardableResult
    public func run<T>(flags: DispatchWorkItemFlags = [], _ block: @escaping @Sendable () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            self.async(flags: flags) {
                continuation.resume(with: Result(catching: block))
            }
        }
    }
}
