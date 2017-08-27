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
    
    dst->bl = src->bl;
    dst->tl = src->tl;
    dst->tr = src->tr;
    dst->br = src->br;
    
    dst->scale = src->scale;
    dst->pivotPoint = src->pivotPoint;
    dst->rotation = src->rotation;
    dst->translation = src->translation;
    
    dst->avarageZ = src->avarageZ;
}

void ABCDCalculateFace(ABCDFace * restrict dst, const ABCDFace * restrict src) {
    // scale | (pivot translate) | rotation | translate
    ABCDFace temp;
    ABCDFace *tmp = &temp;
    
    ABCDMatrix4x4 scaleMatrix, pivotTranslateMatrix, rotationMatrix, translateMatrix;
    ABCDScaleMatrix(&scaleMatrix, src->scale.x, src->scale.y, src->scale.y);
    ABCDTranslationMatrix(&pivotTranslateMatrix, src->pivotPoint.x, src->pivotPoint.y, src->pivotPoint.z);
    ABCDRotationMatrix(&rotationMatrix, src->rotation.x, src->rotation.y, src->rotation.z);
    ABCDTranslationMatrix(&translateMatrix, src->translation.x, src->translation.y, src->translation.z);
    
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
    tmp->scale = (ABCDVector3D){.x = 1, .y = 1, .z = 1, .w = 1};
    tmp->pivotPoint = ABCDVector3DZero;
    tmp->rotation = ABCDVector3DZero;
    tmp->translation = ABCDVector3DZero;
    tmp->id = src->id;
    
    ABCDCopyFaceToFace(dst, tmp);
}
