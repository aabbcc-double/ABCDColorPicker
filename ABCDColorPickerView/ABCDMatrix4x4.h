//    MIT License
//
//    Copyright (c) 2017 Shakhzod Ikromov (aabbcc.double@gmail.com)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


//
//  ABCDMatrix4x4.h
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/26/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import <Foundation/Foundation.h>

struct ABCDMatrix4x4 {
    double m11;
    double m12;
    double m13;
    double m14;
    double m21;
    double m22;
    double m23;
    double m24;
    double m31;
    double m32;
    double m33;
    double m34;
    double m41;
    double m42;
    double m43;
    double m44;
};

typedef struct ABCDMatrix4x4 ABCDMatrix4x4;

extern const ABCDMatrix4x4 ABCDMatrix4x4Identity;

void ABCDPerspectiveProjectionMatrix(ABCDMatrix4x4 * restrict m, double near, double far);
void ABCDRotationXMatrix(ABCDMatrix4x4 * restrict m, double radians);
void ABCDRotationYMatrix(ABCDMatrix4x4 * restrict m, double radians);
void ABCDRotationZMatrix(ABCDMatrix4x4 * restrict m, double radians);
void ABCDRotationMatrix(ABCDMatrix4x4 * restrict m, double x, double y, double z);
void ABCDTranslationMatrix(ABCDMatrix4x4 * restrict m, double tX, double tY, double tZ);
void ABCDScaleMatrix(ABCDMatrix4x4 * restrict m, double xScale, double yScale, double zScale);
void ABCDCopyMatrixToMatrix(ABCDMatrix4x4 * restrict dst, const ABCDMatrix4x4 * restrict src);
void ABCDMultiplyMatrixToMatrix(ABCDMatrix4x4 * restrict result, const ABCDMatrix4x4 * restrict a, const ABCDMatrix4x4 * restrict b);
