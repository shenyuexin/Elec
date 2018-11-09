//
//  RReportView.m
//  SmartLock
//
//  Created by Richard Shen on 2018/10/31.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import "RReportView.h"
#import "WBSeparateButton.h"
#import "UITextView+Placeholder.h"
#import "WBLoginButton.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "WBMediator.h"
#import "WBDeleteButton.h"
#import "WBDataManager.h"

@interface RReportView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WBSeparateButton *closeButton;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) WBSeparateButton *successButton;
@property (nonatomic, strong) WBSeparateButton *suspicionButton;

@property (nonatomic, strong) UITextView *txtView;
@property (nonatomic, strong) UIView *picsView;
@property (nonatomic, strong) UIButton *albumButton;
@property (nonatomic, strong) WBLoginButton *reportButton;

@property (nonatomic, strong) NSMutableArray *selectPhotos;
@property (nonatomic, strong) PHImageRequestOptions *options;
@end

static NSInteger kPreviewTag = 99;
@implementation RReportView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;

        [self addSubview:self.topLineView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeButton];
        [self addSubview:self.tipLabel];
        [self addSubview:self.successButton];
        [self addSubview:self.suspicionButton];
        [self addSubview:self.txtView];
        [self addSubview:self.picsView];
        [self addSubview:self.reportButton];
    }
    return self;
}

- (void)setUser:(RUserInfo *)user
{
    _user = user;
    self.reportButton.enabled = (_user.status != RCheckStatusUnknow)?YES:NO;
    self.successButton.selected = (_user.status == RCheckStatusSuccess)?YES:NO;
    self.suspicionButton.selected = (_user.status == RCheckStatusSuspicion)?YES:NO;
    self.txtView.text = _user.remark;
    
    NSArray *array = [[WBDataManager sharedManager] picsWithUser:_user];
    self.selectPhotos = [NSMutableArray arrayWithArray:array];
}

#pragma mark - Animate
- (void)show
{
    self.transform = CGAffineTransformIdentity;
    self.hidden = NO;
    self.alpha = 1;
    [self updatePicsView];
    
    [[WBMediator sharedManager].topViewController.view addSubview:self.bgView];
    [[WBMediator sharedManager].topViewController.view addSubview:self];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.layer addAnimation:popAnimation forKey:nil];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.top = 0;
        }];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.top = ([UIScreen mainScreen].bounds.size.height - self.height)/2 - (__IPHONEX_?88:64);
        }];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNotificationPicsUpdate object:nil] subscribeNext:^(id x) {
        [self updatePicsView];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.51 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self.hidden = YES;
        [self.bgView removeFromSuperview];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReportFinish object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Method
- (void)showCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [WBLoadingView showErrorStatus:@"无法访问相机,请在'设置->窃电查处助手 中打开相机服务'"];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [[WBMediator sharedManager].topViewController presentViewController:picker animated:YES completion:nil];
}

- (void)updatePicsView
{
    if(_selectPhotos.count > 0){
        for(NSUInteger i =_selectPhotos.count; i<4; i++){
            UIButton *btn = [_picsView viewWithTag:i + kPreviewTag];
            btn.hidden = YES;
        }
        
        if(_selectPhotos.count < 4){
            UIButton *btn = [_picsView viewWithTag:_selectPhotos.count + kPreviewTag];
            self.albumButton.left = btn.left;
            [_picsView addSubview:self.albumButton];
        }
        else{
            [self.albumButton removeFromSuperview];
        }
        
        [_selectPhotos enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [_picsView viewWithTag:idx + kPreviewTag];
            btn.hidden = NO;
            CGFloat width = btn.width * kScreenScale;
            [[PHImageManager defaultManager] requestImageForAsset:asset
                                                       targetSize:CGSizeMake(width, width)
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:self.options
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        NSLog(@"image size:%@",NSStringFromCGSize(result.size));
                                                        [btn setImage:result forState:UIControlStateNormal];                                                    }];
        }];
    }
    else{
        self.albumButton.left = 0;
        [_picsView addSubview:self.albumButton];
    }
}

- (void)previewDeleteClick:(UIButton *)sender
{
    //删除功能：将后面按钮的图片往前移，隐藏最后一个
    NSInteger idx = sender.tag - kPreviewTag;
    for(NSInteger i= idx; i<_selectPhotos.count-1; i++){
        UIButton *btn = [_picsView viewWithTag:i+kPreviewTag];
        UIButton *nextBtn = [_picsView viewWithTag:i+1+kPreviewTag];
        [btn setImage:nextBtn.currentImage forState:UIControlStateNormal];
    }
    UIButton *btn = [_picsView viewWithTag:_selectPhotos.count-1 + kPreviewTag];
    btn.hidden = YES;
    [_selectPhotos removeObjectAtIndex:idx];
    
    if(_selectPhotos.count < 4){
        UIButton *btn = [_picsView viewWithTag:_selectPhotos.count + kPreviewTag];
        self.albumButton.left = btn.left;
        [_picsView addSubview:self.albumButton];
    }
}

#pragma mark - Event
- (void)closeClick
{
    [self dismiss];
}

- (void)reportClick
{
    self.user.remark = self.txtView.text;
    if(self.successButton.selected){
        self.user.status = RCheckStatusSuccess;
    }
    if(self.suspicionButton.selected){
        self.user.status = RCheckStatusSuspicion;
    }
    [self dismiss];
    [[WBDataManager sharedManager] updatePics:self.selectPhotos user:self.user];
    [[WBDataManager sharedManager] saveUsers];
}

- (void)btnClick:(UIButton *)sender
{
    if(!sender.isSelected){
        sender.selected = !sender.isSelected;
        if(sender == self.successButton){
            self.suspicionButton.selected = !sender.selected;
        }
        else{
            self.successButton.selected = !sender.selected;
        }
    }
    self.reportButton.enabled = YES;
}

- (void)albumClick:(UIButton *)sender
{
    if(_selectPhotos.count >= 4){
        [WBLoadingView showErrorStatus:@"你最多只能选择4张图片"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self showCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[WBMediator sharedManager] gotoPhotoSelectController:_selectPhotos maxCount:4];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[WBMediator sharedManager].topViewController  dismissViewControllerAnimated:YES completion:nil];
    }]];
    [[WBMediator sharedManager].topViewController  presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    __block NSString* localId;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        localId = [[assetChangeRequest placeholderForCreatedAsset] localIdentifier];
    } completionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            [WBLoadingView showErrorStatus:@"读取图片出错，请重试。"];
        } else {
            PHFetchResult* assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[localId] options:nil];
            PHAsset *asset = [assetResult firstObject];
            [_selectPhotos addObject:asset];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updatePicsView];
            });
        }
    }];
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter
- (UIView *)bgView
{
    if(!_bgView){
        _bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _bgView.backgroundColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:0.2];
        
        @weakify(self);
        [_bgView setTapActionWithBlock:^{
            @strongify(self);
            [self.txtView resignFirstResponder];
        }];
    }
    return _bgView;
}

- (UIView *)topLineView
{
    if(!_topLineView){
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(79, 29, self.width-158, 0.5)];
        _topLineView.backgroundColor = HEX_RGB(0x979797);
    }
    return _topLineView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(109, 21, 102, 16)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _titleLabel.textColor = HEX_RGB(0xaaaaaa);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"用户窃电情况";
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (WBSeparateButton *)closeButton
{
    if(!_closeButton){
        _closeButton = [[WBSeparateButton alloc] initWithFrame:CGRectMake(self.width-44, 0, 44, 44)];
        _closeButton.imageRect = CGRectMake(16, 16, 12, 12);
        [_closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)tipLabel
{
    if(!_tipLabel){
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 58, 200, 18)];
        _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _tipLabel.textColor = HEX_RGB(0x888888);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.text = @"请选择处理结果";
    }
    return _tipLabel;
}

- (WBSeparateButton *)successButton
{
    if(!_successButton){
        _successButton = [[WBSeparateButton alloc] initWithFrame:CGRectMake(15, 86, 70, 21)];
        _successButton.imageRect = CGRectMake(0, 3, 15, 15);
        _successButton.labelRect = CGRectMake(20, 0, 50, 21);
        _successButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_successButton setTitleColor:HEX_RGB(0x333333) forState:UIControlStateNormal];
        [_successButton setTitle:@"无异常" forState:UIControlStateNormal];
        [_successButton setImage:[UIImage imageNamed:@"radio_normal"] forState:UIControlStateNormal];
        [_successButton setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateSelected];
        [_successButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _successButton;
}

- (WBSeparateButton *)suspicionButton
{
    if(!_suspicionButton){
        _suspicionButton = [[WBSeparateButton alloc] initWithFrame:CGRectMake(_successButton.right+20, 86, 80, 21)];
        _suspicionButton.imageRect = CGRectMake(0, 3, 15, 15);
        _suspicionButton.labelRect = CGRectMake(20, 0, 60, 21);
        _suspicionButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_suspicionButton setTitleColor:HEX_RGB(0x333333) forState:UIControlStateNormal];
        [_suspicionButton setTitle:@"疑似用户" forState:UIControlStateNormal];
        [_suspicionButton setImage:[UIImage imageNamed:@"radio_normal"] forState:UIControlStateNormal];
        [_suspicionButton setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateSelected];
        [_suspicionButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _suspicionButton;
}

- (UITextView *)txtView
{
    if(!_txtView){
        _txtView = [[UITextView alloc] initWithFrame:CGRectMake(15, 128, self.width-30, 70)];
        _txtView.placeholder = @"处理情况描述";
        _txtView.backgroundColor = HEX_RGB(0xf7f7f7);
        _txtView.layer.borderColor = HEX_RGB(0xc3c3c3).CGColor;
        _txtView.layer.borderWidth = 0.5;
        _txtView.layer.masksToBounds = YES;
        _txtView.layer.cornerRadius = 2;
    }
    return _txtView;
}

- (WBLoginButton *)reportButton
{
    if(!_reportButton){
        _reportButton = [[WBLoginButton alloc] initWithFrame:CGRectMake(0, self.height-40, self.width, 40)];
        [_reportButton setTitle:@"处理" forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}

- (UIButton *)albumButton
{
    if(!_albumButton){
        _albumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        _albumButton.backgroundColor = HEX_RGB(0xf5f5f5);
        _albumButton.layer.cornerRadius = 4;
        _albumButton.layer.masksToBounds = YES;
        [_albumButton setImage:[UIImage imageNamed:@"上传图片图标"] forState:UIControlStateNormal];
        [_albumButton addTarget:self action:@selector(albumClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumButton;
}

- (UIView *)picsView
{
    if(!_picsView){
        _picsView = [[UIView alloc] initWithFrame:CGRectMake(15, 208, self.width-30, 85)];
        _picsView.backgroundColor = [UIColor whiteColor];
        
        CGFloat margin = 7;
        for(int i=0;i<4;i++){
            WBDeleteButton *imgButton = [[WBDeleteButton alloc] initWithFrame:CGRectMake((55+margin)*i, 0, 55, 55)];
            imgButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            imgButton.layer.cornerRadius = 2;
            imgButton.layer.masksToBounds = YES;
//            [imgButton addTarget:self action:@selector(previewClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgButton.deleteBtn addTarget:self action:@selector(previewDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
            [_picsView addSubview:imgButton];
            imgButton.tag = i + kPreviewTag;
            imgButton.hidden = YES;
        }
    }
    return _picsView;
}

- (PHImageRequestOptions *)options
{
    if(!_options){
        _options = [PHImageRequestOptions new];
        _options.synchronous = NO;
        _options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        _options.resizeMode = PHImageRequestOptionsResizeModeFast;
    }
    return _options;
}
@end
