//
//  ABCDHexagon.m
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/27/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import "ABCDHexagon.h"

void ABCDGetFacesFromHexagon(ABCDFace ** dst, size_t *count, const ABCDHexagon * restrict hex) {
    ABCDFace *face = *dst;
    *count = 6;
    
    for (int n = 0; n < 6; n++) {
        ABCDVector3D scale = {.x = 1, .y = 1, .z = 1, .w = 1};
        ABCDVector3D pivot = {.x = -0.5, .y = -0.5, .z = 0.866, .w = 1};
        ABCDVector3D rotation = {.x = (double)n * 60.0 * M_PI / 180.0, .y = 0, .z = 0, .w = 1};
        ABCDVector3D translate = {.x = 0, .y = 0, .z = 0, .w = 1};
        
        face[n].bl.x = 0;
        face[n].bl.y = 0;
        face[n].bl.z = 0;
        face[n].bl.w = 1;
        
        face[n].tl.x = 0;
        face[n].tl.y = 1;
        face[n].tl.z = 0;
        face[n].tl.w = 1;
        
        face[n].tr.x = 1;
        face[n].tr.y = 1;
        face[n].tr.z = 0;
        face[n].tr.w = 1;
        
        face[n].br.x = 1;
        face[n].br.y = 0;
        face[n].br.z = 0;
        face[n].br.w = 1;
        
        face[n].transform.scale = scale;
        face[n].transform.pivot = pivot;
        face[n].transform.rotation = rotation;
        face[n].transform.translation = translate;
        face[n].transform.parent = &hex->transform;
        face[n].id = n;
        
        ABCDCalculateFace(&face[n], &face[n]);
    }
}
