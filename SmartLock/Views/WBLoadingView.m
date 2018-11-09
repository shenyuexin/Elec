    //
//  WBLoadingView.m
//  NewMai
//
//  Created by Richard Shen on 15/11/6.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "WBLoadingView.h"

@interface NMAnimateLoadingView : UIView

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger animateIndex;
@end

@implementation NMAnimateLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        for(int i=0;i<3;i++)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(28 +i*(10+9), 0, 10, 10)];
            view.backgroundColor = RGB(0xb6, 0xbf, 0xd5);
            view.layer.cornerRadius = 5;
            view.layer.masksToBounds = YES;
            view.tag = i+1;
            [self addSubview:view];
        }
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)startAnimate
{
    self.animateIndex = 0;
    [self doAnimate];
    
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(doAnimate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)doAnimate
{
    self.animateIndex ++;
    if(self.animateIndex >3){
        self.animateIndex = 1;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        for(UIView *view in self.subviews){
            if(view.tag != self.animateIndex)
            {
                [view setBackgroundColor:RGB(0xb6, 0xbf, 0xd5)];
            }
            else{
                [view setBackgroundColor:[UIColor whiteColor]];
            }
        }
    }];
}

- (void)stopAnimate
{
    [self.timer invalidate];
    self.timer = nil;
}

@end

@interface WBLoadingView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *stringLabel;

@property (nonatomic, assign) CGFloat visableHeight;
@property (nonatomic, strong, readonly) NSTimer *fadeOutTimer;

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *hudView;

@property (nonatomic, strong) NMAnimateLoadingView *animateView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign) WBLoadBgMode mode;

@property (nonatomic, assign) BOOL isAnimateLoading;
@end

@implementation WBLoadingView

+ (instancetype)shareView
{
    static WBLoadingView *loadView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadView = [[WBLoadingView alloc] init];
    });
    return loadView;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.visableHeight = SCREEN_HEIGHT;
        [self registerNotifications];
    }
    return self;
}

- (void)setFadeOutTimer:(NSTimer *)newTimer {
    if(_fadeOutTimer){
        [_fadeOutTimer invalidate], _fadeOutTimer = nil;
    }
    if(newTimer){
        _fadeOutTimer = newTimer;
    }
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)showImage:(UIImage *)image status:(NSString *)status autoDismiss:(BOOL)dismiss
{
    if(self.isAnimateLoading){
        [_animateView stopAnimate];
        [_animateView removeFromSuperview];
        _animateView = nil;
        
        [_indicatorView stopAnimating];
        [_indicatorView removeFromSuperview],_indicatorView= nil;

        
        [_imageView removeFromSuperview];
        _imageView = nil;
        
        [_hudView removeFromSuperview];
        _hudView = nil;
        
        [_stringLabel removeFromSuperview];
        _stringLabel = nil;
    }
    self.isAnimateLoading = NO;
    
    CGFloat originY = 10;
    CGFloat hudHeightDiff = 32;
    if(image){
        originY = 57;
        hudHeightDiff = 0;
    }
    
    CGFloat fontHeight = ([UIScreen mainScreen].scale >2)?16:14;
    UIFont *font = [UIFont systemFontOfSize:fontHeight];
//    CGFloat labelWidth = [status sizeWithFont:font byHeight:fontHeight].width;
//    if(labelWidth <= 120){
//        if(status.length <= 5){
//            [self.hudView setFrame:CGRectMake(0, 0, 115, 68-hudHeightDiff)];
//            [self.stringLabel setFrame:CGRectMake(18, originY, self.hudView.width-36, fontHeight+2)];
//        }
//        else{
//            [self.hudView setFrame:CGRectMake(0, 0, (labelWidth+36), 68-hudHeightDiff)];
//            [self.stringLabel setFrame:CGRectMake(18, originY, self.hudView.width-36, fontHeight+2)];
//        }
//    }
//    else{
        CGFloat labelHeight = [status sizeWithFont:font byWidth:144].height;
        CGFloat height = MIN(labelHeight, 54);
        [self.hudView setFrame:CGRectMake(0, 0, 164, ((originY>10?57:38)+height+18)-hudHeightDiff)];
        [self.stringLabel setFrame:CGRectMake(10, originY, self.hudView.width-20, height)];
//    }
    self.hudView.layer.cornerRadius = 4;
    self.hudView.center = CGPointMake(self.overlayView.center.x, self.visableHeight/2);
    
    self.stringLabel.font = font;
    self.stringLabel.text = status;
    
    self.imageView.frame = CGRectMake((CGRectGetWidth(self.hudView.frame)-34)/2, 18, 34, 34);
    self.imageView.image = image;
    
    [self show];
    
    if(dismiss){
        NSTimeInterval duration = [self displayDurationForString:status];
        self.fadeOutTimer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.fadeOutTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)showLoading:(NSString *)status
{
    if(!self.isAnimateLoading){
        [_imageView removeFromSuperview];
        _imageView = nil;
        
        [_hudView removeFromSuperview];
        _hudView = nil;
        
        [_stringLabel removeFromSuperview];
        _stringLabel = nil;
        
//        [_animateView removeFromSuperview];
//        _animateView = nil;
    }
    self.isAnimateLoading = YES;
    self.hudView.layer.cornerRadius = 6;
    [self.hudView setFrame:CGRectMake(0, 0, 120, 100)];
    [self.hudView setCenter:CGPointMake(self.overlayView.center.x, self.visableHeight/2)];
    
    [self.hudView addSubview:self.indicatorView];
    self.indicatorView.frame = CGRectMake((_hudView.width-37)/2, 18, 37, 37);
    [self.indicatorView startAnimating];
    
    [self.stringLabel setText:status?:@"加载中"];
    [self.stringLabel setFrame:CGRectMake(10, _hudView.height-36, 100, 16)];
    [self.stringLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.animateView startAnimate];
    
    [self show];
    
}

- (void)show
{
    if(!self.overlayView.superview)
    {
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
        }
    } else {
        // Ensure that overlay will be exactly on top of rootViewController (which may be changed during runtime).
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if(!self.superview){
        [self.overlayView addSubview:self];
    }
    
    self.fadeOutTimer = nil;
    
    self.overlayView.hidden = NO;
    self.overlayView.backgroundColor = [UIColor clearColor];
    
    // Appear
    if(self.alpha != 1 || self.hudView.alpha != 1) {
        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3f, 1/1.3f);
                            
                             self.alpha = 1;
                         }
                         completion:nil];
        
        [self setNeedsDisplay];
    }
}

- (void)dismiss
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:(UIViewAnimationOptions) (UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8f, 0.8f);
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         if(self.alpha == 0.0f) {
                             self.alpha = 0.0f;
                             
                             [_hudView removeFromSuperview];
                             _hudView = nil;
                             
                             [_overlayView removeFromSuperview];
                             _overlayView = nil;
                             
                             [_fadeOutTimer invalidate];
                             _fadeOutTimer = nil;
                             
                             [_animateView stopAnimate];
                             [_animateView removeFromSuperview];
                             _animateView = nil;
                             
                             [_indicatorView stopAnimating];
                             [_indicatorView removeFromSuperview],_indicatorView= nil;
                             
                             // Tell the rootViewController to update the StatusBar appearance
                             UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
                             if ([rootController respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                                 [rootController setNeedsStatusBarAppearanceUpdate];
                             }
                         }
                     }];

}

#pragma mark - UI
- (UIControl *)overlayView {
    if(!_overlayView) {
        CGRect windowBounds = [UIApplication sharedApplication].keyWindow.bounds;
        _overlayView = [[UIControl alloc] initWithFrame:windowBounds];
        _overlayView = [[UIControl alloc] initWithFrame:windowBounds];
        _overlayView.backgroundColor = [UIColor clearColor];
        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}

- (UIView *)hudView {
    if(!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.layer.masksToBounds = YES;
        _hudView.backgroundColor = RGBA(0x26, 0x27, 0x29, 0.8);
    }
    
    if(!_hudView.superview){
        [self addSubview:_hudView];
    }
    return _hudView;
}

- (UILabel *)stringLabel {
    if (!_stringLabel) {
        _stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stringLabel.backgroundColor = [UIColor clearColor];
        _stringLabel.adjustsFontSizeToFitWidth = YES;
        _stringLabel.textColor = [UIColor whiteColor];
        _stringLabel.textAlignment = NSTextAlignmentCenter;
        _stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _stringLabel.numberOfLines = 2;
    }
    
    if(!_stringLabel.superview){
        [self.hudView addSubview:_stringLabel];
    }
    return _stringLabel;
}

- (UIImageView *)imageView {
    if (!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    [self.hudView addSubview:_imageView];
    return _imageView;
}

- (NMAnimateLoadingView *)animateView
{
    if(!_animateView){
        _animateView = [[NMAnimateLoadingView alloc] initWithFrame:CGRectMake(0, 18, 105, 10)];
    }
    if(!_animateView.superview){
        [self.hudView addSubview:_animateView];
    }
    return _animateView;
}

- (UIActivityIndicatorView *)indicatorView
{
    if(!_indicatorView){
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _indicatorView;
}

#pragma mark - Event handling

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    return MIN((float)string.length*0.06 + 1, 5.0);
}

- (void)overlayViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event {
    
}


- (void)positionHUD:(NSNotification*)notification
{
    CGFloat keyboardHeight = 0;
    double animationDuration = 0.0;
    // Get keyboardHeight in regards to current state
    if(notification)
    {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        keyboardHeight = CGRectGetHeight(keyboardFrame);
        self.visableHeight = SCREEN_HEIGHT - keyboardHeight;
        
        if(notification.name == UIKeyboardDidHideNotification){
            self.visableHeight = SCREEN_HEIGHT;
        }
        
        if(self.alpha == 1 && (notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardWillHideNotification))
        {
            [UIView animateWithDuration:animationDuration
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.hudView.center = CGPointMake(self.overlayView.center.x, self.visableHeight/2);
                             } completion:NULL];
        }
    }
}
#pragma mark - Method

+ (void)showSuccessStatus:(NSString *)status
{
    WBLoadingView *shareView = [WBLoadingView shareView];
    [shareView showImage:[UIImage imageNamed:@"成功"] status:status autoDismiss:YES];
}

+ (void)showErrorStatus:(NSString *)status
{
    WBLoadingView *shareView = [WBLoadingView shareView];
    [shareView showImage:[UIImage imageNamed:@"失败"] status:status autoDismiss:YES];
}

+ (void)showStatus:(NSString *)status image:(UIImage *)image autoDismiss:(BOOL)dismiss
{
    WBLoadingView *shareView = [WBLoadingView shareView];
    [shareView showImage:image status:status autoDismiss:dismiss];
}

+ (void)showLoading
{
    [[WBLoadingView shareView] showLoading:nil];
}

+ (void)showLoadingWithString:(NSString *)status
{
    [[WBLoadingView shareView] showLoading:status];
}

+ (void)dismiss
{
    [[WBLoadingView shareView] dismiss];
}
@end
