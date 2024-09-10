# Registry
A simple dependency container for Swift.

### Usage

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

Using the `@Injected` property wrapper is the *most convenient* method.

```swift
@Injected private var foo: Bar
```

The property wrapper will use `DependencyContainer.standard` unless another container is specified.

### Documentation
Please refer to the inline documentation for additional options and further information.
