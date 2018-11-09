//
//  SeparateButton.m
//  WirelessEducation
//
//  Created by Richard on 14/9/17.
//  Copyright (c) 2014年 Dianchu. All rights reserved.
//

#import "WBSeparateButton.h"

@implementation WBSeparateButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
    //    CGRect imageContentRect = self.imageRect;
    //    imageContentRect.origin.x += contentRect.origin.x;
    //    imageContentRect.origin.y += contentRect.origin.y;
    
    return self.imageRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
//    CGRect imageContentRect = self.imageRect;
//    imageContentRect.origin.x += contentRect.origin.x;
//    imageContentRect.origin.y += contentRect.origin.y;

	return self.imageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
//    CGRect titleContentRect = self.labelRect;
//    titleContentRect.origin.x += contentRect.origin.x;
//    titleContentRect.origin.y += contentRect.origin.y;
    
	return self.labelRect;
}
@end
