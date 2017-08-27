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
