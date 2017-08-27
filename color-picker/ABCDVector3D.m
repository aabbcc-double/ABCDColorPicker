//
//  ABCDVector3D.m
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/26/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import "ABCDVector3D.h"

void ABCDNormalizeVector3D(ABCDVector3D * restrict vector) {
    if (vector->w == 0) return;
    
    vector->x /= vector->w;
    vector->y /= vector->w;
    vector->z /= vector->w;
    vector->w = 1.0;
}

void ABCDMultiplyMatrixToVector3D(const ABCDMatrix4x4 * restrict m, ABCDVector3D * restrict v) {
    ABCDNormalizeVector3D(v);
    double ax, ay, az, aw;
    ax = m->m11 * v->x + m->m12 * v->y + m->m13 * v->z + m->m14 * v->w;
    ay = m->m21 * v->x + m->m22 * v->y + m->m23 * v->z + m->m24 * v->w;
    az = m->m31 * v->x + m->m32 * v->y + m->m33 * v->z + m->m34 * v->w;
    aw = m->m41 * v->x + m->m42 * v->y + m->m43 * v->z + m->m44 * v->w;
    
    v->x = ax;
    v->y = ay;
    v->z = az;
    v->w = aw;
};
