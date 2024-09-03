import Foundation

// MARK: - Convenience Property Wrapper

/// A property wrapper that allows the implicit resolution of dependencies in the type header.
///
///     @Injected private var foo: Bar
///
/// will look up the instance for `Bar` with the `StandardDependencyContainer` singleton.
final class Injected<T> {

    private let container: DependencyContainer
    private let customName: String?

    init(type: T.Type = T.self,
         container: DependencyContainer = StandardDependencyContainer.default,
         name: String? = nil)
    {
        self.container = container
        self.customName = name
    }

    private lazy var _wrappedValue: T = {
        do {
            return try container.resolve(customName: customName)
        } catch {
            preconditionFailure(error.localizedDescription)
        }
    }()

    var wrappedValue: T {
        _wrappedValue
    }
}


/// A standard implementation of the `DependencyContainer` protocol. This container would serve most purposes for dependency injection. It is considered to be a
/// Singleton to provide unambigous access to the underlying dependencies.
public final class StandardDependencyContainer: DependencyContainer, CustomStringConvertible {

    public static var `default` = StandardDependencyContainer()

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
public final class RebuildingDependencyContainer: DependencyContainer {

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