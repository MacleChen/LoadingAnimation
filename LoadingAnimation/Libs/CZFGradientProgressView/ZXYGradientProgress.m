//
//  ZXYGradientProgress.m
//  ProgressView
//
//  Created by Mars on 2017/12/12.
//  Copyright © 2017年 赵向禹. All rights reserved.
//

#import "ZXYGradientProgress.h"

#define ColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//宽度
static const CGFloat layerWidth = 6;

@interface ZXYGradientProgress ()
{
    /** 原点 */
    CGPoint _origin;
    /** 半径 */
    CGFloat _radius;
    /** 起始 */
    CGFloat _startAngle;
    /** 结束 */
    CGFloat _endAngle;
}

/** 进度显示 */
@property (nonatomic, strong) UILabel *progressLabel;
/** 底层显示层 */
@property (nonatomic, strong) CAShapeLayer *topLayer;
/** 顶层显示层 */
@property (nonatomic, strong) CAShapeLayer *bottomLayer;

@end

@implementation ZXYGradientProgress

- (instancetype)initWithFrame:(CGRect)frame progress:(CGFloat)progress {
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
        self.progress = progress;
    }
    return self;
}

#pragma mark - 初始化页面
- (void)setUI {
    
    [self.layer addSublayer:self.bottomLayer];
    [self.layer addSublayer:self.topLayer];
    [self addSubview:self.progressLabel];
    
    _origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _radius = self.bounds.size.width / 2;
    
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:_radius startAngle:-M_PI_2 endAngle:M_PI * 2 clockwise:YES];
    
    _bottomLayer.path = progressPath.CGPath;
    _topLayer.path = progressPath.CGPath;
    
    [self gradient];
}

/** 设置渐变层 */
- (void)gradient {
    CALayer *gradientLayer = [CALayer layer];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(-layerWidth * 2, -layerWidth * 2, self.bounds.size.width + layerWidth*2 + 10, self.bounds.size.height + layerWidth*2 + 10);
    gradient.colors = @[(id)[UIColor colorWithRed:37.0 / 255.0 green:195.0 / 255 blue:255.0 / 255 alpha:1.0].CGColor,
                             (id)[UIColor colorWithRed:9.0 / 255.0 green:85.0 / 255 blue:255.0 / 255 alpha:1.0].CGColor];
    [gradient setLocations:@[@0.1, @0.9]];
    gradient.startPoint = CGPointMake(1.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 0.0);
    [gradientLayer addSublayer:gradient];
    
    [gradientLayer setMask:_topLayer];
    [self.layer addSublayer:gradientLayer];
}

#pragma mark - 懒加载
- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _progressLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        _progressLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:35.0];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [UIColor blackColor];
    }
    return _progressLabel;
}

- (CAShapeLayer *)topLayer {
    if (!_topLayer) {
        _topLayer = [CAShapeLayer layer];
        _topLayer.lineWidth = layerWidth * 2;
        _topLayer.lineCap = kCALineCapRound;
        _topLayer.fillColor = [UIColor clearColor].CGColor;
        _topLayer.strokeColor = [UIColor whiteColor].CGColor;
        
        // 阴影
        _topLayer.shadowColor = [UIColor colorWithRed:2.0 / 255.0 green:75.0 / 255 blue:191.0 / 255.0 alpha:1.0].CGColor;
        _topLayer.shadowOffset = CGSizeMake(0.5, 0.5);
        _topLayer.shadowOpacity = 0.6;
    }
    return _topLayer;
}

- (CAShapeLayer *)bottomLayer {
    if (!_bottomLayer) {
        _bottomLayer = [CAShapeLayer layer];
        _bottomLayer.lineCap = kCALineCapRound;
        _bottomLayer.lineWidth = layerWidth;
        _bottomLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _bottomLayer;
}

#pragma mark - setMethod
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    // set word size
    NSString *str = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = NSMakeRange(str.length - 1, 1);
    [mutStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
    [_progressLabel setAttributedText:mutStr];
//    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    
    _startAngle = - M_PI_2;
    _endAngle = _startAngle + _progress * M_PI * 2;
    
    UIBezierPath *topPath = [UIBezierPath bezierPathWithArcCenter:_origin radius:_radius startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    _topLayer.path = topPath.CGPath;
}

- (void)setBottomColor:(UIColor *)bottomColor {
    _bottomColor = bottomColor;
    _bottomLayer.strokeColor = _bottomColor.CGColor;
}
@end
