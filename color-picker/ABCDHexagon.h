//
//  ABCDHexagon.h
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/27/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCDMatrix4x4.h"
#import "ABCDVector3D.h"
#import "ABCDFace.h"
#import "ABCDTransformation.h"

struct ABCDHexagon {
    uint64_t id;
    
    ABCDTransformation transform;
};

typedef struct ABCDHexagon ABCDHexagon;

void ABCDGetFacesFromHexagon(ABCDFace ** dst, size_t *count, const ABCDHexagon * restrict hex);
