//
//  WBPhotoSelectController.m
//  Weimai
//
//  Created by Richard Shen on 16/4/9.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBPhotoSelectController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WBPhotoSelectCollectionCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Resize.h"
#import <Photos/Photos.h>
#import "WBSeparateButton.h"

@interface WBPhotoSelectController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *selectIndexPaths;
@property (nonatomic, strong) PHFetchOptions *fetchOption;
@property (nonatomic, strong) PHFetchResult *fetchResults;
@property (nonatomic, strong) PHImageRequestOptions *options;
@property (nonatomic, strong) NSMutableArray *tempArray;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) WBSeparateButton *backBtn;

@end

@implementation WBPhotoSelectController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkPhotoAuthorization];
    
    self.navigationItem.title = @"照片";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextBtn];;
//     self.navBar.rightBarButton.enabled = NO;
    
    self.fetchResults = [PHAsset fetchAssetsWithOptions:self.fetchOption];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.collectionView];
}

- (void)setSelectPhotos:(NSMutableArray *)selectPhotos
{
    _selectPhotos = selectPhotos;
    _tempArray = [NSMutableArray arrayWithArray:selectPhotos];
}

- (void)checkPhotoAuthorization
{
    // 获取当前应用对照片的访问授权状态，如果没有获取访问授权，则引导用户开启授权
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:settingURL];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"请在设备的\"设置-隐私-照片\"选项中，允许\"赚实惠\"访问你的手机相册"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        if(canOpenURL){
            [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [[UIApplication sharedApplication] openURL:settingURL];
            }]];
        }
        
        [alert addAction:[UIAlertAction actionWithTitle:canOpenURL?@"取消":@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Event
- (void)nextClick:(UIBarButtonItem *)sender
{
    [_selectPhotos removeAllObjects];
    [_selectPhotos addObjectsFromArray:_tempArray];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPicsUpdate object:nil];
}

- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问相机,请在'设置->窃电查处助手 中打开相机服务'" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        [alert show];
        return;
    }
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchResults.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBPhotoSelectCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WBPhotoSelectCellIdentifier forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.imgView.image = [UIImage imageNamed:@"拍照图标"];
        cell.assetIdentifier = nil;
    }
    else{
        PHAsset *asset = self.fetchResults[indexPath.row-1];
        cell.assetIdentifier = asset.localIdentifier;
        CGFloat width = ceil(self.view.width/3)*kScreenScale;
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:CGSizeMake(width, width)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:self.options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if([cell.assetIdentifier isEqualToString:asset.localIdentifier]){
                cell.imgView.image = result;
            }
        }];
        
        if([self.tempArray indexOfObject:asset] != NSNotFound){
            cell.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.indexPathsForSelectedItems.count == _maxCount.integerValue){
        [WBLoadingView showErrorStatus:[NSString stringWithFormat:@"你最多只能选择%lu张图片",(unsigned long)_maxCount.integerValue]];
        return NO;
    }
    
    if(indexPath.row == 0){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.3f];
        }
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        
    }
    else{
//        self.navBar.rightBarButton.enabled = YES;
        PHAsset *asset = self.fetchResults[indexPath.row-1];
        [_tempArray addObject:asset];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if(collectionView.indexPathsForSelectedItems.count == 0){
//        self.navBar.rightBarButton.enabled = NO;
//    }
    
    PHAsset *asset = self.fetchResults[indexPath.row-1];
    [_tempArray removeObject:asset];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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
            [_selectPhotos removeAllObjects];
            [_selectPhotos addObjectsFromArray:_tempArray];
            [_selectPhotos addObject:asset];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}

#pragma mark - Getter and Setter
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        CGFloat width = ceil(self.view.width/3);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(width, width);
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = RGB(246, 244, 244);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.multipleTouchEnabled = YES;
        _collectionView.exclusiveTouch = YES;
        
        [_collectionView registerClass:[WBPhotoSelectCollectionCell class] forCellWithReuseIdentifier:WBPhotoSelectCellIdentifier];
    }
    return _collectionView;
}

- (PHFetchOptions *)fetchOption
{
    if(!_fetchOption){
        _fetchOption = [PHFetchOptions new];
        _fetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    }
    return _fetchOption;
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

- (UIButton *)nextBtn
{
    if(!_nextBtn){
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        [_nextBtn setImage:[UIImage imageNamed:@"照片打勾"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (WBSeparateButton *)backBtn
{
    if(!_backBtn){
        _backBtn = [[WBSeparateButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _backBtn.imageRect = CGRectMake(-8, 11, 22, 22);
        [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
@end
