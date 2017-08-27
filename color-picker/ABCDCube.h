//
//  ABCDCube.h
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/26/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABCDMatrix4x4.h"
#import "ABCDVector3D.h"

struct ABCDCube {
    ABCDVector3D position;
    ABCDVector3D scale;
    double rotation; // we only use x rotation, in radians
};

typedef struct ABCDCube ABCDCube;
