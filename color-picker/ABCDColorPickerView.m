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
    ABCDTransformation globalTransform;
    globalTransform.parent = NULL;
    globalTransform.pivot = (ABCDVector3D){.x = 0, .y = 0, .z = 0, .w = 1};
    globalTransform.rotation = (ABCDVector3D){.x = 0, .y = 0, .z = GLOBAL_ROTATION.z, .w = 1};
    globalTransform.scale = (ABCDVector3D){.x = 1, .y = 1, .z = 1, .w = 1};
    globalTransform.translation = (ABCDVector3D){.x = 0, .y = 10, .z = 10, .w = 1};
    
    
    ABCDHexagon *hexagons = calloc(100, sizeof(ABCDHexagon));
    ABCDFace *face = calloc(200, sizeof(ABCDFace));
    size_t cnt = 0;
    
    for (int n = 0; n < 18; n++) {
        // TODO: memory leak
        ABCDTransformation *transform = calloc(1, sizeof(ABCDTransformation));
        transform->parent = &globalTransform;
        transform->pivot = (ABCDVector3D){.x = 0, .y = -10, .z = 0, .w = 1};
        transform->rotation = (ABCDVector3D){.x = 0, .y = 0, .z = (double)n * 20 * M_PI / 180, .w = 1};
        transform->scale = (ABCDVector3D){.x = 1, .y = 1, .z = 1, .w = 1};
        transform->translation = ABCDVector3DZero;
        
        hexagons[n].transform.scale = (ABCDVector3D){.x = 3.8, .y = 1, .z = 1, .w = 1};
        hexagons[n].transform.translation = (ABCDVector3D){.x = 0, .y = 0, .z = 0, .w = 1};
        hexagons[n].transform.rotation = (ABCDVector3D){.x = GLOBAL_ROTATION.x, .y = 0, .z = 0, .w = 1};
        hexagons[n].transform.pivot = ABCDVector3DZero;
        hexagons[n].transform.parent = transform;
        
        ABCDFace *localFaces = calloc(10, sizeof(ABCDFace));
        size_t localCnt;
        ABCDGetFacesFromHexagon(&localFaces, &localCnt, &hexagons[n]);
        
        for (size_t i = 0; i < localCnt; i++) {
            face[cnt + i] = localFaces[i];
        }
        
        cnt += localCnt;
        free(localFaces);
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
        [[UIColor blackColor] setStroke];
        switch (face[n].id % 3) {
            case 0:
                [[[UIColor blueColor] colorWithAlphaComponent:1] setFill];
                break;
            case 1:
                [[[UIColor greenColor] colorWithAlphaComponent:1] setFill];
                break;
            case 2:
                [[[UIColor orangeColor] colorWithAlphaComponent:1] setFill];
                break;
            default:
                break;
        }
        CGContextSetLineWidth(context, 1);
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
    
    GLOBAL_ROTATION.x += (pp.y - p.y) * M_PI / 180;
    GLOBAL_ROTATION.z += (pp.x - p.x) * M_PI / 180;
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
}
@end
