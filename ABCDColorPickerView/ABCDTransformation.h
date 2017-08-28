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


