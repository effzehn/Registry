import XCTest
@testable import Registry

final class RegistryTests: XCTestCase {

    private protocol TestProtocol {}
    private class TestClassParent: TestProtocol {}
    private final class TestClass: TestClassParent {}
    private final class UnassociatedTestClass {}

    var sut: DependencyContainerProtocol!

    override func setUp() {
        super.setUp()

        sut = DependencyContainer()
    }

    func testSetSubscriptAndClear() {
        sut.set(builder: {
            TestClass()
        }, forKey: "testClass")

        if let retrieved = try? XCTUnwrap(sut["testClass"]) {
            XCTAssert(retrieved is TestClass)
        } else {
            XCTFail()
        }

        sut.clear()

        XCTAssertNil(sut["testClass"])
        XCTAssert(sut.allKeys.count == 0)
    }

    func testRegisterWithInference() {
        sut.register(TestClass())

        if let retrieved = try? XCTUnwrap(sut["TestClass.Type"]) {
            XCTAssert(retrieved is TestClass)
        } else {
            XCTFail()
        }
    }
    
    func testRegisterWithType() {
        sut.register(TestClass(), for: TestClassParent.self)

        if let retrieved = try? XCTUnwrap(sut["TestClassParent.Type"]) {
            XCTAssert(retrieved is TestClass)
        } else {
            XCTFail()
        }
    }

    func testRegisterWithCustomName() {
        sut.register(TestClass(), as: "testClass")

        if let retrieved = try? XCTUnwrap(sut["testClass"]) {
            XCTAssert(retrieved is TestClass)
        } else {
            XCTFail()
        }
    }

    func testResolveWithInference() {
        sut.register(TestClass())

        do {
            let retrieved: TestClass = try sut.resolve()
            XCTAssertNotNil(retrieved)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testResolveWithCustomName() {
        sut.register(TestClass(), as: "testClass")

        if let _: TestClass = try? sut.resolve(customName: "testClass") {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }

    func testResolveWithInferenceAndCustomType() {
        sut.register(TestClass(), for: TestClassParent.self)
        
        do {
            let retrieved: TestClassParent = try sut.resolve()
            XCTAssertNotNil(retrieved)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testResolveWithInstanceNotAvailableError() {
        do {
            let retrieved: TestClass = try sut.resolve()
            XCTAssertNil(retrieved)
        } catch {
            if let error = error as? ResolvingError {
                if case .instanceNotAvailable = error {
                    XCTAssert(true)
                } else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }
    }

    func testResolveWithTypeMismatchError() {
        sut.register(TestClass(), as: "testClass")

        do {
            let retrieved: UnassociatedTestClass = try sut.resolve(customName: "testClass")
            XCTAssertNil(retrieved)
        } catch {
            if let error = error as? ResolvingError {
                if case .typeMismatchOrOther = error {
                    XCTAssert(true)
                } else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }
    }
}
