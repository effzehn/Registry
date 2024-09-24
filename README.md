# Registry
A simple container based dependency injection solution for Swift.

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

### Documentation
Please refer to the inline documentation for additional options and further information.
