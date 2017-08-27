//
//  matrixTests.m
//  matrixTests
//
//  Created by Shakhzod Ikromov on 8/26/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ABCDMatrix4x4.h"

@interface matrixTests : XCTestCase

@end

@implementation matrixTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    ABCDMatrix4x4 a, b, r;
    a.m11 = 3;
    a.m12 = 4;
    a.m13 = 5;
    a.m14 = 6;
    
    a.m21 = 7;
    a.m22 = 8;
    a.m23 = 9;
    a.m24 = 10;
    
    a.m31 = 11;
    a.m32 = 12;
    a.m33 = 13;
    a.m34 = 14;
    
    a.m41 = 15;
    a.m42 = 16;
    a.m43 = 17;
    a.m44 = 18;
    
    b.m11 = 19;
    b.m12 = 20;
    b.m13 = 21;
    b.m14 = 22;
    
    b.m21 = 23;
    b.m22 = 24;
    b.m23 = 25;
    b.m24 = 26;
    
    b.m31 = 27;
    b.m32 = 28;
    b.m33 = 29;
    b.m34 = 30;
    
    b.m41 = 31;
    b.m42 = 32;
    b.m43 = 33;
    b.m44 = 34;
    
    ABCDMultiplyMatrixToMatrix(&r, &a, &b);
    
    XCTAssertEqual(r.m11, 470);
    XCTAssertEqual(r.m12, 488);
    XCTAssertEqual(r.m13, 506);
    XCTAssertEqual(r.m14, 524);
    
    XCTAssertEqual(r.m21, 870);
    XCTAssertEqual(r.m22, 904);
    XCTAssertEqual(r.m23, 938);
    XCTAssertEqual(r.m24, 972);
    
    XCTAssertEqual(r.m31, 1270);
    XCTAssertEqual(r.m32, 1320);
    XCTAssertEqual(r.m33, 1370);
    XCTAssertEqual(r.m34, 1420);
    
    XCTAssertEqual(r.m41, 1670);
    XCTAssertEqual(r.m42, 1736);
    XCTAssertEqual(r.m43, 1802);
    XCTAssertEqual(r.m44, 1868);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        ABCDMatrix4x4 a, b, r;
        a.m11 = 3;
        a.m12 = 4;
        a.m13 = 5;
        a.m14 = 6;
        
        a.m21 = 7;
        a.m22 = 8;
        a.m23 = 9;
        a.m24 = 10;
        
        a.m31 = 11;
        a.m32 = 12;
        a.m33 = 13;
        a.m34 = 14;
        
        a.m41 = 15;
        a.m42 = 16;
        a.m43 = 17;
        a.m44 = 18;
        
        b.m11 = 19;
        b.m12 = 20;
        b.m13 = 21;
        b.m14 = 22;
        
        b.m21 = 23;
        b.m22 = 24;
        b.m23 = 25;
        b.m24 = 26;
        
        b.m31 = 27;
        b.m32 = 28;
        b.m33 = 29;
        b.m34 = 30;
        
        b.m41 = 31;
        b.m42 = 32;
        b.m43 = 33;
        b.m44 = 34;
        
        ABCDMultiplyMatrixToMatrix(&r, &a, &b);
    }];
}

@end
