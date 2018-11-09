//
//  WBDeleteButton.m
//  Weimai
//
//  Created by Richard Shen on 2017/4/21.
//  Copyright © 2017年 Weibo. All rights reserved.
//

#import "WBDeleteButton.h"

@implementation WBDeleteButton

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    _deleteBtn.hidden = hidden;
    
    //如果self有设置圆角，会把有类似clipsToBounds的效果
    //所以得加在superView上
    [self.superview addSubview:_deleteBtn];
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _deleteBtn.tag = tag;
}

- (UIButton *)deleteBtn
{
    if(!_deleteBtn){
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)-15, CGRectGetMinY(self.frame)-10, 25, 25)];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        [_deleteBtn setImage:[UIImage imageNamed:@"照片删除"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (void)resetDelBtn
{
    [_deleteBtn setFrame:CGRectMake(CGRectGetMaxX(self.frame)-15, CGRectGetMinY(self.frame)-10, 25, 25)];
}
@end
