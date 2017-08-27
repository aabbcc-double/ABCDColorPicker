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
        
        overallRotation.x += ((overallRotation.x - fmod(overallRotation.x, 60)) - overallRotation.x) / 10;
        overallRotation.z += ((overallRotation.z - fmod(overallRotation.z, 20)) - overallRotation.z) / 10;
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
    globalTransform.translation = (ABCDVector3D){.x = 0, .y = 10, .z = 30, .w = 1};
    
    
    ABCDHexagon *hexagons = calloc(100, sizeof(ABCDHexagon));
    ABCDFace *face = calloc(200, sizeof(ABCDFace));
    size_t cnt = 0;
    
    for (int n = 0; n < 18; n++) {
        ABCDTransformation *transform = calloc(1, sizeof(ABCDTransformation));
        transform->parent = &globalTransform;
        transform->pivot = (ABCDVector3D){.x = 0, .y = -10, .z = 0, .w = 1};
        transform->rotation = (ABCDVector3D){.x = 0, .y = 0, .z = (double)n * 20, .w = 1};
        transform->scale = (ABCDVector3D){.x = 1, .y = 1, .z = 1, .w = 1};
        transform->translation = ABCDVector3DZero;
        
        hexagons[n].transform.scale = (ABCDVector3D){.x = 3.89, .y = 1, .z = 1, .w = 1};
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
        [[UIColor whiteColor] setStroke];
        
        
        double h = (double)face[n].id / (double)100;
        [[UIColor colorWithHue:h / 18 saturation:(double)(face[n].id % 10) / 6 brightness:1 alpha:1] setFill];
        
        CGContextSetLineWidth(context, 0.3);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddLines(context, points, 5);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
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
    overallRotation.z += pp.x - p.x;
    
    overallRotation.x = fmod(overallRotation.x, 360);
//    overallRotation.y = fmod(overallRotation.y, 360);
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
}
@end
