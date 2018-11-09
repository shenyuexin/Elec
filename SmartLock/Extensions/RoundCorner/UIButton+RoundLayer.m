//
//  UIButton+RoundLayer.m
//  NewMai
//
//  Created by Richard Shen on 15/11/4.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "UIButton+RoundLayer.h"
#import "NSObject+MethodSwizzle.h"
#import <objc/runtime.h>

static char WBUIButtonCornerRadiusKey;
static char WBNSOperationQueueKey;

static CGSize viewSize;
@implementation UIButton (RoundLayer)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(setImage:forState:) withSelector:@selector(nm_setImage:forState:)];
    });
}

- (NSOperationQueue *)cornerOperationQueue
{
    NSOperationQueue *queue = objc_getAssociatedObject(self, &WBNSOperationQueueKey);
    if(!queue){
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        
        objc_setAssociatedObject(self, &WBNSOperationQueueKey, queue,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return queue;
}


- (void)setCornerRadius:(CGFloat)radius
{
    objc_setAssociatedObject(self, &WBUIButtonCornerRadiusKey, [NSNumber numberWithFloat:radius],OBJC_ASSOCIATION_COPY_NONATOMIC);
    viewSize = self.bounds.size;
}

- (CGFloat)radius
{
    NSNumber *value = objc_getAssociatedObject(self, &WBUIButtonCornerRadiusKey);
    return [value floatValue];
}

- (CGRect )aspectFillSize:(CGSize)imageSize
{
    CGSize size = viewSize;
    CGFloat scalex = size.width / imageSize.width;
    CGFloat scaley = size.height / imageSize.height;
    CGFloat scale = MAX(scalex, scaley);
    
    CGFloat width = imageSize.width * scale;
    CGFloat height = imageSize.height * scale;
    
    float dwidth = ((size.width - width) / 2.0f);
    float dheight = ((size.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, width, height);
    return rect;
}

- (UIImage *)cornerImage:(UIImage *)image
{
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewSize.width, viewSize.height)
                                cornerRadius:self.radius] addClip];
    // Draw your image
    CGRect rect = [self aspectFillSize:image.size];
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    UIImage *conrnerImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return conrnerImage;
}

- (void)nm_setImage:(UIImage *)image forState:(UIControlState)state
{
    if(self.radius >= 1 && image){
        [self.cornerOperationQueue cancelAllOperations];
        @weakify(self);
        [self.cornerOperationQueue addOperationWithBlock:^{
            @strongify(self);
            UIImage *cornerImage = [self cornerImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self nm_setImage:cornerImage forState:state];
//                [self setNeedsDisplay];
            });
        }];
    }
    else{
        [self nm_setImage:image forState:state];
    }
}


@end
