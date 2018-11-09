//
//  RSettingViewController.m
//  SmartLock
//
//  Created by Richard Shen on 2018/1/18.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import "RSettingViewController.h"
#import "UIImage+Color.h"
#import "WBAPIManager.h"

@interface RSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSArray *dataList;

@end

static NSString *RSettingCellIdentifier = @"RSettingCellIdentifier";
@implementation RSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"当前版本：v%@",infoDictionary[@"CFBundleShortVersionString"]];
    self.dataList = @[@"申报异常",version];
    self.tableView.tableFooterView = self.footerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (void)logoutClick
{
    [WBAPIManager sharedManager].loginUser = nil;
//    [WBAPIManager sharedManager].accessToken = nil;
    [[WBMediator sharedManager] gotoLoginControllerWithAnimate:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RSettingCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = HEX_RGB(0x333333);
    cell.textLabel.text = self.dataList[indexPath.section];
    
    if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    

}

#pragma mark - Getter
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
        _tableView.scrollsToTop = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.separatorColor = HEX_RGB(0xdddddd);
        _tableView.rowHeight = 51;
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.backgroundColor = RGB(235, 235, 241);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RSettingCellIdentifier];
    }
    return _tableView;
}

- (UIView *)footerView
{
    if(!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _footerView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:self.submitBtn];
    }
    return _footerView;
}

- (UIButton *)submitBtn
{
    if(!_submitBtn){
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_submitBtn setTitleColor:HEX_RGB(0xf26464) forState:UIControlStateNormal];
        [_submitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
@end
