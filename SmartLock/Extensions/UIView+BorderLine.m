//
//  UIView+BorderLine.m
//  Weimai
//
//  Created by Richard Shen on 2017/6/15.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "UIView+BorderLine.h"
#import "objc/runtime.h"

@interface UIView ()

@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation UIView (BorderLine)

static char LeftLineKey;
static char RightLineKey;
static char TopLineKey;
static char BottomLineKey;
static char LineColorKey;

- (void)setLine:(UIView *)view withType:(BorderType)type
{
    switch (type) {
        case BorderLeft:
            objc_setAssociatedObject(self, &LeftLineKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        case BorderRight:
            objc_setAssociatedObject(self, &RightLineKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        case BorderTop:
            objc_setAssociatedObject(self, &TopLineKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        case BorderBottom:
            objc_setAssociatedObject(self, &BottomLineKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
    }
}

- (UIView *)lineWithType:(BorderType)type
{
    switch (type) {
        case BorderLeft:
            return objc_getAssociatedObject(self, &LeftLineKey);
        case BorderRight:
            return objc_getAssociatedObject(self, &RightLineKey);
        case BorderTop:
            return objc_getAssociatedObject(self, &TopLineKey);
        case BorderBottom:
            return objc_getAssociatedObject(self, &BottomLineKey);
        default:
            return nil;
    }
}

- (void)setLineColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &LineColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSArray *arrays = @[@(BorderTop),@(BorderBottom),@(BorderLeft),@(BorderRight)];
    for(NSNumber *key in arrays){
        UIView *line = [self lineWithType:key.integerValue];
        line.backgroundColor = color;
    }
}

- (void)addLine:(BorderType)type
{
    [self addBorderLine:type withHeight:self.height withWidth:self.width];
}

- (void)addBorderLine:(BorderType)type withWidth:(CGFloat)width
{
    [self addBorderLine:type withHeight:self.height withWidth:width];

}

- (void)addBorderLine:(BorderType)type withHeight:(CGFloat)height
{
    [self addBorderLine:type withHeight:height withWidth:self.width];
}

- (void)addBorderLine:(BorderType)type withHeight:(CGFloat)height withWidth:(CGFloat)width
{
    UIView *line = [self lineWithType:type];
    if(!line){
        line = [UIView new];
        UIColor *color = objc_getAssociatedObject(self, &LineColorKey);
        if(!color){
            color = HEX_RGB(0xe6e6e6);
        }
        line.backgroundColor = color;
        [self setLine:line withType:type];
    }
    switch (type) {
        case BorderLeft:
            line.frame = CGRectMake(0, (self.height-height)/2, PX1, height);
            break;
        case BorderRight:
            line.frame = CGRectMake(self.width-PX1, (self.height-height)/2, PX1, height);
            break;
        case BorderTop:
            line.frame = CGRectMake((self.width-width)/2, 0, width, PX1);
            break;
        case BorderBottom:
            line.frame = CGRectMake((self.width-width)/2, self.height-PX1, width, PX1);
            break;
    }
    [self addSubview:line];
    [self bringSubviewToFront:line];
}

- (void)addBorderLine:(BorderType)type
{
    if((type & BorderTop) == BorderTop){
        [self addLine:BorderTop];
    }
    if((type & BorderBottom) == BorderBottom){
        [self addLine:BorderBottom];
    }
    if((type & BorderLeft) == BorderLeft){
        [self addLine:BorderLeft];
    }
    if((type & BorderRight) == BorderRight){
        [self addLine:BorderRight];
    }
}

- (void)removeLine:(BorderType)type
{
    UIView *line = [self lineWithType:type];
    if(line && line.superview){
        [line removeFromSuperview];
    }
}

- (void)removeBorderLine:(BorderType)type
{
    if((type & BorderTop) == BorderTop){
        [self removeLine:BorderTop];
    }
    if((type & BorderBottom) == BorderBottom){
        [self removeLine:BorderBottom];
    }
    if((type & BorderLeft) == BorderLeft){
        [self removeLine:BorderLeft];
    }
    if((type & BorderRight) == BorderRight){
        [self removeLine:BorderRight];
    }
}
@end
