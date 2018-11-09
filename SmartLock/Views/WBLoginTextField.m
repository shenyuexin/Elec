//
//  WBLoginTextField.m
//  Weimai
//
//  Created by Richard Shen on 16/1/26.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "WBLoginTextField.h"
#import "UITextField+Limit.h"
#import "UICountingLabel.h"
//#import "WBAPIManager+Bussiness.h"
#import "UITextField+CNLimit.h"
#import "UIView+BorderLine.h"

@interface WBLoginTextField()

@end

@implementation WBLoginTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){        
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:14];
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.layer.borderColor = HEX_RGB(0xcccccc).CGColor;
        self.layer.borderWidth = PX1;
        
        _leftWidth = 0;
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if(!_placeholderFont){
        _placeholderFont = [UIFont systemFontOfSize:14];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attributedString addAttributes:@{NSFontAttributeName:_placeholderFont, NSForegroundColorAttributeName:RGB(193, 193, 193)} range:NSMakeRange(0, attributedString.length)];
    self.attributedPlaceholder = attributedString;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x = bounds.origin.x + _leftWidth + 10;
    bounds.size.width -= 50;
    //    bounds.origin.y += 3;
    return bounds;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    bounds.origin.x = bounds.origin.x + _leftWidth + 10;
    //    bounds.origin.y += 2;
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x = bounds.origin.x + _leftWidth + 10;
    //    bounds.origin.y = 2;
    bounds.size.width -= 50;
    return bounds;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect frame = self.leftView.frame;
    frame.origin.x = 12;
    frame.origin.y = (self.height - frame.size.height)/2;
    return frame;
}

@end

@implementation WBNameTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_username"]];
        self.leftWidth = 29;
        self.maxzhLength = 30;
    }
    return self;
}

@end

@implementation WBPhoneTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 22)];
        imgView.image = [UIImage imageNamed:@"login_username"];
        self.leftView = imgView;
        self.keyboardType = UIKeyboardTypePhonePad;
        self.leftWidth = 29;
        self.maxLength = 30;
    }
    return self;
}

@end

@interface WBPasswordTextField()

@property (nonatomic, strong) UIButton *seeBtn;
@end

@implementation WBPasswordTextField

- (instancetype)initWithFrame:(CGRect)frame
{
//    frame.size.width -= 27;
    self = [super initWithFrame:frame];
    if(self){
        self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.secureTextEntry = YES;
        self.leftWidth = 29;
        self.maxLength = 30;
    }
    return self;
}

- (void)setRightPresentView:(UIView *)rightPresentView
{
    [super setRightPresentView:rightPresentView];
    [rightPresentView addSubview:self.seeBtn];
}

- (void)seeBtnClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    self.secureTextEntry = !sender.selected;
    
    NSString *tmpString = self.text;
    self.text = @"";
    self.text = tmpString;
}

- (UIButton *)seeBtn
{
    if(!_seeBtn){
        _seeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.right+2, CGRectGetMidY(self.frame)-11, 22, 22)];
        [_seeBtn setImage:[UIImage imageNamed:@"查看密码"] forState:UIControlStateNormal];
        [_seeBtn setImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateSelected];
        [_seeBtn addTarget:self action:@selector(seeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeBtn;
}

@end

@interface WBCodeTextField()

@property (nonatomic, strong) UICountingLabel *countLabel;
@property (nonatomic, strong) UIButton *codeBtn;
@end

@implementation WBCodeTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    //    frame.size.width -= 90;
    self = [super initWithFrame:frame];
    if(self){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 16)];
        imgView.image = [UIImage imageNamed:@"yanzheng"];
        self.leftView = imgView;
        self.keyboardType = UIKeyboardTypeNumberPad;
        
        self.layer.borderWidth = 0;
        
        [self addBorderLine:BorderLeft|BorderTop|BorderBottom];
        
        self.leftWidth = 29;
        self.maxLength = 6;
    }
    return self;
}

- (void)dealloc
{
    if ([_countLabel respondsToSelector:@selector(freeBlock)]) {
        [_countLabel freeBlock];
    }
    //[_countLabel freeBlock];
}

- (void)setRightPresentView:(UIView *)rightPresentView
{
    [super setRightPresentView:rightPresentView];
    [rightPresentView addSubview:self.codeBtn];
}

//- (CGRect)clearButtonRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(self.width-120, (self.height-14)/2, 14, 14);
//}

- (void)codeBtnClick:(UIButton *)sender
{
//    [[WBAPIManager getSmsCode:_phoneTextfield.text] subscribeError:^(NSError *error) {
//        [WBLoadingView showErrorStatus:error.domain];
//    } completed:^{
//        [self startCountDown];
//    }];
}

- (void)setPhoneTextfield:(UITextField *)phoneTextfield
{
    _phoneTextfield = phoneTextfield;
    
    @weakify(self);
    RAC(self.countLabel, textColor) = [phoneTextfield.rac_textSignal map:^id(NSString *value)
                                       {
                                           @strongify(self);
                                           if([value isTelephone] && !self.countLabel.isCounting)
                                               return HEX_RGB(0x64a2f2);
                                           return RGB(177, 177, 177);
                                       }];
    
    RAC(self.codeBtn, enabled) = [phoneTextfield.rac_textSignal map:^id(NSString *value)
                                  {
                                      @strongify(self);
                                      if([value isTelephone] && !self.countLabel.isCounting)
                                          return @(YES);
                                      return @(NO);
                                  }];
}

- (void)startCountDown
{
    @weakify(self);
    self.countLabel.completionBlock = ^{
        @strongify(self);
        self.countLabel.text = @"重新获取";
        self.codeBtn.enabled = [self.phoneTextfield.text isTelephone];
        self.countLabel.textColor = [self.phoneTextfield.text isTelephone]?HEX_RGB(0x64a2f2):RGB(177, 177, 177);
    };
    
    self.codeBtn.enabled = NO;
    self.countLabel.textColor = RGB(177, 177, 177);
    [self.countLabel countFrom:60 to:0 withDuration:60];
}

- (UIButton *)codeBtn
{
    if(!_codeBtn){
        _codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.right, self.top, 85, self.height)];
        _codeBtn.backgroundColor = [UIColor clearColor];
        [_codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_codeBtn addBorderLine:BorderLeft withHeight:30];
        [_codeBtn addBorderLine:BorderBottom|BorderTop|BorderRight];
    }
    return _codeBtn;
}

- (UICountingLabel *)countLabel
{
    if(!_countLabel){
        _countLabel = [[UICountingLabel alloc] initWithFrame:self.codeBtn.bounds];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = HEX_RGB(0x64a2f2);
        _countLabel.format = @"%d秒后重发";
        _countLabel.text = @"获取验证码";
        _countLabel.method = UILabelCountingMethodLinear;
        [self.codeBtn addSubview:_countLabel];
    }
    return _countLabel;
}
@end

