//
//  SSStockChart.m
//  SSKLine
//
//  Created by shangshuai on 2019/4/25.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "SSStockChart.h"
#import "SSStockConst.h"
#import "EModel.h"
#import "Constants.h"

@interface SSStockChart ()

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) CAShapeLayer *mainLayer;

@end

@implementation SSStockChart
@synthesize dataEntries = _dataEntries;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView {
//    [self setupGird];
    [self.contentScrollView.layer addSublayer:self.mainLayer];
    [self addSubview:self.contentScrollView];
}

/** 画背景线 */
- (void)setupGird {
    self.layer.backgroundColor = [UIColor colorWithRed:38/255.0 green:49/255.0 blue:69/255.0 alpha:1].CGColor;
    //初始化一个线的图层
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    //初始化一个描述的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    /** 横线 */
    //moveToPoint 设置线段开始的点、 addLineToPoint 设置线段结束的点。
    for (int i = 0; i < 5; i ++) {
        [linePath moveToPoint:CGPointMake(4, ((CGRectGetHeight(self.bounds) - 8) / 4) * i + 4)];
        [linePath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - 4, ((CGRectGetHeight(self.bounds) - 8) / 4) * i + 4)];
    }
    /** 竖线 */
    //moveToPoint 设置线段开始的点、 addLineToPoint 设置线段结束的点。
    for (int i = 0; i < 6; i ++) {
        [linePath moveToPoint:CGPointMake((CGRectGetWidth(self.bounds) - 8) / 5 * i + 4, 4)];
        [linePath addLineToPoint:CGPointMake((CGRectGetWidth(self.bounds) - 8) / 5 * i + 4, CGRectGetHeight(self.bounds) - 4)];
    }
    //路径赋给图层
    lineLayer.path = linePath.CGPath;
    //设置图层的属性
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = ThemeBackgroundLineColor.CGColor;
    [self.layer addSublayer:lineLayer];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setwangge {
    NSArray * horizontalLineInfos = @[@{@"value": @0.0, @"dashed": [NSNumber numberWithBool:false]}, @{@"value": @0.5, @"dashed": [NSNumber numberWithBool:true]}, @{@"value": @1.0, @"dashed": [NSNumber numberWithBool:false]}];
    for (NSDictionary * dic in horizontalLineInfos) {
        CGFloat xPos = 0.0;
        CGFloat yPos = [self translateHeightValueToYPosition:[dic[@"value"] floatValue]];
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(xPos, yPos)];
        [linePath addLineToPoint:CGPointMake(self.contentScrollView.frame.size.width, yPos)];
        lineLayer.lineWidth = 1;
        lineLayer.path = linePath.CGPath;
        if ([dic[@"dashed"] boolValue]) {
            lineLayer.lineDashPattern = @[@4,@4];
        }
        lineLayer.strokeColor = [UIColor redColor].CGColor;
        [self.layer insertSublayer:lineLayer atIndex:0];
    }
}

- (void)setDataEntries:(NSMutableArray <EModel *>*)dataEntries {
    _dataEntries = dataEntries;
    if (dataEntries.count > 0) {
        self.contentScrollView.contentSize = CGSizeMake((barWidth + barSpacing)* dataEntries.count,self.frame.size.height);
        self.mainLayer.frame = CGRectMake(0,0,  self.contentScrollView.contentSize.width,  self.contentScrollView.contentSize.height);
        [self setwangge];
        [dataEntries enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self showEntry:idx entry:obj];
        }];
    }
}

- (void)showEntry:(NSInteger)index  entry:(EModel *)object {
    /// Starting x postion of the bar
    CGFloat xPos  = barSpacing + index * (barWidth + barSpacing);
    
    /// Starting y postion of the bar
    CGFloat yPos = [self translateHeightValueToYPosition:object.height];
    
    [self drawBar:xPos yPos:yPos color:1];
    
    /// Draw text above the bar
    [self drawBar:xPos - barSpacing/2 yPos:yPos - 30 textValue:object.textValue];
    
    /// Draw text below the bar
    [self drawTitle:xPos - barSpacing/2 yPos:self.mainLayer.frame.size.height - BottomMargin + 10 title:object.title];
}

- (void)drawBar:(CGFloat)xPos yPos:(CGFloat)yPos color:(CGFloat)color{
    CAShapeLayer *barLayer = [CAShapeLayer layer];
    barLayer.frame = CGRectMake(xPos, yPos, barWidth, self.mainLayer.frame.size.height - BottomMargin - yPos);
    barLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.mainLayer addSublayer:barLayer];
}

- (void)drawBar:(CGFloat)xPos yPos:(CGFloat)yPos  textValue:(NSString *)textValue {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(xPos, yPos, barWidth + barSpacing, 22);
    textLayer.foregroundColor = [UIColor redColor].CGColor;
//    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.fontSize = 14.0;
    textLayer.string = textValue;
    [self.mainLayer addSublayer:textLayer];
}

- (void)drawTitle:(CGFloat)xPos yPos:(CGFloat)yPos  title:(NSString *)title {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(xPos, yPos, barWidth + barSpacing, 22);
    textLayer.foregroundColor = [UIColor redColor].CGColor;
//    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.fontSize = 14.0;
    textLayer.string = title;
    [self.mainLayer addSublayer:textLayer];
}

- (CGFloat)translateHeightValueToYPosition:(CGFloat)value {
    CGFloat height = value * (self.mainLayer.frame.size.height - BottomMargin - TopMargin);
    return self.mainLayer.frame.size.height - BottomMargin - height;
}
#pragma mark 懒加载
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return _contentScrollView;
}

- (CAShapeLayer *)mainLayer {
    if (!_mainLayer) {
        _mainLayer = [[CAShapeLayer alloc] init];
    }
    return _mainLayer;
}

- (NSMutableArray *)dataEntries {
    if (!_dataEntries) {
        _dataEntries = [[NSMutableArray alloc] init];
    }
    return _dataEntries;
}
@end
