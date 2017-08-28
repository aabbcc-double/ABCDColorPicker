//
//  ABCDFace.h
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/27/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCDVector3D.h"
#import "ABCDTransformation.h"

struct ABCDFace {
    uint64_t id;
    
    ABCDVector3D bl;
    ABCDVector3D tl;
    ABCDVector3D tr;
    ABCDVector3D br;
    
    ABCDTransformation transform;
    
    double avarageZ;
};

typedef struct ABCDFace ABCDFace;

void ABCDCopyFaceToFace(ABCDFace * restrict dst, const ABCDFace * restrict src);
void ABCDCalculateFace(ABCDFace * restrict dst, const ABCDFace * restrict src);
