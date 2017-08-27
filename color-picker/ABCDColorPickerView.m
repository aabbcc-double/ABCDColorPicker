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

static double ROTATION = 0.0;

@interface ABCDColorPickerView () {
    
}
@end

@implementation ABCDColorPickerView
- (void)didMoveToSuperview {
    static NSTimer *timer = nil;
    if (self.superview != nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 / 60.0 target:self selector:@selector(redraw) userInfo:nil repeats:YES];
    } else {
        [timer invalidate];
    }
}

- (void)redraw {
    ROTATION += 1 * M_PI / 180;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    ABCDMatrix4x4 m;
    ABCDPerspectiveProjectionMatrix(&m, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds), 1, 10);
    
    ABCDVector3D *v = calloc(100, sizeof(ABCDVector3D));
    size_t c = 0;

    for (int n = 0; n < 6; n++) {
        double rot = (double)n * 60 * M_PI / 180;
        ABCDMatrix4x4 translateMatrix;
        ABCDMatrix4x4 rotationMatrix;
        ABCDTranslationMatrix(&translateMatrix, 0, -0.5, 0);
        ABCDRotationXMatrix(&rotationMatrix, rot);
        
        v[c].x = 0.0;
        v[c].y = 0.0;
        v[c].z = 0.0;
        v[c].w = 1.0;
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &v[c]);
        ABCDMultiplyMatrixToVector3D(&rotationMatrix, &v[c]);
        c++;
        v[c].x = 0.0;
        v[c].y = 1.0 / 2.414;
        v[c].z = 0.0;
        v[c].w = 1.0;
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &v[c]);
        ABCDMultiplyMatrixToVector3D(&rotationMatrix, &v[c]);
        c++;
        v[c].x = 1.0;
        v[c].y = 1.0 / 2.414;
        v[c].z = 0.0;
        v[c].w = 1.0;
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &v[c]);
        ABCDMultiplyMatrixToVector3D(&rotationMatrix, &v[c]);
        c++;
        v[c].x = 1.0;
        v[c].y = 0.0;
        v[c].z = 0.0;
        v[c].w = 1.0;
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &v[c]);
        ABCDMultiplyMatrixToVector3D(&rotationMatrix, &v[c]);
        c++;
        v[c].x = 0.0;
        v[c].y = 0.0;
        v[c].z = 0.0;
        v[c].w = 1.0;
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &v[c]);
        ABCDMultiplyMatrixToVector3D(&rotationMatrix, &v[c]);
        c++;
    }
    
    
    ABCDMatrix4x4 scaleMatrix;
    ABCDMatrix4x4 rotateMatrix;
    ABCDMatrix4x4 translateMatrix;
    
    ABCDScaleMatrix(&scaleMatrix, 2, 2, 2);
    ABCDRotationXMatrix(&rotateMatrix, ROTATION);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint *points = calloc(c, sizeof(CGPoint));
    for (size_t i = 0; i < c; i++) {
        ABCDVector3D vector = v[i];
        ABCDMultiplyMatrixToVector3D(&scaleMatrix, &vector);
        ABCDMultiplyMatrixToVector3D(&rotateMatrix, &vector);
        ABCDTranslationMatrix(&translateMatrix, -1, 0, 10);
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &vector);
        ABCDMultiplyMatrixToVector3D(&m, &vector);
        
        CGFloat avarageLength = (CGRectGetWidth(self.bounds) + CGRectGetHeight(self.bounds)) / 2.0;
        points[i].x = (vector.x * avarageLength) / vector.w + CGRectGetWidth(self.bounds) / 2.0;
        points[i].y = (vector.y * avarageLength) / vector.w + CGRectGetHeight(self.bounds) / 2.0;
    }
    
    CGRect aRect = CGRectMake(points[0].x, points[0].y, 0, 0);
    aRect = CGRectInset(aRect, -3, -3);
//    CGContextAddEllipseInRect(context, aRect);
    
    CGContextAddLines(context, points, c);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetLineCap(context, kCGLineCapButt);
    [[UIColor redColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
    
    free(v);
    free(points);
}
@end
