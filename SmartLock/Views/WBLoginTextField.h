//
//  WBLoginTextField.h
//  Weimai
//
//  Created by Richard Shen on 16/1/26.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBLoginTextField : UITextField

@property (nonatomic, assign) NSInteger leftWidth;
@property (nonatomic, strong) UIFont *placeholderFont;

@property (nonatomic, weak) UIView *rightPresentView;
@end

@interface WBNameTextField : WBLoginTextField
@end

@interface WBPhoneTextField : WBLoginTextField
@end

@interface WBPasswordTextField : WBLoginTextField
@end

@interface WBCodeTextField : WBLoginTextField

@property (nonatomic, weak)   UITextField *phoneTextfield;
@property (nonatomic, assign) BOOL needRegister;
@property (nonatomic, assign) BOOL isBind;          //是否为微博登录绑定
@end
