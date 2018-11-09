//
//  WBPhotoSelectCell.m
//  Weimai
//
//  Created by Richard Shen on 16/4/9.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBPhotoSelectCollectionCell.h"
#import "UIView+ScaleAnimation.h"

NSString * const WBPhotoSelectCellIdentifier = @"WBPhotoSelectCellIdentifier";

@interface WBPhotoSelectCollectionCell ()

@property (nonatomic, strong) UILabel *selectIndexLabel;
@property (nonatomic, strong) UIView *selectedView;
@end

@implementation WBPhotoSelectCollectionCell

- (void)setSelectIndex:(NSUInteger)selectIndex
{
    _selectIndex = selectIndex;
    self.selectIndexLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_selectIndex];
    [self setSelected:_selectIndex > 0];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    if(selected && _selectIndex > 0){
//        [self.imgView doScaleAnimateWithScale:0.02];
//        self.imgView.layer.borderColor = RGB(255, 79, 35).CGColor;
//        self.imgView.layer.borderWidth = 3;
//        
//        self.selectIndexLabel.hidden = NO;
//    }else{
//        self.imgView.layer.borderColor = RGB(255, 79, 35).CGColor;
//        self.imgView.layer.borderWidth = 0;
//        
//        self.selectIndexLabel.hidden = YES;
//    }
    
    if(selected){
        [self addSubview:self.selectedView];
        [self.selectedView bringSubviewToFront:self.selectedView];
    }
    else{
        [_selectedView removeFromSuperview];
    }
}

#pragma mark - Getter and Setter
- (UIImageView *)imgView
{
    if(!_imgView){
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UIView *)selectedView
{
    if(!_selectedView){
        _selectedView = [[UIView alloc] initWithFrame:self.bounds];
        _selectedView.backgroundColor = HEX_RGBA(0x333333,0.57);
        
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 47, 47)];
        iconImgView.image = [UIImage imageNamed:@"照片选择"];
        [_selectedView addSubview:iconImgView];
        iconImgView.center = _selectedView.center;
    }
    return _selectedView;
}

- (UILabel *)selectIndexLabel
{
    if(!_selectIndexLabel){
        _selectIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-22, 0, 22, 22)];
        _selectIndexLabel.backgroundColor = RGB(255, 79, 35);
        _selectIndexLabel.textColor = [UIColor whiteColor];
        _selectIndexLabel.font = [UIFont systemFontOfSize:14.0f];
        _selectIndexLabel.textAlignment = NSTextAlignmentCenter;
        _selectIndexLabel.layer.cornerRadius = 4.0f;
        _selectIndexLabel.layer.masksToBounds = YES;
        _selectIndexLabel.hidden = YES;
        [self.imgView addSubview:_selectIndexLabel];
    }
    return _selectIndexLabel;
}
@end
