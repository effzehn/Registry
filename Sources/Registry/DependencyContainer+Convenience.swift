//
//  File.swift
//  
//
//  Created by Developer on 10.09.24.
//

import Foundation
import SwiftUI


// MARK: – SwiftUI modifier
struct Inject<T: ObservableObject>: ViewModifier {

    let container: any DependencyContainerProtocol
    let customName: String?

    func body(content: Content) -> some View {

        let dependency: T
        if let customName {
            do {
                dependency = try container.resolve(customName: customName)
            } catch {
                preconditionFailure(error.localizedDescription)
            }
        } else {
            do {
                dependency = try container.resolve()
            } catch {
                preconditionFailure(error.localizedDescription)
            }
        }

        return content.environmentObject(dependency)
    }
}

public extension View {

    /// A `ViewModifier` that allows the injection of dependencies as SwiftUI environment objects. The dependencies must be of type `ObservableObject` and can be used as
    /// `@EnvironmentObject` in child views, therefore allowing the same functionality as `.environmentobject` with the added functionality of consuming the object
    /// from a dependency container.
    /// - Parameters:
    ///     - container: The implementation of `DependencyContainerProtocol` to be used for resolving the dependency. The default value when omitting this parameter
    ///     is `DependencyContainer.standard`
    ///     - type: The type of the object to be resolved.
    ///     - customName: The optional key to identify the dependency.
    func inject<T: ObservableObject>(container: any DependencyContainerProtocol = DependencyContainer.standard, type: T.Type, customName: String? = nil) -> some View {
        modifier(Inject<T>(container: container, customName: customName))
    }
}

// MARK: - Property Wrapper

/// A property wrapper that allows the implicit resolution of dependencies in the type header.
///
///     @Injected private var foo: Bar
///
/// will look up the instance for `Bar` with the `DependencyContainer.standard` singleton.
@propertyWrapper
public final class Injected<T> {

    private let container: DependencyContainerProtocol
    private let customName: String?

    public init(type: T.Type = T.self,
                container: any DependencyContainerProtocol = DependencyContainer.standard,
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

    public var wrappedValue: T {
        _wrappedValue
    }
}
