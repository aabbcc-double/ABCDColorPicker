//
//  ABCDVector3D.h
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/26/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCDMatrix4x4.h"

struct ABCDVector3D {
    double x;
    double y;
    double z;
    double w;
};

typedef struct ABCDVector3D ABCDVector3D;

void ABCDNormalizeVector3D(ABCDVector3D * restrict);
void ABCDMultiplyMatrixToVector3D(const ABCDMatrix4x4 * restrict, ABCDVector3D * restrict);
