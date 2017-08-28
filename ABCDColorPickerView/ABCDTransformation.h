//
//  ABCDTransformation.h
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/28/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCDVector3D.h"

struct ABCDTransformation;
typedef struct ABCDTransformation ABCDTransformation;

struct ABCDTransformation {
    const ABCDTransformation *parent;
    
    ABCDVector3D scale;
    ABCDVector3D pivot;
    ABCDVector3D rotation;
    ABCDVector3D translation;
};


