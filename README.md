# Registry
A simple dependency container for Swift.

### Usage

It is suggested to start off with the `StandardDependencyContainer`. If necessary, it is possible to implement another `DependencyContainer` with your own internal logic.

In order to add dependencies to the container use the `register(:::)` default implementation:

```swift
StandardDependencyContainer.default.register(TestClass())
```

To resolve dependencies, it is recommended to either use the property wrapper `@Injected` or the `resolve(:)` default implementation. To resolve a dependency using the `resolve` method:

```swift
do {
  let foo: Bar = try StandardDependencyContainer.default.resolve()
} catch let error {
  print(error) 
}
```

Using the `@Injected` property wrapper is the *most convenient* method.

```swift
@Injected private var foo: Bar
```

The property wrapper will use `StandardDependencyContainer.default` unless another container is specified.

### Documentation
Please refer to the inline documentation for additional options and further information.
