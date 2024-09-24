# Registry
A simple container based dependency injection solution for Swift.

## Requirements
- Xcode 15 (or newer)
- Swift 5 (or newer)

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

To add `Registry` to your Project, from the Xcode menu select:

`File > Swift Packages > Add Package Dependency...`

Enter the URL for the Registry repository: `https://github.com/effzehn/Registry.git`.

When prompted, input a specific version or a range of versions.

Alternatively, if your project has a `Package.swift` (e.g. because it is a Swift Package), you can add Registry directly to your dependencies:

```swift
.package(url: "https://github.com/effzehn/Registry.git", .upToNextMajor(from: "1.0.2"))
```

## Usage

It is suggested to start off with the `DependencyContainer`. If necessary, it is possible to implement another `DependencyContainerProtocol` with your own internal logic.

In order to add dependencies to the container use the `register(:::)` default implementation:

```swift
DependencyContainer.standard.register(TestClass())
```

To resolve dependencies, it is recommended to either use the property wrapper `@Injected` or the `resolve(:)` default implementation. To resolve a dependency using the `resolve` method:

```swift
do {
  let foo: Bar = try DependencyContainer.standard.resolve()
} catch let error {
  print(error) 
}
```

Keep in mind that resolution failures are fatal errors. This allows you to find critical flaws in your dependency injection early on in the development phase. There
might be another failure handling option in the future where resolution error handling has to be defined at the callsite.

Using the `@Injected` property wrapper is the *most convenient* method.

```swift
@Injected private var foo: Bar
```

The property wrapper will use `DependencyContainer.standard` unless another container is specified.

If you would like to inject a dependency as environmentObject, you can use the `inject(:::)` view modifier. It works the same as `.environmentObject`, with the bonus
that the dependency resolution happens implicitly:

```swift
AChildView()
  .inject(Bar.self)
```

The modifier will use `DependencyContainer.standard` unless another container is specified.

## Documentation
Please refer to the inline documentation for additional options and further information.

## Contribution
Your contributions are appreciated, however please try to keep this component pragmatic and the usage of it simple.
Feel free to create a pull request of your changes and we'll be happy to review it.

## Licensing
This project is licensed under the MIT License. See [LICENSE](LICENSE) for more information.
