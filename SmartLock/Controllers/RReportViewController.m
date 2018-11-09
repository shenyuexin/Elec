//
//  RReportViewController.m
//  SmartLock
//
//  Created by Richard Shen on 2018/1/17.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import "RReportViewController.h"
#import "RReportCell.h"
#import "UIImage+Color.h"
#import "WBAPIManager+Bussiness.h"

@interface RReportViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) NSArray *dataList;
@end

@implementation RReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"申报异常";
    self.dataList = @[@"输入密码无法开锁",
                      @"IC磁卡无法开锁",
                      @"电池过期",
                      @"锁键位损坏",
                      @"人脸验证失败"];
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

- (void)submitClick
{
    NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
    if(selectIndexPath){
        RReportCell *cell = [self.tableView cellForRowAtIndexPath:selectIndexPath];
        NSString *reason = cell.txtField.text;
        NSString *serialNum = [WBAPIManager sharedManager].loginUser.serialNum;
        [[WBAPIManager reportBug:reason serialNum:serialNum] subscribeNext:^(id x) {
            [WBLoadingView showSuccessStatus:@"异常申报成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(NSError *error) {
            [WBLoadingView showErrorStatus:error.domain];
        }];
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RReportCell *cell = [tableView dequeueReusableCellWithIdentifier:RReportCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.txtField.enabled = NO;
    if (indexPath.row == self.dataList.count) {
    }
    else{
        cell.txtField.text = self.dataList[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataList.count) {
        RReportCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.txtField.enabled = YES;
        [cell.txtField becomeFirstResponder];
    }
    else{
        RReportCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataList.count-1 inSection:0]];
        [cell.txtField resignFirstResponder];
    }
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
        _tableView.scrollsToTop = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
        _tableView.separatorColor = HEX_RGB(0xdddddd);
        _tableView.rowHeight = 51;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = RGB(235, 235, 241);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.allowsMultipleSelection = NO;
        [_tableView registerClass:[RReportCell class] forCellReuseIdentifier:RReportCellIdentifier];
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
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 40)];
        _submitBtn.layer.cornerRadius = 4;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_submitBtn setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0x5f9ff3)] forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
@end
