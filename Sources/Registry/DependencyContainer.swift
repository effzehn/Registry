//
//  DependencyContainer.swift
//  Copyright 2024 Andre Hoffmann
//

import Foundation

/// A collection where dependencies can be added, retrieved, or deleted from. The protocol only describes the required interface to an underlying collection.
/// It is the responsibility of the implementation to provide and manage the underlying collection. It is recommended to start off with the `DependencyContainer`
/// implementation and only implement this protocol if necessary for custom behavior.
public protocol DependencyContainerProtocol {

    /// Access dependencies via subscripting the container instance, e.g. `DependencyContainer.standard[MyInstance.registryKey]`.
    subscript(key: String) -> Any? { get }

    /// Returns an array of all currently registered keys. This is mostly useful for debugging purposes.
    var allKeys: [String] { get }

    /// Sets a build instruction for a key.
    /// - Parameters:
    ///     - builder: A closure that is being executed once the subscript method tries to retrieve an instance via it's key.
    ///     - key: The key for the type that is being added to the container.
    func set(builder: @escaping () throws -> Any, forKey key: String)

    /// Removes all dependencies from the underlying collection. This is useful when it is important to start with a clean slate, e.g. if the container lifetime is
    /// bound to a user session. It can also be useful for testing.
    func clear()
}

/// Errors caused by resolving a desired dependency.
@frozen public enum ResolvingError: Error {

    /// There was no instance found with the provided or inferred key.
    case instanceNotAvailable(String)
    /// The type that is expected does not match the inferred type, or another error.
    case typeMismatchOrOther
    /// The SwiftUI modifier failed ot resolve the dependency.
    case modifierError

    var localizedDescription: String? {
        switch self {
        case .instanceNotAvailable(let key):
            return "Instance with key \(key) not found."
        case .typeMismatchOrOther:
            return "Type mismatch or other error."
        case .modifierError:
            return "SwiftUI modifier failed to resolve, concrete error should follow."
        }
    }
}

public extension DependencyContainerProtocol {

    /// Registers a dependency. Registration in this context is the process of setting a dependency builder for a specific or inferred key.
    /// - Parameters:
    ///     - builder: A closure that is being executed once the subscript method tries to retrieve a dependency with its key.
    ///     - type: The type that is being associated with the builder. Usually, it would be the same type as the result type of the builder, however if you want to
    ///     associate a dependency with e.g. it's superclass instead of it's own class, setting this parameter allows you to do that.
    ///     - customName: If there are multiple builders or instances with the same type, it is necessary to use customName to distinguish the dependencies.
    func register<T: AnyObject>(_ builder: @escaping @autoclosure () throws -> T,
                                for type: Any = T.self,
                                as customName: String? = nil)
    {
        let key = customName ?? keyFrom(type)
        set(builder: builder, forKey: key)
    }

    /// Resolves a dependency. Resolving in this context is the process of safely retrieving the dependency based on a specific or inferred key.
    ///
    /// When no `customName` is provided, the key will be inferred from the type in which the instance with type T is referenced with, e.g.:
    ///
    ///     let foo: Bar = try DependencyContainer.default.resolve()
    ///
    /// When using this approach you should handle errors and resolve the dependency in a do/catch block. Using `try?` will result in a type mismatch when Swift tries
    /// to infer the type – the type will be wrapped in a Swift Optional Wrapper and the key will differ from the one the user of the API would expect. Force trying
    /// (`try!`) would also solve this issue but force unwrapping is considered an unsafe practice.
    ///
    /// - Parameters:
    ///     - customName: the optional key to identify the dependency.
    func resolve<T>(customName: String? = nil) throws -> T
    {
        let key = customName ?? keyFrom(T.self)

        guard let instance = self[key] else {
            throw ResolvingError.instanceNotAvailable(key)
        }

        if let instance = instance as? T {
            return instance
        }

        throw ResolvingError.typeMismatchOrOther
    }

    private func keyFrom(_ theType: Any) -> String {
        String(describing: type(of: theType))
    }
}
