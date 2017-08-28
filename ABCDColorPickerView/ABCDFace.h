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
