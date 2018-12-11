//
//  RPopView.m
//  SmartLock
//
//  Created by Richard Shen on 2018/11/22.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import "RPopView.h"

static NSInteger kArrorHeight = 6;

@implementation RPopView




#pragma mark - draw rect
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
    CGColorRef colorRef = HEX_RGB(0xffffff).CGColor;
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, colorRef);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 2.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = kArrorHeight,
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, 0);
    CGContextAddLineToPoint(context,midx, miny);
    CGContextAddLineToPoint(context,midx-kArrorHeight, 0);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}
@end
