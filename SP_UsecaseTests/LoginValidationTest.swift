//
//  LoginValidationTest.swift
//  SP_UsecaseTests
//
//  Created by Lester Cabalona on 28/6/21.
//

import XCTest
@testable import SP_Usecase

class LoginValidationTest: XCTestCase {
    
    var validation:ValidationService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.validation = ValidationService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.validation = nil
        super.tearDown()
    }
    
    func testValidUsername(){
        XCTAssertNoThrow(try validation.validateUsername("user1"))
    }
    
    func testUsernameIsEmpty(){
        let expectedError = ValidationError.usernameIsEmpty
        var error:ValidationError?
        XCTAssertThrowsError(try validation.validateUsername("")) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
    }
    
    func testValidPassword(){
        XCTAssertNoThrow(try validation.validatePassword("1myPas$word"))
    }
    
    func testPasswordNoUpperCase(){
        let expectedError = ValidationError.passwordHasSpecialUpperLowerNumber
        var error:ValidationError?
        XCTAssertThrowsError(try validation.validatePassword("1mypa$sword")) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
    }
    
    func testPasswordNoLowerCase(){
        let expectedError = ValidationError.passwordHasSpecialUpperLowerNumber
        var error:ValidationError?
        XCTAssertThrowsError(try validation.validatePassword("1MYPA$$234")) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
    }
    
    func testPasswordNoSpecialCharacter(){
        let expectedError = ValidationError.passwordHasSpecialUpperLowerNumber
        var error:ValidationError?
        XCTAssertThrowsError(try validation.validatePassword("1myPassword")) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
    }
    
    func testPasswordNotMinEightCharacters(){
        let expectedError = ValidationError.passwordHasSpecialUpperLowerNumber
        var error:ValidationError?
        XCTAssertThrowsError(try validation.validatePassword("123")) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
    }
    
    func testPasswordIsEmpty(){
        let expectedError = ValidationError.passwordIsEmpty
        var error:ValidationError?
        XCTAssertThrowsError(try validation.validatePassword("")) { thrownError in
            error = thrownError as? ValidationError
        }
        XCTAssertEqual(expectedError, error)
    }
}
