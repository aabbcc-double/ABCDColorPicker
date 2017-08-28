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
//  ABCDVector3D.m
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/26/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import "ABCDVector3D.h"

const ABCDVector3D ABCDVector3DZero = {
    .x = 0,
    .y = 0,
    .z = 0,
    .w = 1
};

void ABCDCopyVector3DToVector3D(ABCDVector3D * restrict dst, const ABCDVector3D * restrict src) {
    dst->x = src->x;
    dst->y = src->y;
    dst->z = src->z;
    dst->w = src->w;
}

void ABCDNormalizeVector3D(ABCDVector3D * restrict dst, const ABCDVector3D * restrict src) {
    double ax, ay, az, aw;
    
    ax = src->x;
    ay = src->y;
    az = src->z;
    aw = src->w;
    if (src->w != 0) {
        ax /= aw;
        ay /= aw;
        az /= aw;
        aw = 1.0;
    }
    
    dst->x = ax;
    dst->y = ay;
    dst->z = az;
    dst->w = aw;
}

void ABCDMultiplyMatrixToVector3D(ABCDVector3D * restrict dst, const ABCDVector3D * restrict src, const ABCDMatrix4x4 * restrict m) {
    ABCDVector3D tmp;
    ABCDNormalizeVector3D(&tmp, src);
    double ax, ay, az, aw;
    ax = m->m11 * tmp.x + m->m12 * tmp.y + m->m13 * tmp.z + m->m14 * tmp.w;
    ay = m->m21 * tmp.x + m->m22 * tmp.y + m->m23 * tmp.z + m->m24 * tmp.w;
    az = m->m31 * tmp.x + m->m32 * tmp.y + m->m33 * tmp.z + m->m34 * tmp.w;
    aw = m->m41 * tmp.x + m->m42 * tmp.y + m->m43 * tmp.z + m->m44 * tmp.w;
    
    dst->x = ax;
    dst->y = ay;
    dst->z = az;
    dst->w = aw;
};
