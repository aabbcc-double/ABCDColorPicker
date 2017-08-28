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
        ABCDVector3D rotation = {.x = (double)n * 60.0, .y = 0, .z = 0, .w = 1};
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
        face[n].transform.parent = NULL;
        face[n].id = n;
        
        ABCDCalculateFace(&face[n], &face[n]);
        
        face[n].transform = hex->transform;
        face[n].transform.parent = NULL;
        
        ABCDCalculateFace(&face[n], &face[n]);
        
//        scale = (ABCDVector3D){.x = 0.76, .y = 1, .z = 1, .w = 1};
//        translate = (ABCDVector3D){.x = .12, .y = 1, .z = 1, .w = 1};
        
        
        double coeff = (face[n].bl.y + 1) / 2;
        ABCDMatrix4x4 scaleMatrix;
        ABCDScaleMatrix(&scaleMatrix, 1 - 0.19 * coeff, 1, 1);
        ABCDMultiplyMatrixToVector3D(&face[n].bl, &face[n].bl, &scaleMatrix);
        ABCDMultiplyMatrixToVector3D(&face[n].br, &face[n].br, &scaleMatrix);
        coeff = (face[n].tl.y + 1) / 2;
        ABCDScaleMatrix(&scaleMatrix, 1 - 0.19 * coeff, 1, 1);
        ABCDMultiplyMatrixToVector3D(&face[n].tl, &face[n].tl, &scaleMatrix);
        ABCDMultiplyMatrixToVector3D(&face[n].tr, &face[n].tr, &scaleMatrix);
        
        face[n].transform = *hex->transform.parent;
        ABCDCalculateFace(&face[n], &face[n]);
    }
}
