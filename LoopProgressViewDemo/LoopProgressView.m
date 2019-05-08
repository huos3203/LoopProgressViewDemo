//
//  LoopProgressView.m
//  头像蒙板
//
//  Created by CUG on 16/1/29.
//  Copyright © 2016年 CUG. All rights reserved.
//

#import "LoopProgressView.h"
#import <QuartzCore/QuartzCore.h>

#define ViewWidth self.frame.size.width   //环形进度条的视图宽度
#define ProgressWidth 1.5                 //环形进度条的圆环宽度
#define Radius ViewWidth/2-ProgressWidth  //环形进度条的半径
#define RGBA(r, g, b, a)   [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a)]
#define RGB(r, g, b)        RGBA(r, g, b, 1.0)

@interface LoopProgressView()
{
    UILabel *label;
    NSTimer *progressTimer;
}
@property (nonatomic,assign)CGFloat i;
@property (strong, nonatomic) CAShapeLayer *arcLayer;
@end

@implementation LoopProgressView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    _i=0;
    CGContextRef progressContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(progressContext, ProgressWidth);
    CGContextSetRGBStrokeColor(progressContext, 220.0/255.0, 220.0/255.0, 220.0/255.0, 1);
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    //绘制环形进度条底框
    CGContextAddArc(progressContext, xCenter, yCenter, Radius, 0, 2*M_PI, 0);
    CGContextDrawPath(progressContext, kCGPathStroke);
    // 进度数字字号,可自己根据自己需要，从视图大小去适配字体字号
    int fontNum = ViewWidth/4;
    int weight = ViewWidth - ProgressWidth*2;
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, weight, ViewWidth/4)];
    label.center = CGPointMake(xCenter, yCenter);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:fontNum];
    label.textColor = RGB(47, 56, 86);
    label.text = @"0%";
    [self addSubview:label];
    ///绘制环形进度环
    [self.layer addSublayer:self.arcLayer];
}

///绘制环形进度环
- (CAShapeLayer *)arcLayer
{
    if (!_arcLayer) {
        
        _arcLayer=[CAShapeLayer layer];
        _arcLayer.fillColor = [UIColor clearColor].CGColor;
        _arcLayer.strokeColor= [UIColor colorWithRed:44.0/255.0 green:215.0/255.0 blue:115.0/255.0 alpha:1].CGColor;
        _arcLayer.lineWidth=ProgressWidth;
        _arcLayer.lineCap = @"round";
        _arcLayer.backgroundColor = [UIColor blueColor].CGColor;
    }
    return _arcLayer;
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self drawLineAnimation:self.arcLayer];
    }];
    if (_progress > 1) {
        NSLog(@"传入数值范围为 0-1");
        _progress = 1;
    }else if (_progress < 0){
        NSLog(@"传入数值范围为 0-1");
        _progress = 0;
        return;
    }
    
    if (_progress >= 0) {
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(newThread) object:nil];
        [thread start];
    }
}

-(void)newThread
{
    @autoreleasepool {
        progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeLabel) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

//NSTimer不会精准调用  虚拟机和真机效果不一样
-(void)timeLabel
{
    _i += 0.01;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self->label.text = [NSString stringWithFormat:@"%.0f%%",self->_i*100.0];
        
        if (self->_i >= self.progress) {
            self->label.text = [NSString stringWithFormat:@"%.0f%%",self.progress*100];
            if (self.progress == 0) self->label.text = @"0%";
            [self->progressTimer invalidate];
            self->progressTimer = nil;
            
        }
    }];
}

//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
    CGFloat xCenter = 38 * 0.5;
    CGFloat yCenter = 38 * 0.5;
    CGFloat start = 0;//为改变初始位置
    CGFloat to = _progress * M_PI *2; // 结束位置
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(xCenter,yCenter) radius:Radius startAngle:start endAngle:to clockwise:YES];
    self.arcLayer.path=path.CGPath;//46,169,230
    
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=_progress;//动画时间
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

@end
