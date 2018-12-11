//
//  RPaopaoView.m
//  SmartLock
//
//  Created by Richard Shen on 2018/11/2.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import "RPaopaoView.h"
#import "WBMediator.h"


@interface RPaopaoView  ()

@property (nonatomic, strong) UILabel *consNoLabel;
@property (nonatomic, strong) UILabel *consNameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *mrSectNameLabel;
@property (nonatomic, strong) UILabel *addrLabel;
@property (nonatomic, strong) UILabel *pq4Label;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UIButton  *button;
@end


static NSInteger kArrorHeight = 10;
@implementation RPaopaoView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.consNoLabel];
        [self addSubview:self.consNameLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.mrSectNameLabel];
        [self addSubview:self.addrLabel];
        [self addSubview:self.pq4Label];
        [self addSubview:self.lineView];
        [self addSubview:self.button];
    }
    return self;
}

- (void)setUser:(RUserInfo *)user
{
    _user = user;
    
    self.consNoLabel.text = _user.consNo;
    self.consNameLabel.text = _user.consName;
    self.mrSectNameLabel.text = [NSString stringWithFormat:@"%@:",_user.mrSectName];
    self.addrLabel.text = [NSString stringWithFormat:@"%@",_user.elecAddr];
    
    NSMutableAttributedString *pq4String = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前电量: %@", _user.pq4]];
    [pq4String addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0x333333),
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14]}
                       range:NSMakeRange(6, pq4String.length-6)];
    self.pq4Label.attributedText = pq4String;
    
    switch (_user.status) {
        case RCheckStatusUnknow:{
            self.statusLabel.textColor = HEX_RGB(0xffac2c);
            self.statusLabel.text = @"未排查";
            break;
        }
        case RCheckStatusSuccess:{
            self.statusLabel.textColor = HEX_RGB(0x3dba9c);
            self.statusLabel.text = @"无异常";
            break;
        }
        case RCheckStatusSuspicion:{
            self.statusLabel.textColor = HEX_RGB(0xf64436);
            self.statusLabel.text = @"疑似用户";
            break;
        }
        default:
            break;
    }
    [self setNeedsDisplay];
}

#pragma mark - Event
- (void)btnclick
{
    [[WBMediator sharedManager] gotoDetailViewController:self.user];

}

#pragma mark - draw rect
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
    CGColorRef colorRef = nil;
    switch (_user.status) {
        case RCheckStatusUnknow:{
            colorRef = HEX_RGB(0xffffff).CGColor;
            break;
        }
        case RCheckStatusSuccess:{
            colorRef = HEX_RGB(0xe3effd).CGColor;
            break;
        }
        case RCheckStatusSuspicion:{
            colorRef = HEX_RGB(0xffeeee).CGColor;
            break;
        }
        default:
            break;
    }
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, colorRef);

    [self getDrawPath:context];
    CGContextFillPath(context);
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;

    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);

    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

#pragma mark - Getter
- (UILabel *)consNoLabel
{
    if(!_consNoLabel){
        _consNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, self.width-130, 21)];
        _consNoLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _consNoLabel.textColor = HEX_RGB(0x333333);
        _consNoLabel.numberOfLines = 1;
    }
    return _consNoLabel;
}

- (UILabel *)consNameLabel
{
    if(!_consNameLabel){
        _consNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _consNoLabel.bottom, self.width-130, 18)];
        _consNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _consNameLabel.textColor = HEX_RGB(0x666666);
        _consNameLabel.numberOfLines = 1;
    }
    return _consNameLabel;
}

- (UILabel *)statusLabel
{
    if(!_statusLabel){
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-130, 11, 115, 21)];
        _statusLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _statusLabel.textColor = HEX_RGB(0xffac2c);
        _statusLabel.numberOfLines = 1;
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UILabel *)mrSectNameLabel
{
    if(!_mrSectNameLabel){
        _mrSectNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, self.width-150, 16)];
        _mrSectNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _mrSectNameLabel.textColor = HEX_RGB(0x777777);
        _mrSectNameLabel.numberOfLines = 1;
    }
    return _mrSectNameLabel;
}

- (UILabel *)addrLabel
{
    if(!_addrLabel){
        _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _mrSectNameLabel.bottom+3, self.width-40, 16)];
        _addrLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _addrLabel.textColor = HEX_RGB(0x777777);
        _addrLabel.numberOfLines = 1;
        _addrLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _addrLabel;
}

- (UILabel *)pq4Label
{
    if(!_pq4Label){
        _pq4Label = [[UILabel alloc] initWithFrame:CGRectMake(self.width-150, 70, 135, 16)];
        _pq4Label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _pq4Label.textColor = HEX_RGB(0x777777);
        _pq4Label.numberOfLines = 1;
        _pq4Label.textAlignment = NSTextAlignmentRight;
    }
    return _pq4Label;
}

- (UIView *)lineView
{
    if(!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 58, self.width-30, 0.5)];
        _lineView.backgroundColor = HEX_RGB(0xdddddd);
    }
    return _lineView;
}

- (UIButton *)button
{
    if(!_button){
        _button = [[UIButton alloc] initWithFrame:self.bounds];
        _button.backgroundColor = [UIColor clearColor];
        [_button addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchDown];
    }
    return _button;
}
@end
