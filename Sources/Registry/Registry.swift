//
//  DependencyContainer.swift
//  Copyright 2024 Andre Hoffmann
//

import Foundation
import SwiftUI


/// A default implementation of the `DependencyContainer` protocol. This container would serve most purposes for dependency injection. It is considered to be a
/// Singleton to provide unambigous access to the underlying dependencies.
public final class DependencyContainer: DependencyContainerProtocol, CustomStringConvertible {

    public static var standard = DependencyContainer()

    private var builders = [String: () throws -> Any]()
    private var instances = [String: Any]()

    public var description: String { "Container with keys: \(allKeys)" }

    public var allKeys: [String] {
        (Array(builders.keys) + Array(instances.keys)).sorted()
    }

    public subscript(key: String) -> Any? {

        if let builder = builders[key], let instance = try? builder() {
            builders.removeValue(forKey: key)
            instances[key] = instance
        }

        return instances[key]
    }

    public func set(builder: @escaping () throws -> Any, forKey key: String) {

        instances[key] = nil
        builders[key] = builder
    }

    public func clear() {

        builders.removeAll()
        instances.removeAll()
    }
}

// Provides an individual instance of a dependency for each resolution. This is useful when there should be multiple instances of an injected
// type. This is equivalent to e.g. providing an in-place initialized value as a default value in initializer injection.
public final class RebuildingDependencyContainer: DependencyContainerProtocol {

    private var builders = [String: () throws -> Any]()

    public subscript(key: String) -> Any? {

        guard let builder = builders[key], let instance = try? builder() else { return nil }

        return instance
    }

    public var allKeys: [String] {
        Array(builders.keys).sorted()
    }

    public func set(builder: @escaping () throws -> Any, forKey key: String) {
        builders[key] = builder
    }

    public func clear() {
        builders.removeAll()
    }
}
