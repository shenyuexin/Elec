//
//  RHomeController.m
//  SmartLock
//
//  Created by Richard Shen on 2018/1/9.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import "RHomeController.h"
#import "WBAPIManager.h"
#import "WBDataManager.h"
#import "RUserCell.h"
#import "MJRefreshNormalHeader.h"

@interface RHomeController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *launchImgView;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *mapBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *header;
@property (nonatomic, weak)   WBDataManager *dataManager;
@end

@implementation RHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.mapBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingBtn];
    self.navigationItem.title = @"违约窃电查处助手";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataManager = [WBDataManager sharedManager];
    
    [self.view addSubview:self.tableView];
    UIWindow *widow = [[UIApplication sharedApplication] keyWindow];
    [widow addSubview:self.launchImgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(![WBAPIManager isLogin]){
        [[WBMediator sharedManager] gotoLoginControllerWithAnimate:NO];
    }
    else{
        [self fetchData];
    }
    [_launchImgView removeFromSuperview];_launchImgView = nil;
}

#pragma mark - Data
- (void)fetchData
{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - Event
- (void)settingClick
{
    [[WBMediator sharedManager] gotoSettingController];
}

- (void)mapClick
{
    [[WBMediator sharedManager] gotoMapViewController];
}

#pragma mark - UITabelView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataManager.users.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(RUserCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RUserInfo *user = self.dataManager.users[indexPath.section];
    cell.user = user;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RUserCell *cell = [tableView dequeueReusableCellWithIdentifier:RUserCellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    RUserInfo *user = self.dataManager.users[indexPath.section];
    [[WBMediator sharedManager] gotoDetailViewController:user];
}

#pragma mark - Getter
- (UIImageView *)launchImgView
{
    if(!_launchImgView){
        CGSize viewSize = self.view.bounds.size;
        NSString *launchImage = nil;
        NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
        for (NSDictionary* dict in imagesDict){
            CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            if (CGSizeEqualToSize(imageSize, viewSize)){
                launchImage = dict[@"UILaunchImageName"];
            }
        }
        _launchImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _launchImgView.image = [UIImage imageNamed:launchImage];
    }
    return _launchImgView;
}

- (UIButton *)settingBtn
{
    if(!_settingBtn){
        _settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//        _settingBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 20, 20);
        [_settingBtn setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchDown];
    }
    return _settingBtn;
}

- (UIButton *)mapBtn
{
    if(!_mapBtn){
        _mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.settingBtn.right, 0, 44, 44)];
//        _mapBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 20, 20);
        [_mapBtn setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
        [_mapBtn addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchDown];
    }
    return _mapBtn;
}

- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
        _tableView.scrollsToTop = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsZero;
//        _tableView.separatorColor = Color_Line;
//        _tableView.backgroundColor = Color_Background;
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.sectionFooterHeight = 10;
        _tableView.rowHeight = 149;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[RUserCell class] forCellReuseIdentifier:RUserCellIdentifier];
        _tableView.mj_header = self.header;
    }
    return _tableView;
}

- (MJRefreshNormalHeader *)header
{
    if(!_header){
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchData)];
        _header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    return _header;
}
@end
