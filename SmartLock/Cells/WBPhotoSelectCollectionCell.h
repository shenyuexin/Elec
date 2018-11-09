//
//  WBPhotoSelectCell.h
//  Weimai
//
//  Created by Richard Shen on 16/4/9.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString * const WBPhotoSelectCellIdentifier;

@interface WBPhotoSelectCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, assign) NSUInteger selectIndex;

@property (nonatomic, strong) NSString *assetIdentifier;
@end
