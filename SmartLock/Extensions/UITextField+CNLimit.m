//
//  UITextFile+CNLimit.m
//  Weimai
//
//  Created by 勃 陈 on 16/4/27.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UITextField+CNLimit.h"
#import "NSString+BeeExtension.h"
#import "objc/runtime.h"

@implementation UITextField (CNLimit)

static char textFieldZhMaxNumKey;

- (void)setMaxzhLength:(NSUInteger)maxzhLength
{
    objc_setAssociatedObject(self, &textFieldZhMaxNumKey, @(maxzhLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if(maxzhLength >0){
        [self addTarget:self action:@selector(valueChangeZh:) forControlEvents:UIControlEventAllEditingEvents];
    }else
    {
        [self removeTarget:self action:@selector(valueChangeZh:) forControlEvents:UIControlEventAllEditingEvents];
    }
}


- (NSUInteger)maxzhLength
{
    return [objc_getAssociatedObject(self, &textFieldZhMaxNumKey) unsignedIntegerValue];
}

- (NSString *)fit:(NSString *)souceStr  len:(NSUInteger)zhLength
{
    if (souceStr.chineseLength <= zhLength) {
        return souceStr;
    }
    if (souceStr.length > 3) {
        return [self fit:[souceStr substringToIndex:souceStr.length-1] len:zhLength];
    }
    
    return souceStr;
}

#pragma mark - ValueChange
- (void)valueChangeZh:(UITextField *)textField
{
    if(self.maxzhLength <= 0)
        return;
    
    if(textField.text.chineseLength <= self.maxzhLength)
        return;
    
    NSString *toBeString = textField.text;
    NSString *string = nil;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.chineseLength > self.maxzhLength)
        {
            string = [self fit:toBeString len:self.maxzhLength];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            textField.text = @"";
            textField.text = string;
            [textField sendActionsForControlEvents:UIControlEventEditingChanged];
        });
    }
}
@end
