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
//  ABCDColorPickerView.m
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/24/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import "ABCDColorPickerView.h"
#import "ABCDMatrix4x4.h"
#import "ABCDVector3D.h"
#import "ABCDFace.h"
#import "ABCDHexagon.h"
#import "ABCDTransformation.h"

@interface ABCDColorPickerView () {
    ABCDVector3D overallRotation;
    ABCDVector3D inertion;
    UIColor *m_oldColor;
    UIColor *m_currentColor;
    
    ABCDHexagon *hexagons;
    size_t hexagon_cnt;
    
    ABCDFace *faces;
    size_t face_cnt;
}
@end

@implementation ABCDColorPickerView
- (void)initIfNeeded {
    if (hexagons == NULL) {
        hexagons = calloc(30, sizeof(ABCDHexagon));
        if (hexagons == NULL) {
            NSLog(@"Can't allocate memory for hexagons");
            return;
        }
    }
    
    if (faces == NULL) {
        faces = calloc(30 * 6, sizeof(ABCDFace));
        if (faces == NULL) {
            NSLog(@"Can't allocate memory for faces");
            return;
        }
    }
}

- (UIColor *)currentColor {
    return m_currentColor;
}

- (void)didMoveToSuperview {
    static NSTimer *timer = nil;
    if (self.superview != nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 / 60.0 target:self selector:@selector(redraw) userInfo:nil repeats:YES];
    } else {
        [timer invalidate];
    }
}

- (void)redraw {
    if ([self isTracking]) {
        return;
    } else {
        if (MAX(fabs(inertion.x), fabs(inertion.z)) > 0.1) {
            overallRotation.x += inertion.x;
            overallRotation.z += inertion.z;
            
            inertion.x += (0 - inertion.x) / 10;
            inertion.z += (0 - inertion.z) / 10;
        } else {
            overallRotation.x += (round(overallRotation.x / 60) * 60 - overallRotation.x) / 10;
            overallRotation.z += (round(overallRotation.z / 12) * 12 - overallRotation.z) / 10;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)sortFacesByAvarageZ:(ABCDFace *)faces count:(size_t)count {
   
}

- (void)drawRect:(CGRect)rect {
    
}

- (void)notifyColorChangeIfNeeded:(UIColor *)calculatedColor {
    m_oldColor = m_currentColor;
    [m_currentColor setFill];
    m_currentColor = calculatedColor;
    
    if ([m_currentColor isEqual:m_oldColor] == NO) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    switch (touch.phase) {
        case UITouchPhaseBegan:
            inertion.x = 0;
            inertion.z = 0;
            return YES;
        default:
            return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [touch previousLocationInView:self];
    CGPoint pp = [touch locationInView:self];
    
    inertion.x = pp.y - p.y;
    inertion.z = (pp.x - p.x) / 6;
    
    overallRotation.x += inertion.x;
    overallRotation.z += inertion.z;
    [self setNeedsDisplay];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
}
@end
