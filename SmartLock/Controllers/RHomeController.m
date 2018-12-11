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
#import "WBSegView.h"
#import "WBPopView.h"

@interface RHomeController ()<UITableViewDelegate, UITableViewDataSource, WBSegViewDelegate>

@property (nonatomic, strong) UIImageView *launchImgView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) WBPopView *popView;
@property (nonatomic, strong) WBSegView *segView;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *mapBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshNormalHeader *header;
@property (nonatomic, strong) UILabel *measureLabel;
@property (nonatomic, weak)   WBDataManager *dataManager;
@property (nonatomic, weak)   WBAPIManager *apiManager;
@property (nonatomic, strong) NSDictionary *userDic;
@property (nonatomic, strong) NSArray *users;
@end

@implementation RHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.titleBtn];
    self.navigationItem.title = @"违约窃电查处助手";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataManager = [WBDataManager sharedManager];
    self.apiManager = [WBAPIManager sharedManager];
    [self.view addSubview:self.segView];
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    [[RACObserve(self.popView, selectIndex) skip:1] subscribeNext:^(NSNumber *value) {
        @strongify(self);
        if([value integerValue] == 0){
            [self updateData:self.dataManager.loginUsers title:@"我的管辖"];
        }
        else{
            [self updateData:self.dataManager.allUsers title:@"全部"];
        }
    }];
    
    [RACObserve(self.apiManager, loginUser) subscribeNext:^(RAccountInfo *user) {
        @strongify(self);
        if(user){
            if(self.dataManager.loginUsers.allValues.count <= 0){
                //登录用户没有数据时，读取全部
                [self updateData:self.dataManager.allUsers title:@"全部"];
            }
            else{
                [self updateData:self.dataManager.loginUsers title:@"我的管辖"];
            }
        }
    }];
    
    UIWindow *widow = [[UIApplication sharedApplication] keyWindow];
    [widow addSubview:self.launchImgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                                                                                                                                                        
- (void)updateData:(NSDictionary *)data title:(NSString *)title
{
    self.userDic = data;
    NSUInteger count = ((NSArray *)self.userDic[@(RCheckStatusUnknow)]).count;
    NSUInteger count1 = ((NSArray *)self.userDic[@(RCheckStatusSuspicion)]).count;
    NSUInteger count2 = ((NSArray *)self.userDic[@(RCheckStatusSuccess)]).count;
    self.segView.itmes = @[[NSString stringWithFormat:@"未排查(%lu)",(unsigned long)count],
                           [NSString stringWithFormat:@"疑似用户(%lu)",(unsigned long)count1],
                           [NSString stringWithFormat:@"无异常(%lu)",(unsigned long)count2]];
    [self.segView setSelectIndex:0];
    
    NSMutableAttributedString *btnTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    NSTextAttachment *attachment = [NSTextAttachment new];
    attachment.image = [UIImage imageNamed:@"icon_down"];
    attachment.bounds = CGRectMake(0, 1, 9, 5);
    [btnTitle appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    [self.titleBtn setAttributedTitle:btnTitle forState:UIControlStateNormal];

    self.users = self.userDic[@(RCheckStatusUnknow)];
    [self.tableView reloadData];
}
#pragma mark - Data
- (void)fetchData
{
    [self updateData:(self.popView.selectIndex==0)?self.dataManager.loginUsers:self.dataManager.allUsers  title:self.popView.selectTitle];
    
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

- (void)titleClick
{
    [self.view addSubview:self.popView];
}

#pragma mark - WBSegViewDelegate
- (void)segView:(WBSegView *)segView selectIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            self.users = self.userDic[@(RCheckStatusUnknow)];
            break;
        case 1:
            self.users = self.userDic[@(RCheckStatusSuspicion)];
            break;
        case 2:
            self.users = self.userDic[@(RCheckStatusSuccess)];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
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
    return self.users.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RUserInfo *user = self.users[indexPath.section];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    CGFloat addrHeight = [[NSString stringWithFormat:@"%@  ",user.elecAddr] sizeWithFont:font byWidth:SCREEN_WIDTH- 30].height;
    CGFloat mrHeight = [[NSString stringWithFormat:@"%@:  ",user.mrSectName] sizeWithFont:font byWidth:SCREEN_WIDTH- 150].height;
    CGFloat height =  149 + (MAX(addrHeight, 16)- 16) + (MAX(mrHeight, 16)-16);
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(RUserCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RUserInfo *user = self.users[indexPath.section];
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
    
    RUserInfo *user = self.users[indexPath.section];
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

- (WBPopView *)popView
{
    if(!_popView){
        _popView = [[WBPopView alloc] initWithPopFrame:CGRectMake(15, 10, 75, 70)];
        _popView.titles = @[@"我的管辖", @"全部"];
    }
    return _popView;
}

- (WBSegView *)segView
{
    if(!_segView){
        _segView = [[WBSegView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _segView.backgroundColor = [UIColor whiteColor];
        _segView.selectColor = HEX_RGB(0x3684b5);
        _segView.delegate = self;
        _segView.itmes = @[@"未排查",@"疑似用户",@"无异常"];
    }
    return _segView;
}

- (UIButton *)titleBtn
{
    if(!_titleBtn){
        _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleBtn addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchDown];
    }
    return _titleBtn;
}

- (UIView *)rightView
{
    if(!_rightView){
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
        _rightView.backgroundColor = [UIColor clearColor];
        [_rightView addSubview:self.mapBtn];
        [_rightView addSubview:self.settingBtn];
    }
    return _rightView;
}

- (UIButton *)settingBtn
{
    if(!_settingBtn){
        _settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.mapBtn.right, 0, 44, 44)];
//        _settingBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 20, 20);
        [_settingBtn setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchDown];
    }
    return _settingBtn;
}

- (UIButton *)mapBtn
{
    if(!_mapBtn){
        _mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//        _mapBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 20, 20);
        [_mapBtn setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
        [_mapBtn addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchDown];
    }
    return _mapBtn;
}

- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height-44) style:UITableViewStyleGrouped];
        _tableView.scrollsToTop = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsZero;
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

- (UILabel *)measureLabel
{
    if(!_measureLabel){
        _measureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-150, 16)];
        _measureLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _measureLabel.numberOfLines = 0;
    }
    return _measureLabel;
}
@end
