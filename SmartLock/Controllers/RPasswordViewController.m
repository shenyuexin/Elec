//
//  RPasswordViewController.m
//  SmartLock
//
//  Created by Richard Shen on 2018/1/18.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import "RPasswordViewController.h"
#import "UITextField+Limit.h"
#import "UIView+BorderLine.h"
#import "UIImage+Color.h"
#import "WBLoginTextField.h"
//#import "WBAPIManager+Bussiness.h"

@interface RPasswordViewController ()

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) WBLoginTextField *textField;
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation RPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"开锁密码";
    self.view.backgroundColor = RGB(235, 235, 241);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.submitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (void)backClick
{
    [_textField resignFirstResponder];
    if(_textField.text.isNotEmpty){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"您要放弃所做的更改吗?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)submitClick
{
    if(self.textField.text.length < 6){
        [WBLoadingView showErrorStatus:@"密码不能低于6位"];
        return;
    }
    
//    NSString *serialNum = [WBAPIManager sharedManager].loginUser.serialNum;
//    [[WBAPIManager modifyPassword:self.textField.text serialNum:serialNum] subscribeNext:^(id x) {
//        [WBLoadingView showSuccessStatus:@"修改开锁密码成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//    } error:^(NSError *error) {
//        [WBLoadingView showErrorStatus:error.domain];
//    }];
}

#pragma mark - Getter
- (UILabel *)tipLabel
{
    if(!_tipLabel){
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 15)];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = HEX_RGB(0x666666);
        _tipLabel.text = @"修改开锁密码";
    }
    return _tipLabel;
}

- (UITextField *)textField
{
    if(!_textField){
        _textField = [[WBLoginTextField alloc] initWithFrame:CGRectMake(0, self.tipLabel.bottom+8, self.view.width, 51)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = RGB(51, 51, 51);
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.maxLength = 30;
        _textField.placeholder = @"请输入";
        _textField.leftWidth = 5;
        _textField.layer.borderWidth = 0;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (UIButton *)submitBtn
{
    if(!_submitBtn){
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.textField.bottom+40, SCREEN_WIDTH-20, 40)];
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_submitBtn setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0x5f9ff3)] forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
@end
