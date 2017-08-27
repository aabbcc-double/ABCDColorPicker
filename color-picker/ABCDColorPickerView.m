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

static ABCDVector3D GLOBAL_ROTATION = {.x = 0, .y = 0, .z = 0, .w = 1};

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
    if ([self isTracking] == NO) {
//        GLOBAL_ROTATION.x = GLOBAL_ROTATION.x * 180 / M_PI;
//        GLOBAL_ROTATION.x += (fmod(GLOBAL_ROTATION.x, 60) - GLOBAL_ROTATION.x) / 10;
        GLOBAL_ROTATION.y += (0 - GLOBAL_ROTATION.y) / 10;
//        GLOBAL_ROTATION.x = GLOBAL_ROTATION.x * M_PI / 180;
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
    ABCDFace *face = calloc(6, sizeof(ABCDFace));
    for (int n = 0; n < 6; n++) {
        ABCDVector3D scale = {.x = 1, .y = 1, .z = 1, .w = 1};
        ABCDVector3D pivot = {.x = -0.5, .y = -0.5, .z = 0.866, .w = 1};
        ABCDVector3D rotation = {.x = (double)n * 60.0 * M_PI / 180.0 + GLOBAL_ROTATION.x, .y = GLOBAL_ROTATION.y, .z = GLOBAL_ROTATION.z, .w = 1};
        ABCDVector3D translate = {.x = 0, .y = 0, .z = 3, .w = 1};
        
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
        
        face[n].scale = scale;
        face[n].pivotPoint = pivot;
        face[n].rotation = rotation;
        face[n].translation = translate;
        face[n].id = n;
        
        ABCDCalculateFace(&face[n], &face[n]);
    }
    
    [self sortFacesByAvarageZ:face count:6];
    
    CGPoint *points = calloc(5, sizeof(CGPoint));
    for (int n = 0; n < 6; n++) {
        ABCDMatrix4x4 projection;
        ABCDPerspectiveProjectionMatrix(&projection, 1, 20);
        
        CGFloat avarageLens = (CGRectGetWidth(self.bounds) + CGRectGetHeight(self.bounds)) / 2;
        
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
        [[UIColor redColor] setStroke];
        switch (face[n].id % 3) {
            case 0:
                [[[UIColor blueColor] colorWithAlphaComponent:0.7] setFill];
                break;
            case 1:
                [[[UIColor greenColor] colorWithAlphaComponent:0.7] setFill];
                break;
            case 2:
                [[[UIColor orangeColor] colorWithAlphaComponent:0.7] setFill];
                break;
            default:
                break;
        }
        CGContextSetLineWidth(context, 5);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddLines(context, points, 5);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    free(face);
    free(points);
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
    
    GLOBAL_ROTATION.x += (pp.y - p.y) * M_PI / 180;
    GLOBAL_ROTATION.y -= (pp.x - p.x) * M_PI / 180;
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
}
@end
