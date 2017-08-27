//
//  ABCDMatrix4x4.m
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/26/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import "ABCDMatrix4x4.h"

const ABCDMatrix4x4 ABCDMatrix4x4Identity = {
    .m11 = 1.0,
    .m12 = 0.0,
    .m13 = 0.0,
    .m14 = 0.0,
    
    .m21 = 0.0,
    .m22 = 1.0,
    .m23 = 0.0,
    .m24 = 0.0,
    
    .m31 = 0.0,
    .m32 = 0.0,
    .m33 = 1.0,
    .m34 = 0.0,
    
    .m41 = 0.0,
    .m42 = 0.0,
    .m43 = 0.0,
    .m44 = 1.0
};

void ABCDPerspectiveProjectionMatrix(ABCDMatrix4x4 * restrict m, double near, double far) {
    double n = near;
    double f = far;
    
//    m->m11 = n / r;
//    m->m12 = 0.0;
//    m->m13 = 0.0;
//    m->m14 = 0.0;
//
//    m->m21 = 0.0;
//    m->m22 = n / t;
//    m->m23 = 0.0;
//    m->m24 = 0.0;
//
//    m->m31 = 0.0;
//    m->m32 = 0.0;
//    m->m33 = -(f + n) / (f - n);
//    m->m34 = -(2.0 * f * n) / (f - n);
//
//    m->m41 = 0.0;
//    m->m42 = 0.0;
//    m->m43 = -1.0;
//    m->m44 = 0.0;
    m->m11 = 1;
    m->m12 = 0.0;
    m->m13 = 0.0;
    m->m14 = 0.0;
    
    m->m21 = 0.0;
    m->m22 = 1;
    m->m23 = 0.0;
    m->m24 = 0.0;
    
    m->m31 = 0.0;
    m->m32 = 0.0;
    m->m33 = (n + f) / n;
    m->m34 = -f;
    
    m->m41 = 0.0;
    m->m42 = 0.0;
    m->m43 = 1/n;
    m->m44 = 0.0;
}

void ABCDRotationXMatrix(ABCDMatrix4x4 * restrict m, double radians) {
    m->m11 = 1.0;
    m->m12 = 0.0;
    m->m13 = 0.0;
    m->m14 = 0.0;
    
    m->m21 = 0.0;
    m->m22 = cos(radians);
    m->m23 = -sin(radians);
    m->m24 = 0.0;
    
    m->m31 = 0.0;
    m->m32 = sin(radians);
    m->m33 = cos(radians);
    m->m34 = 0.0;
    
    m->m41 = 0.0;
    m->m42 = 0.0;
    m->m43 = 0.0;
    m->m44 = 1.0;
}

void ABCDRotationYMatrix(ABCDMatrix4x4 * restrict m, double radians) {
    m->m11 = cos(radians);
    m->m12 = 0.0;
    m->m13 = sin(radians);
    m->m14 = 0.0;
    
    m->m21 = 0.0;
    m->m22 = 1.0;
    m->m23 = 0.0;
    m->m24 = 0.0;
    
    m->m31 = -sin(radians);
    m->m32 = 0.0;
    m->m33 = cos(radians);
    m->m34 = 0.0;
    
    m->m41 = 0.0;
    m->m42 = 0.0;
    m->m43 = 0.0;
    m->m44 = 1.0;
}

void ABCDRotationZMatrix(ABCDMatrix4x4 * restrict m, double radians) {
    m->m11 = cos(radians);
    m->m12 = -sin(radians);
    m->m13 = 0.0;
    m->m14 = 0.0;
    
    m->m21 = sin(radians);
    m->m22 = cos(radians);
    m->m23 = 0.0;
    m->m24 = 0.0;
    
    m->m31 = 0.0;
    m->m32 = 0.0;
    m->m33 = 1.0;
    m->m34 = 0.0;
    
    m->m41 = 0.0;
    m->m42 = 0.0;
    m->m43 = 0.0;
    m->m44 = 1.0;
}

void ABCDRotationMatrix(ABCDMatrix4x4 * restrict m, double x, double y, double z) {
    ABCDMatrix4x4 rotation = ABCDMatrix4x4Identity;
    
    ABCDMatrix4x4 rotX, rotY, rotZ;
    ABCDRotationXMatrix(&rotX, x);
    ABCDRotationYMatrix(&rotY, y);
    ABCDRotationZMatrix(&rotZ, z);
    
    ABCDMultiplyMatrixToMatrix(&rotation, &rotation, &rotZ);
    ABCDMultiplyMatrixToMatrix(&rotation, &rotation, &rotY);
    ABCDMultiplyMatrixToMatrix(&rotation, &rotation, &rotX);
    ABCDCopyMatrixToMatrix(m, &rotation);
}

void ABCDTranslationMatrix(ABCDMatrix4x4 * restrict m, double tX, double tY, double tZ) {
    m->m11 = 1.0;
    m->m12 = 0.0;
    m->m13 = 0.0;
    m->m14 = tX;
    
    m->m21 = 0.0;
    m->m22 = 1.0;
    m->m23 = 0.0;
    m->m24 = tY;
    
    m->m31 = 0.0;
    m->m32 = 0.0;
    m->m33 = 1.0;
    m->m34 = tZ;
    
    m->m41 = 0.0;
    m->m42 = 0.0;
    m->m43 = 0.0;
    m->m44 = 1.0;
}

void ABCDScaleMatrix(ABCDMatrix4x4 * restrict m, double xScale, double yScale, double zScale) {
    m->m11 = xScale;
    m->m12 = 0.0;
    m->m13 = 0.0;
    m->m14 = 0.0;
    
    m->m21 = 0.0;
    m->m22 = yScale;
    m->m23 = 0.0;
    m->m24 = 0.0;
    
    m->m31 = 0.0;
    m->m32 = 0.0;
    m->m33 = zScale;
    m->m34 = 0.0;
    
    m->m41 = 0.0;
    m->m42 = 0.0;
    m->m43 = 0.0;
    m->m44 = 1.0;
}

void ABCDMultiplyMatrixToMatrix(ABCDMatrix4x4 * restrict r, const ABCDMatrix4x4 * restrict a, const ABCDMatrix4x4 * restrict b) {
    ABCDMatrix4x4 temp;
    ABCDMatrix4x4 *t = &temp;
    
    t->m11 = a->m11 * b->m11 + a->m12 * b->m21 + a->m13 * b->m31 + a->m14 * b->m41;
    t->m12 = a->m11 * b->m12 + a->m12 * b->m22 + a->m13 * b->m32 + a->m14 * b->m42;
    t->m13 = a->m11 * b->m13 + a->m12 * b->m23 + a->m13 * b->m33 + a->m14 * b->m43;
    t->m14 = a->m11 * b->m14 + a->m12 * b->m24 + a->m13 * b->m34 + a->m14 * b->m44;
    
    t->m21 = a->m21 * b->m11 + a->m22 * b->m21 + a->m23 * b->m31 + a->m24 * b->m41;
    t->m22 = a->m21 * b->m12 + a->m22 * b->m22 + a->m23 * b->m32 + a->m24 * b->m42;
    t->m23 = a->m21 * b->m13 + a->m22 * b->m23 + a->m23 * b->m33 + a->m24 * b->m43;
    t->m24 = a->m21 * b->m14 + a->m22 * b->m24 + a->m23 * b->m34 + a->m24 * b->m44;
    
    t->m31 = a->m31 * b->m11 + a->m32 * b->m21 + a->m33 * b->m31 + a->m34 * b->m41;
    t->m32 = a->m31 * b->m12 + a->m32 * b->m22 + a->m33 * b->m32 + a->m34 * b->m42;
    t->m33 = a->m31 * b->m13 + a->m32 * b->m23 + a->m33 * b->m33 + a->m34 * b->m43;
    t->m34 = a->m31 * b->m14 + a->m32 * b->m24 + a->m33 * b->m34 + a->m34 * b->m44;
    
    t->m41 = a->m41 * b->m11 + a->m42 * b->m21 + a->m43 * b->m31 + a->m44 * b->m41;
    t->m42 = a->m41 * b->m12 + a->m42 * b->m22 + a->m43 * b->m32 + a->m44 * b->m42;
    t->m43 = a->m41 * b->m13 + a->m42 * b->m23 + a->m43 * b->m33 + a->m44 * b->m43;
    t->m44 = a->m41 * b->m14 + a->m42 * b->m24 + a->m43 * b->m34 + a->m44 * b->m44;
    
    ABCDCopyMatrixToMatrix(r, t);
}

void ABCDCopyMatrixToMatrix(ABCDMatrix4x4 * restrict dst, const ABCDMatrix4x4 * restrict src) {
    dst->m11 = src->m11;
    dst->m12 = src->m12;
    dst->m13 = src->m13;
    dst->m14 = src->m14;
    
    dst->m21 = src->m21;
    dst->m22 = src->m22;
    dst->m23 = src->m23;
    dst->m24 = src->m24;
    
    dst->m31 = src->m31;
    dst->m32 = src->m32;
    dst->m33 = src->m33;
    dst->m34 = src->m34;
    
    dst->m41 = src->m41;
    dst->m42 = src->m42;
    dst->m43 = src->m43;
    dst->m44 = src->m44;
}
