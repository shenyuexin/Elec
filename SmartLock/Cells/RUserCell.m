//
//  RMessageCell.m
//  SmartLock
//
//  Created by Richard Shen on 2018/1/19.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import "RUserCell.h"

NSString * const RUserCellIdentifier = @"RUserCellIdentifier";

@interface RUserCell()
@property (nonatomic, strong) UILabel *consNoLabel;
@property (nonatomic, strong) UILabel *consNameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *mrSectNameLabel;
@property (nonatomic, strong) UILabel *addrLabel;
@property (nonatomic, strong) UILabel *pq4Label;
@property (nonatomic, strong) UIView  *operatorView;
@property (nonatomic, strong) UILabel *opeartorNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIView  *lineView;
@end

@implementation RUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self addSubview:self.consNoLabel];
        [self addSubview:self.consNameLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.mrSectNameLabel];
        [self addSubview:self.addrLabel];
        [self addSubview:self.pq4Label];
        [self addSubview:self.operatorView];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lineView.width = self.width - 30;
    self.statusLabel.left = self.width - 130;
    self.pq4Label.left = self.width - 150;
    self.addrLabel.width = self.width - 30;
    
    self.operatorView.frame = CGRectMake(0, self.height-33, self.width, 33);
    self.opeartorNameLabel.width = self.width - 130;
    self.dateLabel.left = self.width - 130;
}

- (void)setUser:(RUserInfo *)user
{
    _user = user;
    
    self.consNoLabel.text = _user.consNo;
    self.consNameLabel.text = _user.consName;
    self.mrSectNameLabel.text = [NSString stringWithFormat:@"%@:",_user.mrSectName];
    CGFloat mrHeight = [self.mrSectNameLabel.text sizeWithFont:self.mrSectNameLabel.font byWidth:SCREEN_WIDTH- 150].height;
    self.mrSectNameLabel.frame = CGRectMake(15, 70, SCREEN_WIDTH-150, MAX(mrHeight, 16));

    NSMutableAttributedString *addrString = [[NSMutableAttributedString alloc] initWithString:_user.elecAddr];
    NSTextAttachment *attachment = [NSTextAttachment new];
    attachment.image = [UIImage imageNamed:@"icon_location"];
    attachment.bounds = CGRectMake(0, -1.5, 10, 12);
    [addrString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    self.addrLabel.attributedText = addrString;
    CGFloat addrHeight = [[NSString stringWithFormat:@"%@  ",user.elecAddr] sizeWithFont:self.addrLabel.font byWidth:SCREEN_WIDTH- 30].height;
    self.addrLabel.frame = CGRectMake(15, self.mrSectNameLabel.bottom+3, SCREEN_WIDTH-30, MAX(addrHeight, 16));
    
    NSMutableAttributedString *pq4String = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前电量: %@", _user.pq4]];
    [pq4String addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0x333333),
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14]}
                       range:NSMakeRange(6, pq4String.length-6)];
    self.pq4Label.attributedText = pq4String;
    
    switch (_user.status) {
        case RCheckStatusUnknow:{
            self.backgroundColor = HEX_RGB(0xffffff);
            self.operatorView.backgroundColor = HEX_RGB(0xf9f9f9);
            self.statusLabel.textColor = HEX_RGB(0xffac2c);
            self.statusLabel.text = @"未排查";
            break;
        }
        case RCheckStatusSuccess:{
            self.backgroundColor = HEX_RGB(0xe3effd);
            self.operatorView.backgroundColor = HEX_RGB(0xd2e6fc);
            self.statusLabel.textColor = HEX_RGB(0x3dba9c);
            self.statusLabel.text = @"无异常";
            break;
        }
        case RCheckStatusSuspicion:{
            self.backgroundColor = HEX_RGB(0xffeeee);
            self.operatorView.backgroundColor = HEX_RGB(0xffe4e4);
            self.statusLabel.textColor = HEX_RGB(0xf64436);
            self.statusLabel.text = @"疑似用户";
            break;
        }
        default:
            break;
    }
    
    self.opeartorNameLabel.text = [NSString stringWithFormat:@"%@ %@",_user.opeartorNo, _user.opeartorName];
    self.dateLabel.text = _user.createDate;
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
        _consNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _consNoLabel.bottom, self.width-50, 18)];
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
        _mrSectNameLabel.numberOfLines = 0;
    }
    return _mrSectNameLabel;
}

- (UILabel *)addrLabel
{
    if(!_addrLabel){
        _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _mrSectNameLabel.bottom+3, self.width-30, 16)];
        _addrLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _addrLabel.textColor = HEX_RGB(0x777777);
        _addrLabel.numberOfLines = 0;
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

- (UIView *)operatorView
{
    if(!_operatorView){
        _operatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-33, self.width, 33)];
        
        [_operatorView addSubview:self.opeartorNameLabel];
        [_operatorView addSubview:self.dateLabel];
    }
    return _operatorView;
}

- (UILabel *)opeartorNameLabel
{
    if(!_opeartorNameLabel){
        _opeartorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, self.width-130, 16)];
        _opeartorNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _opeartorNameLabel.textColor = HEX_RGB(0x999999);
        _opeartorNameLabel.numberOfLines = 1;
    }
    return _opeartorNameLabel;
}

- (UILabel *)dateLabel
{
    if(!_dateLabel){
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-130, 8, 115, 16)];
        _dateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _dateLabel.textColor = HEX_RGB(0x999999);
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

- (UIView *)lineView
{
    if(!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 58, self.width-30, 0.5)];
        _lineView.backgroundColor = HEX_RGB(0xdddddd);
    }
    return _lineView;
}
@end

