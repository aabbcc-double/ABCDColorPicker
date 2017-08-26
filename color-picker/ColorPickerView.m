//
//  ColorPickerView.m
//  color-picker
//
//  Created by Shakhzod Ikromov on 8/24/17.
//  Copyright © 2017 Shakhzod Ikromov. All rights reserved.
//

#import "ColorPickerView.h"

struct Matrix3D {
    double c11;
    double c12;
    double c13;
    double c21;
    double c22;
    double c23;
    double c31;
    double c32;
    double c33;
};
typedef struct Matrix3D Matrix3D;

struct Vector3D {
    double x;
    double y;
    double z;
};
typedef struct Vector3D Vector3D;

@implementation ColorPickerView
- (void)render {
    [self setNeedsDisplay];
}

- (void)didMoveToSuperview {
    static NSTimer *timer;
    if (self.superview != nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0 target:self selector:@selector(render) userInfo:nil repeats:YES];
    } else {
        [timer invalidate];
    }
}

- (Vector3D)multiplyMatrix:(Matrix3D)m3d toVector3D:(Vector3D)v3d {
    Vector3D v;
    v.x = m3d.c11 * v3d.x + m3d.c12 * v3d.y + m3d.c13 * v3d.z;
    v.y = m3d.c21 * v3d.x + m3d.c22 * v3d.y + m3d.c23 * v3d.z;
    v.z = m3d.c31 * v3d.x + m3d.c32 * v3d.y + m3d.c33 * v3d.z;
    return v;
}

- (Matrix3D)rotationForAngle:(CGFloat)angle {
    Matrix3D m3d;
    m3d.c11 = cos(angle);       m3d.c12 = 0;        m3d.c13 = sin(angle);
    m3d.c21 = 0;                m3d.c22 = 1;        m3d.c23 = 0;
    m3d.c31 = -sin(angle);      m3d.c32 = 0;        m3d.c33 = cos(angle);
    return m3d;
}

- (CGPoint)pointFromVector3D:(Vector3D)v3d {
    CGFloat avarageLength = (CGRectGetWidth(self.bounds) + CGRectGetHeight(self.bounds)) / 2.0;
    
    CGPoint p;
    p.x = (v3d.x * (avarageLength / 2)) / (v3d.z + (avarageLength / 2));
    p.y = (-v3d.y * (avarageLength / 2)) / (v3d.z + (avarageLength / 2));
    
    p.x += CGRectGetWidth(self.bounds) / 2.0;
    p.y += CGRectGetHeight(self.bounds) / 2.0;
    return p;
}

- (void)drawRect:(CGRect)rect {
    static double degress = 0;
    degress++;
    Matrix3D m3d = [self rotationForAngle:degress * M_PI / 180.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint *points = calloc(100, sizeof(CGPoint));
    size_t count = 0;
    
    Vector3D v;
    /// Drawing inner cube
    // left side
    v.x = -100;
    v.y = -100;
    v.z = 0;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    v.x = -100;
    v.y = -100;
    v.z = 100;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    v.x = -100;
    v.y = 100;
    v.z = 100;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    v.x = -100;
    v.y = 100;
    v.z = 0;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    v.x = -100;
    v.z = 0;
    v.y = -100;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    
    // bottom side
    v.x = -100;
    v.y = -100;
    v.z = 0;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    v.x = -100;
    v.y = -100;
    v.z = 100;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    v.x = 100;
    v.y = -100;
    v.z = 100;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    v.x = 100;
    v.y = -100;
    v.z = 0;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    v.x = -100;
    v.y = -100;
    v.z = 0;
    v = [self multiplyMatrix:m3d toVector3D:v];
    points[count] = [self pointFromVector3D:v];
    count++;
    
    CGContextAddLines(context, points, count);
    free(points);
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}
@end
