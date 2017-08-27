//
//  matrixTests.m
//  matrixTests
//
//  Created by Shakhzod Ikromov on 8/26/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ABCDMatrix4x4.h"
#import "ABCDVector3D.h"
#import "ABCDFace.h"

#define ACC 0.0001

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

- (void)testVectorCopy {
    ABCDVector3D a, b;
    a.x = 10;
    a.y = 12;
    a.z = 16;
    a.w = 35;
    
    ABCDCopyVector3DToVector3D(&b, &a);
    
    XCTAssertEqual(a.x, b.x);
    XCTAssertEqual(a.y, b.y);
    XCTAssertEqual(a.z, b.z);
    XCTAssertEqual(a.w, b.w);
}

- (void)testVectorNormalize {
    ABCDVector3D a;
    a.x = 10;
    a.y = 12;
    a.z = 16;
    a.w = 35;
    
    ABCDNormalizeVector3D(&a, &a);
    
    XCTAssertEqualWithAccuracy(a.x, 0.285714285714286, ACC);
    XCTAssertEqualWithAccuracy(a.y, 0.342857142857143, ACC);
    XCTAssertEqualWithAccuracy(a.z, 0.457142857142857, ACC);
    XCTAssertEqualWithAccuracy(a.w,                 1, ACC);
}

- (void)testMatrixCopy {
    ABCDMatrix4x4 a, b;
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
    
    ABCDCopyMatrixToMatrix(&b, &a);
    
    XCTAssertEqual(a.m11, b.m11);
    XCTAssertEqual(a.m12, b.m12);
    XCTAssertEqual(a.m13, b.m13);
    XCTAssertEqual(a.m14, b.m14);
    
    XCTAssertEqual(a.m21, b.m21);
    XCTAssertEqual(a.m22, b.m22);
    XCTAssertEqual(a.m23, b.m23);
    XCTAssertEqual(a.m24, b.m24);
    
    XCTAssertEqual(a.m31, b.m31);
    XCTAssertEqual(a.m32, b.m32);
    XCTAssertEqual(a.m33, b.m33);
    XCTAssertEqual(a.m34, b.m34);
    
    XCTAssertEqual(a.m41, b.m41);
    XCTAssertEqual(a.m42, b.m42);
    XCTAssertEqual(a.m43, b.m43);
    XCTAssertEqual(a.m44, b.m44);
}

- (void)testMatrixMultiplication {
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

- (void)testFaceScaleCalculation {
    ABCDFace face;
    face.bl.x = 0;
    face.bl.y = 0;
    face.bl.z = 0;
    face.bl.w = 1;
    
    face.tl.x = 0;
    face.tl.y = 1;
    face.tl.z = 0;
    face.tl.w = 1;
    
    face.tr.x = 1;
    face.tr.y = 1;
    face.tr.z = 0;
    face.tr.w = 1;
    
    face.br.x = 1;
    face.br.y = 0;
    face.br.z = 0;
    face.br.w = 1;
    
    face.scale = (ABCDVector3D){.x = 2, .y = 2, .z = 2, .w = 1};
    face.translation = ABCDVector3DZero;
    face.pivotPoint = ABCDVector3DZero;
    face.rotation = ABCDVector3DZero;
    
    ABCDCalculateFace(&face, &face);
    
    XCTAssertEqualWithAccuracy(face.bl.x, 0, ACC);
    XCTAssertEqualWithAccuracy(face.bl.y, 0, ACC);
    XCTAssertEqualWithAccuracy(face.bl.z, 0, ACC);
    XCTAssertEqualWithAccuracy(face.bl.w, 1, ACC);
    
    XCTAssertEqualWithAccuracy(face.tl.x, 0, ACC);
    XCTAssertEqualWithAccuracy(face.tl.y, 2, ACC);
    XCTAssertEqualWithAccuracy(face.tl.z, 0, ACC);
    XCTAssertEqualWithAccuracy(face.tl.w, 1, ACC);
    
    XCTAssertEqualWithAccuracy(face.tr.x, 2, ACC);
    XCTAssertEqualWithAccuracy(face.tr.y, 2, ACC);
    XCTAssertEqualWithAccuracy(face.tr.z, 0, ACC);
    XCTAssertEqualWithAccuracy(face.tr.w, 1, ACC);
    
    XCTAssertEqualWithAccuracy(face.br.x, 2, ACC);
    XCTAssertEqualWithAccuracy(face.br.y, 0, ACC);
    XCTAssertEqualWithAccuracy(face.br.z, 0, ACC);
    XCTAssertEqualWithAccuracy(face.br.w, 1, ACC);
    
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

#undef ACC
