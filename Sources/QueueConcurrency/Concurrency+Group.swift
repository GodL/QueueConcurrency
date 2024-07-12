//
//  Concurrency+Group.swift
//
//
//  Created by L God on 2024/2/25.
//

fileprivate struct OrderElement<Element: Sendable>: Comparable, Sendable {
    static func < (lhs: OrderElement<Element>, rhs: OrderElement<Element>) -> Bool {
        lhs.order < rhs.order
    }
    
    static func == (lhs: OrderElement<Element>, rhs: OrderElement<Element>) -> Bool {
        lhs.order == rhs.order
    }
    
    let order: Int
    
    let element: Element
}

public func withOrderTask<T, S: Sequence>(sequence: S, _ operation: @escaping @Sendable (S.Element) async -> T ) async -> [T] where T : Sendable, S.Element: Sendable {
    return await withTaskGroup(of: OrderElement<T>.self) { group in
        for (index, element) in sequence.enumerated() {
            group.addTask {
                let value = await operation(element)
                return OrderElement(order: index, element: value)
            }
        }
        return await group.reduce([]) { partialResult, orderElement in
            partialResult + [orderElement]
        }.sorted(by: <).map(\.element)
    }
}

public func withThrowingOrderTask<T, S: Sequence>(sequence: S, _ operation: @escaping @Sendable (S.Element) async throws -> T) async throws -> [T] where T : Sendable, S.Element: Sendable {
    return try await withThrowingTaskGroup(of: OrderElement<T>.self) { group in
        for (index, element) in sequence.enumerated() {
            group.addTask {
                let value = try await operation(element)
                return OrderElement(order: index, element: value)
            }
        }
        return try await group.reduce([]) { partialResult, orderElement in
            partialResult + [orderElement]
        }.sorted(by: <).map(\.element)
    }
}


