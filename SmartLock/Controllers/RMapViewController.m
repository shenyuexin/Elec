//
//  RMapViewController.m
//  SmartLock
//
//  Created by Richard Shen on 2018/10/31.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import "RMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BMKLocationKit/BMKLocationManager.h>
#import "WBDataManager.h"
#import <CoreLocation/CoreLocation.h>
#import "RPaopaoView.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

@interface RAnnotationView : BMKAnnotationView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) RPaopaoView *rView;
@property (nonatomic, strong) RUserInfo *user;
@end

@implementation RAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 21, 32);
        [self addSubview:self.imgView];
        [self addSubview:self.titleLabel];
        
        self.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:self.rView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
}

- (void)setUser:(RUserInfo *)user
{
    _user = user;
    self.rView.user = user;
}

- (UIImageView *)imgView
{
    if(!_imgView){
        _imgView = [[UIImageView alloc] initWithFrame:self.frame];
    }
    return _imgView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (RPaopaoView *)rView
{
    if(!_rView){
        _rView = [[RPaopaoView alloc] initWithFrame:CGRectMake(0, 0, 315, 128)];
    }
    return _rView;
}
@end


@interface RMapViewController ()<BMKMapViewDelegate, BMKLocationManagerDelegate, BMKGeoCodeSearchDelegate>
{
    NSUInteger curIdx;
}
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
@property (nonatomic, strong) BMKLocationViewDisplayParam *displayParam;
@property (nonatomic, weak)   WBDataManager *dataManager;
@property (nonatomic, assign) BOOL isLocationed;
@end

@implementation RMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"地图模式";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    self.dataManager = [WBDataManager sharedManager];
    [self addAnnotation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.mapView];
    [self.mapView viewWillAppear];
    
//    [self.locationManager startUpdatingLocation];
//    [self.locationManager startUpdatingHeading];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
}

#pragma mark - Event
- (void)addAnnotation
{
    while (curIdx < self.dataManager.users.count) {
        RUserInfo *user = self.dataManager.users[curIdx];
        if(user.longitude && user.latitude){
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%lu",(long)(curIdx+1)];
            annotation.coordinate = CLLocationCoordinate2DMake(user.latitude.doubleValue, user.longitude.doubleValue);
            [self.mapView addAnnotation:annotation];
            curIdx ++;
        }
        else{
            BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
            geoCodeSearch.delegate = self;
            BMKGeoCodeSearchOption *geoCodeOption = [[BMKGeoCodeSearchOption alloc]init];
            geoCodeOption.address = user.elecAddr;
            BOOL success = [geoCodeSearch geoCode:geoCodeOption];
            if(!success){
                user.longitude = nil;
                user.latitude = nil;
                curIdx ++;
            }
            else{
                break;
            }
        }
    }
}


#pragma mark - BMKAnnotationView
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        RAnnotationView *annotationView = (RAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[RAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        NSUInteger idx = [annotation.title integerValue] - 1;
        if(idx < self.dataManager.users.count){
            RUserInfo *user = self.dataManager.users[idx];
            switch (user.status) {
                case RCheckStatusUnknow:{
                    annotationView.imgView.image = [UIImage imageNamed:@"icon_map_position_yellow"];
                    break;
                }
                case RCheckStatusSuccess:{
                    annotationView.imgView.image = [UIImage imageNamed:@"icon_map_position_green"];
                    break;
                }
                case RCheckStatusSuspicion:{
                    annotationView.imgView.image = [UIImage imageNamed:@"icon_map_position_red"];
                    break;
                }
                default:
                    break;
            }
            annotationView.titleLabel.text = [NSString stringWithFormat:@"%lu",(long)(idx+1)];
            annotationView.user = user;
        }
        
        if(idx == 0){
            [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
//    [self.mapView setCenterCoordinate:view.annotation.coordinate animated:NO];
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
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = [NSString stringWithFormat:@"%lu",(long)(curIdx+1)];
        annotation.coordinate = result.location;
        [self.mapView addAnnotation:annotation];
        
        RUserInfo *user = self.dataManager.users[curIdx];
        user.latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
        user.longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
        
        curIdx++;
        [self addAnnotation];
    }
}

#pragma mark - BMKLocationManagerDelegate
/**
 @brief 当定位发生错误时，会调用代理的此方法
 @param manager 定位 BMKLocationManager 类
 @param error 返回的错误，参考 CLError
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"定位失败");
}

/**
 @brief 该方法为BMKLocationManager提供设备朝向的回调方法
 @param manager 提供该定位结果的BMKLocationManager类的实例
 @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    NSLog(@"用户方向更新");
    self.userLocation.heading = heading;
    [self.mapView updateLocationData:self.userLocation];
}

/**
 @brief 连续定位回调函数
 @param manager 定位 BMKLocationManager 类
 @param location 定位结果，参考BMKLocation
 @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    self.userLocation.location = location.location;
    //实现该方法，否则定位图标不出现
    [self.mapView updateLocationData:self.userLocation];
    if(!_isLocationed){
        _isLocationed = YES;
        [self.mapView setCenterCoordinate:location.location.coordinate animated:YES];
    }
}

#pragma mark - Getter
- (BMKMapView *)mapView
{
    if(!_mapView){
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _mapView.delegate = self;
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.zoomLevel = 15;
    }
    return _mapView;
}

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

- (BMKLocationViewDisplayParam *)displayParam
{
    if(!_displayParam){
        _displayParam = [[BMKLocationViewDisplayParam alloc] init];
        
//        _displayParam.locationViewOffsetX = 0;
//        _displayParam.locationViewOffsetY = 0;
        //设置定位图层locationView在最上层(也可设置为在下层)
        _displayParam.locationViewHierarchy = LOCATION_VIEW_HIERARCHY_TOP;
        //设置显示精度圈
        _displayParam.isAccuracyCircleShow = YES;
    }
    return _displayParam;
}
@end
