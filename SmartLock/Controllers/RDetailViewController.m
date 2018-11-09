//
//  RDetailViewController.m
//  SmartLock
//
//  Created by Richard Shen on 2018/10/31.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import "RDetailViewController.h"
#import "RReportView.h"
#import <BaiduPanoSDK/BaiduPanoramaView.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

@interface RDetailViewController ()<BaiduPanoramaViewDelegate,BMKGeoCodeSearchDelegate>

@property(strong, nonatomic) BaiduPanoramaView  *panoramaView;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *topInfoView;
@property (nonatomic, strong) UILabel *consNoLabel;
@property (nonatomic, strong) UILabel *consNameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *pq4Label;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *addrLabel;

@property (nonatomic, strong) RReportView *reportView;
@end

@implementation RDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"违约窃电查处助手";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificationReportFinish object:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self updateUI];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.topInfoView];
    if(!_panoramaView.superview){
        [self.view addSubview:self.panoramaView];
    }
    [self.view addSubview:self.bottomView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_panoramaView removeFromSuperview];
    _panoramaView.delegate = nil;
}

- (void)setUser:(RUserInfo *)user
{
    _user = user;
    [self updateUI];
    // 设定全景的pid， 这是指定显示某地的全景，也可以通过百度坐标进行显示全景
    //[self.panoramaView setPanoramaWithLon:116.524737 lat:39.93015];
    //[self.panoramaView setPanoramaWithLon:113.832257 lat:22.676117];
    
    if(_user.latitude && _user.longitude){
        [self.panoramaView setPanoramaWithLon:_user.longitude.doubleValue lat:_user.latitude.doubleValue];
    }
    else{
        BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        geoCodeSearch.delegate = self;
        BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeOption.address = user.elecAddr;
        BOOL success = [geoCodeSearch geoCode:geoCodeOption];
        if(!success){
            NSLog(@"无法获取地址相应经纬度");
        }
    }
}
    

- (void)updateUI
{
    self.consNoLabel.text = _user.consNo;
    self.consNameLabel.text = _user.consName;
    self.addrLabel.text = _user.elecAddr;
    
    NSMutableAttributedString *pq4String = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前电量: %@", _user.pq4]];
    [pq4String addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0x333333),
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14]}
                       range:NSMakeRange(6, pq4String.length-6)];
    self.pq4Label.attributedText = pq4String;
    
    switch (_user.status) {
        case RCheckStatusUnknow:{
            self.topInfoView.backgroundColor = HEX_RGB(0xffffff);
            self.statusLabel.textColor = HEX_RGB(0xffac2c);
            self.statusLabel.text = @"未排查";
            break;
        }
        case RCheckStatusSuccess:{
            self.topInfoView.backgroundColor = HEX_RGB(0xe3effd);
            self.statusLabel.textColor = HEX_RGB(0x3dba9c);
            self.statusLabel.text = @"无异常";
            break;
        }
        case RCheckStatusSuspicion:{
            self.topInfoView.backgroundColor = HEX_RGB(0xffeeee);
            self.statusLabel.textColor = HEX_RGB(0xf64436);
            self.statusLabel.text = @"疑似用户";
            break;
        }
        default:
            break;
    }
}

#pragma mark - Event
- (void)buttonClick
{
    [self.reportView show];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 正向地理编码检索结果回调
 
 @param searcher 检索对象
 @param result 正向地理编码检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (error == BMK_SEARCH_NO_ERROR) {
        //初始化标注类BMKPointAnnotation的实例
        _user.latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
        _user.longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
        
        [self.panoramaView setPanoramaWithLon:_user.longitude.doubleValue lat:_user.latitude.doubleValue];
    }
}


#pragma mark - panorama view delegate
- (void)panoramaWillLoad:(BaiduPanoramaView *)panoramaView {
    
}

- (void)panoramaDidLoad:(BaiduPanoramaView *)panoramaView descreption:(NSString *)jsonStr {
    
}


- (void)panoramaLoadFailed:(BaiduPanoramaView *)panoramaView error:(NSError *)error {
    
}

- (void)panoramaView:(BaiduPanoramaView *)panoramaView overlayClicked:(NSString *)overlayId {
    
}

#pragma mark - Getter
- (UIButton *)rightButton
{
    if(!_rightButton){
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 22)];
        _rightButton.layer.cornerRadius = 10;
        _rightButton.layer.masksToBounds = YES;
        _rightButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _rightButton.layer.borderWidth = 0.5;
        _rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_rightButton setTitle:@"处理" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchDown];
    }
    return _rightButton;
}

- (UIView *)topInfoView
{
    if(!_topInfoView){
        _topInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
        _topInfoView.backgroundColor = [UIColor whiteColor];
        
        [_topInfoView addSubview:self.consNoLabel];
        [_topInfoView addSubview:self.consNameLabel];
        [_topInfoView addSubview:self.statusLabel];
        [_topInfoView addSubview:self.pq4Label];
    }
    return _topInfoView;
}

- (UILabel *)consNoLabel
{
    if(!_consNoLabel){
        _consNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.width-130, 21)];
        _consNoLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _consNoLabel.textColor = HEX_RGB(0x333333);
        _consNoLabel.numberOfLines = 1;
    }
    return _consNoLabel;
}

- (UILabel *)consNameLabel
{
    if(!_consNameLabel){
        _consNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _consNoLabel.bottom, self.view.width-130, 18)];
        _consNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _consNameLabel.textColor = HEX_RGB(0x666666);
        _consNameLabel.numberOfLines = 1;
    }
    return _consNameLabel;
}

- (UILabel *)statusLabel
{
    if(!_statusLabel){
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-130, 10, 115, 21)];
        _statusLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _statusLabel.textColor = HEX_RGB(0xffac2c);
        _statusLabel.numberOfLines = 1;
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UILabel *)pq4Label
{
    if(!_pq4Label){
        _pq4Label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-150, 32, 135, 16)];
        _pq4Label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _pq4Label.textColor = HEX_RGB(0x777777);
        _pq4Label.numberOfLines = 1;
        _pq4Label.textAlignment = NSTextAlignmentRight;
    }
    return _pq4Label;
}

- (BaiduPanoramaView *)panoramaView
{
    if(!_panoramaView){
        _panoramaView = [[BaiduPanoramaView alloc] initWithFrame:CGRectMake(0, _topInfoView.bottom, self.view.width, self.view.height-60-77) key:@"2umYcgHG6UFiuRK0Ubjdw554aoKjVx5K"];
        // 为全景设定一个代理
        _panoramaView.delegate = self;
        // 设定全景的清晰度， 默认为middle
        [self.panoramaView setPanoramaImageLevel:ImageDefinitionHigh];
    }
    return _panoramaView;
}

- (UIView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-77, self.view.width, 77)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:self.addrLabel];
    }
    return _bottomView;
}

- (UILabel *)addrLabel
{
    if(!_addrLabel){
        _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, self.view.width-30, 24)];
        _addrLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _addrLabel.textColor = HEX_RGB(0x333333);
        _addrLabel.numberOfLines = 1;
        _addrLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _addrLabel;
}

- (RReportView *)reportView
{
    if(!_reportView){
        _reportView = [[RReportView alloc] initWithFrame:CGRectMake((self.view.width-320)/2, ([UIScreen mainScreen].bounds.size.height-350)/2-(__IPHONEX_?88:64), 320, 350)];
        _reportView.user = self.user;
    }
    return _reportView;
}
@end
