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

extern const ABCDVector3D ABCDVector3DZero;

void ABCDCopyVector3DToVector3D(ABCDVector3D * restrict dst, const ABCDVector3D * restrict src);
void ABCDNormalizeVector3D(ABCDVector3D * restrict dst, const ABCDVector3D * restrict src);
void ABCDMultiplyMatrixToVector3D(ABCDVector3D * restrict dst, const ABCDVector3D * restrict src, const ABCDMatrix4x4 * restrict matrix);
