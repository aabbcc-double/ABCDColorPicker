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

void ABCDPerspectiveProjectionMatrix(ABCDMatrix4x4 * restrict m, double width, double height, double near, double far);
void ABCDRotationXMatrix(ABCDMatrix4x4 * restrict m, double radians);
void ABCDTranslationMatrix(ABCDMatrix4x4 * restrict m, double tX, double tY, double tZ);
void ABCDScaleMatrix(ABCDMatrix4x4 * restrict m, double xScale, double yScale, double zScale);
void ABCDMultiplyMatrixToMatrix(ABCDMatrix4x4 * restrict result, const ABCDMatrix4x4 * restrict a, const ABCDMatrix4x4 * restrict b);