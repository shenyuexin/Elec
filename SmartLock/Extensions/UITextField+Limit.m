//
//  UITextField+Limit.m
//  BlockDemo
//
//  Created by Richard Shen on 15/9/5.
//  Copyright (c) 2015年 Richard Shen. All rights reserved.
//

#import "UITextField+Limit.h"
#import "objc/runtime.h"

@implementation UITextField (Limit)

static char textFieldMaxNumKey;

- (void)setMaxLength:(NSUInteger)maxLength
{
    objc_setAssociatedObject(self, &textFieldMaxNumKey, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if(maxLength >0){
        [self addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
    }
    else
    {
        [self removeTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
    }
}

- (NSUInteger)maxLength
{
    return [objc_getAssociatedObject(self, &textFieldMaxNumKey) unsignedIntegerValue];
}


#pragma mark - ValueChange
- (void)valueChange:(UITextField *)textField
{
    if(self.maxLength <= 0)
        return;
    
    if(textField.text.length <= self.maxLength)
        return;
    
    NSString *toBeString = textField.text;
    NSString *string = nil;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > self.maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
            if (rangeIndex.length == 1)
            {
                string = [toBeString substringToIndex:self.maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
                string = [toBeString substringWithRange:rangeRange];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            textField.text = @"";
            textField.text = string;
            [textField sendActionsForControlEvents:UIControlEventEditingChanged];
        });
    }
}
@end
