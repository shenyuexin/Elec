//
//  RLoginViewController.m
//  SmartLock
//
//  Created by Richard Shen on 2018/1/12.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import "RLoginViewController.h"
#import "WBLoginTextField.h"
#import "WBLoginButton.h"
#import "WBDataManager.h"
#import "WBAPIManager.h"

@interface RLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *topBgImgView;
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) WBNameTextField *phoneTextField;
@property (nonatomic, strong) WBPasswordTextField *codeTextField;
@property (nonatomic, strong) WBLoginButton *loginBtn;
@end

@implementation RLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.top = - 130;
        }];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.top = 0;
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.topBgImgView];
    [self.view addSubview:self.logoImgView];
    [self.view addSubview:self.nameLabel];
    
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.loginBtn];
    
    self.phoneTextField.text = @"13906523619";
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - Event
- (void)hideKeyBoard
{
    [UIView animateWithDuration:0.3 animations:^{
//        self.view.top = 0;
        [self.view endEditing:YES];
    }];
}

- (void)loginClick:(UIButton *)sender
{    
    if(![self.phoneTextField.text isNotEmpty]){
        [WBLoadingView showErrorStatus:@"请输入用户名"];
        return;
    }

    if(![self.codeTextField.text isNotEmpty]){
        [WBLoadingView showErrorStatus:@"请输入密码"];
        return;
    }
    
    [self hideKeyBoard];
    
    
    RAccountInfo *account = [[WBDataManager sharedManager] loginWithPhone:self.phoneTextField.text pwd:self.codeTextField.text];
    if(account){
        [[WBAPIManager sharedManager] setLoginUser:account];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [WBLoadingView showErrorStatus:@"账号或密码错误"];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _phoneTextField){
        [_codeTextField becomeFirstResponder];
        return YES;
    }
    else{
        if([_phoneTextField.text isNotEmpty] && [_codeTextField.text isNotEmpty]){
            [self loginClick:nil];
            return YES;
        }
        else{
            return NO;
        }
    }
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.top = - 130;
//    }];
//    return YES;
//}

#pragma mark - Getter
- (UIImageView *)topBgImgView
{
    if(!_topBgImgView){
        _topBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*224)];
        _topBgImgView.image = [UIImage imageNamed:@"background"];
    }
    return _topBgImgView;
}

- (UIImageView *)logoImgView
{
    if(!_logoImgView){
        _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, self.topBgImgView.top+100, 70, 70)];
        _logoImgView.image = [UIImage imageNamed:@"logosmall"];
    }
    return _logoImgView;
}

- (UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.logoImgView.bottom+13, SCREEN_WIDTH, 14)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = HEX_RGB(0x333333);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"违约窃电查处助手";
    }
    return _nameLabel;
}

- (WBNameTextField *)phoneTextField
{
    if(!_phoneTextField){
        _phoneTextField = [[WBNameTextField alloc] initWithFrame:CGRectMake(25, self.nameLabel.bottom+79, SCREEN_WIDTH-50, 48)];
        _phoneTextField.placeholder = @"用户名";
        _phoneTextField.returnKeyType = UIReturnKeyNext;
        _phoneTextField.delegate = self;
    }
    return _phoneTextField;
}

- (WBPasswordTextField *)codeTextField
{
    if(!_codeTextField){
        _codeTextField = [[WBPasswordTextField alloc] initWithFrame:CGRectMake(self.phoneTextField.left, self.phoneTextField.bottom+10, self.phoneTextField.width, self.phoneTextField.height)];
        _codeTextField.placeholder = @"密码";
        _codeTextField.returnKeyType = UIReturnKeyJoin;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
}

- (WBLoginButton *)loginBtn
{
    if(!_loginBtn){
        _loginBtn = [[WBLoginButton alloc] initWithFrame:CGRectMake(self.phoneTextField.left, self.codeTextField.bottom+24, self.phoneTextField.width, 40)];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.layer.cornerRadius = 2;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}
@end
