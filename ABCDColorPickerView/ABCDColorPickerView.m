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
    UIColor *m_oldColor;
    UIColor *m_currentColor;
}
@end

@implementation ABCDColorPickerView
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
    if ([self isTracking] == NO) {
        
        overallRotation.x += (round(overallRotation.x / 60) * 60 - overallRotation.x) / 10;
        overallRotation.z += (round(overallRotation.z / 12) * 12 - overallRotation.z) / 10;
    }
    
    [self setNeedsDisplay];
}

- (void)sortFacesByAvarageZ:(ABCDFace *)faces count:(size_t)count {
    // buble sort
    int swapped;
    do {
        swapped = 0;
        for (int n = 1; n < count; n++) {
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

- (void)drawRect:(CGRect)rect {
    ABCDTransformation globalTransform;
    globalTransform.parent = NULL;
    globalTransform.pivot = (ABCDVector3D){.x = 0, .y = 0, .z = 0, .w = 1};
    globalTransform.rotation = (ABCDVector3D){.x = 0, .y = 0, .z = overallRotation.z, .w = 1};
    globalTransform.scale = (ABCDVector3D){.x = 1, .y = 1, .z = 1, .w = 1};
    globalTransform.translation = (ABCDVector3D){.x = 0, .y = 10, .z = 10, .w = 1};
    
    
    ABCDHexagon *hexagons = calloc(100, sizeof(ABCDHexagon));
    ABCDFace *face = calloc(300, sizeof(ABCDFace));
    size_t cnt = 0;
    
    for (int n = 0; n < 30; n++) {
        ABCDTransformation *transform = calloc(1, sizeof(ABCDTransformation));
        transform->parent = &globalTransform;
        transform->pivot = (ABCDVector3D){.x = 0, .y = -10, .z = 0, .w = 1};
        transform->rotation = (ABCDVector3D){.x = 0, .y = 0, .z = (double)n * 12, .w = 1};
        transform->scale = (ABCDVector3D){.x = 1, .y = 1, .z = 1, .w = 1};
        transform->translation = ABCDVector3DZero;
        
        hexagons[n].transform.scale = (ABCDVector3D){.x = 2.32, .y = 1, .z = 1, .w = 1};
        hexagons[n].transform.translation = (ABCDVector3D){.x = 0, .y = 0, .z = 0, .w = 1};
        hexagons[n].transform.rotation = (ABCDVector3D){.x = overallRotation.x, .y = 0, .z = 0, .w = 1};
        hexagons[n].transform.pivot = ABCDVector3DZero;
        hexagons[n].transform.parent = transform;
        
        ABCDFace *localFaces = calloc(10, sizeof(ABCDFace));
        size_t localCnt;
        ABCDGetFacesFromHexagon(&localFaces, &localCnt, &hexagons[n]);
        
        for (size_t i = 0; i < localCnt; i++) {
            face[cnt + i] = localFaces[i];
            face[cnt + i].id = n * 100 + i;
        }
        
        cnt += localCnt;
        free(localFaces);
        free(transform);
    }

    
    [self sortFacesByAvarageZ:face count:cnt];
    CGPoint *points = calloc(5, sizeof(CGPoint));
    for (int n = 0; n < cnt; n++) {
        ABCDMatrix4x4 projection;
        ABCDPerspectiveProjectionMatrix(&projection, 1, 20);
        
        CGFloat avarageLens = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        
        ABCDMultiplyMatrixToVector3D(&face[n].bl, &face[n].bl, &projection);
        points[0].x = face[n].bl.x * avarageLens / face[n].bl.w + CGRectGetWidth(self.bounds) / 2;
        points[0].y = face[n].bl.y * avarageLens / face[n].bl.w + CGRectGetHeight(self.bounds) / 2;
        
        ABCDMultiplyMatrixToVector3D(&face[n].tl, &face[n].tl, &projection);
        points[1].x = face[n].tl.x * avarageLens / face[n].tl.w + CGRectGetWidth(self.bounds) / 2;
        points[1].y = face[n].tl.y * avarageLens / face[n].tl.w + CGRectGetHeight(self.bounds) / 2;
        
        ABCDMultiplyMatrixToVector3D(&face[n].tr, &face[n].tr, &projection);
        points[2].x = face[n].tr.x * avarageLens / face[n].tr.w + CGRectGetWidth(self.bounds) / 2;
        points[2].y = face[n].tr.y * avarageLens / face[n].tr.w + CGRectGetHeight(self.bounds) / 2;
        
        ABCDMultiplyMatrixToVector3D(&face[n].br, &face[n].br, &projection);
        points[3].x = face[n].br.x * avarageLens / face[n].br.w + CGRectGetWidth(self.bounds) / 2;
        points[3].y = face[n].br.y * avarageLens / face[n].br.w + CGRectGetHeight(self.bounds) / 2;
        
        points[4] = points[0];
        points[4] = points[0];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
//        [[UIColor whiteColor] setStroke];
        
        // TODO: needs refactoring

        double h, s, b;
        h = (double)(face[n].id / 100) / 28;
        if (face[n].id % 10 >= 3) {
            b = h > 1 ? (double)(face[n].id % 10) / 5 : 1.0;
            s = h > 1 ? 0 : 1.0 - (double)(face[n].id % 10 - 3) / 3.0;
        } else {
            s = h > 1 ? 0 : 1;
            b = h > 1 ? (double)(face[n].id % 10) / 5 : MAX((double)(face[n].id % 10) / 3.0, 0.2);
        }
        
        
        [[UIColor colorWithHue:h saturation:s brightness:b alpha:1] setFill];
        
        CGContextSetLineWidth(context, 0.3);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddLines(context, points, 5);
        CGContextDrawPath(context, kCGPathFill);
    
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect aRect = CGRectMake((CGRectGetWidth(self.bounds) - 30) / 2, (CGRectGetHeight(self.bounds) - 30) / 2, 30, 30);
    
    // TODO: needs refactoring
    double h, s, b;
    double z = fmod(360 - round(overallRotation.z / 12) * 12 + 6, 360);
    while (z < 0) {
        z += 360;
    }
    h = z / 348;
    double x = fmod(round((-overallRotation.x + 180) / 60), 6);
    while (x < 0) {
        x += 6;
    }
    if (x > 3) {
        b = h > 1 ? x / 5 : 1.0;
        s = h > 1 ? 0 : 1.0 - (x - 3) / 3.0;
    } else {
        s = h > 1 ? 0 : 1;
        b = h > 1 ? x / 5 : MAX((x) / 3.0, 0.2);
    }
    
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, 3);
    
    m_oldColor = m_currentColor;
    m_currentColor = [UIColor colorWithHue:h saturation:s brightness:b alpha:1];
    [m_currentColor setFill];
    
    if ([m_currentColor isEqual:m_oldColor] == NO) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    CGContextAddEllipseInRect(context, aRect);
    CGContextDrawPath(context, kCGPathFillStroke);

    
    free(face);
    free(points);
    free(hexagons);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    switch (touch.phase) {
        case UITouchPhaseBegan:
            return YES;
        default:
            return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [touch previousLocationInView:self];
    CGPoint pp = [touch locationInView:self];
    
    overallRotation.x += pp.y - p.y;
    overallRotation.z += (pp.x - p.x) / 6;
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
}
@end
