//
//  UITextView+Limit.m
//  Zhifujia
//
//  Created by Richard Shen on 15/9/5.
//  Copyright (c) 2015年 Chutong. All rights reserved.
//

#import "UITextView+Limit.h"

#import <objc/runtime.h>

@interface PrivateUITextViewMaxLengthHelper : NSObject

@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, weak)   UITextView *textView;
- (instancetype)initWithTextView:(UITextView *)textView maxLength:(NSUInteger)maxLength;

@end


@interface UITextView (PrivateMaxLengthHelper)
@property (nonatomic, strong) PrivateUITextViewMaxLengthHelper *maxLengthHelper;
@end

@implementation UITextView (Limit)

static void *UITextViewLimitMaxLengthKey = &UITextViewLimitMaxLengthKey;

- (void)setMaxLength:(NSUInteger)maxLength
{
    objc_setAssociatedObject(self, UITextViewLimitMaxLengthKey, @(maxLength), OBJC_ASSOCIATION_COPY);
    self.maxLengthHelper.maxLength = maxLength;
}

- (NSUInteger)maxLength {
    return [objc_getAssociatedObject(self, UITextViewLimitMaxLengthKey) unsignedIntegerValue];
}

@end

@implementation UITextView (PrivateMaxLengthHelper)

static void *maxLengthHelperKey = &maxLengthHelperKey;

- (void)setMaxLengthHelper:(PrivateUITextViewMaxLengthHelper *)maxLengthHelper
{
    objc_setAssociatedObject(self, maxLengthHelperKey, maxLengthHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PrivateUITextViewMaxLengthHelper *)maxLengthHelper {
    PrivateUITextViewMaxLengthHelper *helper = objc_getAssociatedObject(self, maxLengthHelperKey);
    if (!helper) {
        helper = [[PrivateUITextViewMaxLengthHelper alloc] initWithTextView:self maxLength:self.maxLength];
        [self setMaxLengthHelper:helper];
    }
    
    return helper;
}

@end

@implementation PrivateUITextViewMaxLengthHelper

- (instancetype)initWithTextView:(UITextView *)textView maxLength:(NSUInteger)maxLength {
    if (self = [super init]) {
        _textView = textView;
        _maxLength = maxLength;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChanged:) name:UITextViewTextDidBeginEditingNotification object:textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChanged:) name:UITextViewTextDidChangeNotification object:textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChanged:) name:UITextViewTextDidEndEditingNotification object:textView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - private
- (void)valueChanged:(NSNotification *)notification {
    UITextView *textView = [notification object];
    if (textView != self.textView) {
        return;
    }
    
    if (self.maxLength == 0) {
        return;
    }
    
    NSUInteger currentLength = [textView.text length];
    if (currentLength <= self.maxLength) {
        return;
    }
    
    NSString *subString = [textView.text substringToIndex:self.maxLength];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = subString;
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    });
}

@end