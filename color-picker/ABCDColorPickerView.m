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
    for (int n = 0; n < 6; n++) {
        ABCDMatrix4x4 pivotMatrix, rotationMatrix, translateMatrix;
        ABCDTranslationMatrix(&pivotMatrix, -0.5, -0.5, 1);
        ABCDRotationXMatrix(&rotationMatrix, (double)n * 60 * M_PI / 180 + ROTATION);
        ABCDTranslationMatrix(&translateMatrix, 0, 0, 3);
        
        ABCDVector3D *side = calloc(20, sizeof(ABCDVector3D));
        side[0].x = 0;
        side[0].y = 0;
        side[0].z = 0;
        side[0].w = 1;
        ABCDMultiplyMatrixToVector3D(&pivotMatrix, &side[0]);
        ABCDMultiplyMatrixToVector3D(&rotationMatrix, &side[0]);
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &side[0]);
        
        side[1].x = 0;
        side[1].y = 1;
        side[1].z = 0;
        side[1].w = 1;
        ABCDMultiplyMatrixToVector3D(&pivotMatrix, &side[1]);
        ABCDMultiplyMatrixToVector3D(&rotationMatrix, &side[1]);
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &side[1]);

        
        side[2].x = 1;
        side[2].y = 1;
        side[2].z = 0;
        side[2].w = 1;
        ABCDMultiplyMatrixToVector3D(&pivotMatrix, &side[2]);
        ABCDMultiplyMatrixToVector3D(&rotationMatrix, &side[2]);
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &side[2]);

        
        side[3].x = 1;
        side[3].y = 0;
        side[3].z = 0;
        side[3].w = 1;
        ABCDMultiplyMatrixToVector3D(&pivotMatrix, &side[3]);
        ABCDMultiplyMatrixToVector3D(&rotationMatrix, &side[3]);
        ABCDMultiplyMatrixToVector3D(&translateMatrix, &side[3]);

        
        ABCDMatrix4x4 projectionMatrix;
        ABCDPerspectiveProjectionMatrix(&projectionMatrix, 1, 20);
        ABCDMultiplyMatrixToVector3D(&projectionMatrix, &side[0]);
        ABCDMultiplyMatrixToVector3D(&projectionMatrix, &side[1]);
        ABCDMultiplyMatrixToVector3D(&projectionMatrix, &side[2]);
        ABCDMultiplyMatrixToVector3D(&projectionMatrix, &side[3]);
        
        CGFloat avarageLength = (CGRectGetWidth(self.bounds) + CGRectGetHeight(self.bounds)) / 2;
        
        CGPoint tl, tr, bl, br;
        bl.x = (side[0].x * avarageLength) / side[0].w + CGRectGetWidth(self.bounds) / 2;
        bl.y = (side[0].y * avarageLength) / side[0].w + CGRectGetHeight(self.bounds) / 2;
        
        tl.x = (side[1].x * avarageLength) / side[1].w + CGRectGetWidth(self.bounds) / 2;
        tl.y = (side[1].y * avarageLength) / side[1].w + CGRectGetHeight(self.bounds) / 2;
        
        tr.x = (side[2].x * avarageLength) / side[2].w + CGRectGetWidth(self.bounds) / 2;
        tr.y = (side[2].y * avarageLength) / side[2].w + CGRectGetHeight(self.bounds) / 2;
        
        br.x = (side[3].x * avarageLength) / side[3].w + CGRectGetWidth(self.bounds) / 2;
        br.y = (side[3].y * avarageLength) / side[3].w + CGRectGetHeight(self.bounds) / 2;
        
        CGPoint *points = calloc(100, sizeof(CGPoint));
        points[0] = bl;
        points[1] = tl;
        points[2] = tr;
        points[3] = br;
        points[4] = bl;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddLines(context, points, 5);
        [[UIColor redColor] setStroke];
        CGContextSetLineCap(context, kCGLineCapButt);
        CGContextDrawPath(context, kCGPathStroke);
        
        free(side);
        free(points);
    }
}
@end
