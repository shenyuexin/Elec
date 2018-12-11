//
//  WBSegView.h
//  Weimai
//
//  Created by Richard Shen on 16/4/10.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBSegView;

@protocol WBSegViewDelegate <NSObject>

- (void)segView:(WBSegView *)segView selectIndex:(NSInteger)index;
@end

@interface WBSegView : UIView
{
    UIView *_selectView;
}

@property (nonatomic, weak) id<WBSegViewDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *itmes;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, assign) BOOL isFavMode;
@property (nonatomic, assign, readonly) NSUInteger selectedIndex;

- (void)setSelectIndex:(NSInteger)index;

@end
