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
//  ABCDFace.m
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/27/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import "ABCDFace.h"
#import "ABCDMatrix4x4.h"

void ABCDCopyFaceToFace(ABCDFace * restrict dst, const ABCDFace * restrict src) {
    dst->id = src->id;
    dst->data = src->data;

    dst->bl = src->bl;
    dst->tl = src->tl;
    dst->tr = src->tr;
    dst->br = src->br;
    
    dst->transform = src->transform;
    
    dst->avarageZ = src->avarageZ;
}

void ABCDCalculateFace(ABCDFace * restrict dst, const ABCDFace * restrict src) {
    // scale | (pivot translate) | rotation | translate
    ABCDFace temp;
    ABCDFace *tmp = &temp;
    
    ABCDMatrix4x4 scaleMatrix, pivotTranslateMatrix, rotationMatrix, translateMatrix;
    ABCDScaleMatrix(&scaleMatrix, src->transform.scale.x, src->transform.scale.y, src->transform.scale.y);
    ABCDTranslationMatrix(&pivotTranslateMatrix, src->transform.pivot.x, src->transform.pivot.y, src->transform.pivot.z);
    ABCDRotationMatrix(&rotationMatrix, src->transform.rotation.x, src->transform.rotation.y, src->transform.rotation.z);
    ABCDTranslationMatrix(&translateMatrix, src->transform.translation.x, src->transform.translation.y, src->transform.translation.z);
    
    ABCDMultiplyMatrixToVector3D(&tmp->bl, &src->bl, &scaleMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->bl, &tmp->bl, &pivotTranslateMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->bl, &tmp->bl, &rotationMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->bl, &tmp->bl, &translateMatrix);
    
    ABCDMultiplyMatrixToVector3D(&tmp->tl, &src->tl, &scaleMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->tl, &tmp->tl, &pivotTranslateMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->tl, &tmp->tl, &rotationMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->tl, &tmp->tl, &translateMatrix);
    
    ABCDMultiplyMatrixToVector3D(&tmp->tr, &src->tr, &scaleMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->tr, &tmp->tr, &pivotTranslateMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->tr, &tmp->tr, &rotationMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->tr, &tmp->tr, &translateMatrix);
    
    ABCDMultiplyMatrixToVector3D(&tmp->br, &src->br, &scaleMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->br, &tmp->br, &pivotTranslateMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->br, &tmp->br, &rotationMatrix);
    ABCDMultiplyMatrixToVector3D(&tmp->br, &tmp->br, &translateMatrix);
    
    tmp->avarageZ = (tmp->bl.z + tmp->br.z + tmp->tr.z + tmp->tl.z) / 4.0;
    tmp->id = src->id;
    
    if (src->transform.parent != NULL) {
        tmp->transform = *src->transform.parent;
        ABCDCalculateFace(tmp, tmp);
    } else {
        tmp->transform.parent = NULL;
        tmp->transform.scale = (ABCDVector3D){.x = 1, .y = 1, .z = 1, .w = 1};
        tmp->transform.pivot = ABCDVector3DZero;
        tmp->transform.rotation = ABCDVector3DZero;
        tmp->transform.translation = ABCDVector3DZero;
    }
    
    ABCDCopyFaceToFace(dst, tmp);
}

void ABCDSortFacesByAvgZ(ABCDFace * restrict dst, const ABCDFace * restrict src, size_t face_cnt) {
    // buble sort
    int swapped;
    do {
        swapped = 0;
        for (int n = 1; n < face_cnt; n++) {
            if (faces[n - 1].avarageZ < faces[n].avarageZ) {
                ABCDFace tmp;
                ABCDCopyFaceToFace(&tmp, &faces[n - 1]);
                ABCDCopyFaceToFace(&faces[n - 1] , &faces[n]);
                ABCDCopyFaceToFace(&faces[n], &tmp);
                swapped = 1;
            }
        }
    } while (swapped == 1);
}
