//
//  SSStockScrollView.m
//  SSKLine
//
//  Created by shangshuai on 2019/4/22.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "SSStockScrollView.h"
#import "NSObject+Rect.h"
#import "Constants.h"
#import "KLineModel.h"
#import "SSStockConst.h"
#import "Calculator.h"

@interface SSStockScrollView ()
@property (nonatomic, strong) NSMutableArray *layerArray;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;       ///渐变阴影

@end

@implementation SSStockScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.contentView];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.showBackgroundGird) {
        [self setupGird];
    }
}

/** 画背景线 */
- (void)setupGird {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
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
    [self.contentView.layer addSublayer:lineLayer];
    [self.layerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    [self.layerArray removeAllObjects];
    
    [self testLine];
//    [self drawKLineLayer:nil];
}

- (void)testLine {
    //初始化一个线的图层
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    //初始化一个描述的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    //设置线段开始的点
    [linePath moveToPoint:CGPointMake(4, 180)];
    [linePath addLineToPoint:CGPointMake(4, 40)];
    //设置线段结束的点
    //这里也可以添加多个点
    [linePath addLineToPoint:CGPointMake( 14, 80)];
    [linePath addLineToPoint:CGPointMake( 24, 40)];
    [linePath addLineToPoint:CGPointMake( 34, 80)];
    [linePath addLineToPoint:CGPointMake( 44, 40)];
    [linePath addLineToPoint:CGPointMake( 54, 80)];
    [linePath addLineToPoint:CGPointMake( 64, 40)];
    [linePath addLineToPoint:CGPointMake( 74, 80)];
    [linePath addLineToPoint:CGPointMake( 74, 180)];
    linePath.lineCapStyle = kCGLineCapRound;
    linePath.lineJoinStyle = kCGLineJoinRound;
    //设置图层路径
    lineLayer.path = linePath.CGPath;
    //设置图层的其他属性
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = RGB(0, 158, 255).CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.contentView.layer addSublayer:lineLayer];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0,00, self.frame.size.width, 180);
    self.gradientLayer.colors =@[(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor];
    
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = linePath.CGPath;
    self.gradientLayer.mask = arc;
    [self.contentView.layer addSublayer:self.gradientLayer];

}
/** 画K线 */
- (void)drawKLineLayer:(NSArray <KLineModel *>*)array {
    NSLog(@"***** drawKLineLayer :%ld *****",array.count);
    Calculator *calculator = [Calculator sharedInstance];
    //初始化一个线的图层
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    //初始化一个描述的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    //moveToPoint 设置线段开始的点、 addLineToPoint 多个连接。
    [linePath moveToPoint:CGPointMake(4, 40)];
    [self.visibleModels enumerateObjectsUsingBlock:^(KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [linePath addLineToPoint:CGPointMake((StockMaxKLineWidth + StockKLineSpacing) * idx + 4, [calculator calculatorModelY:obj])];
    }];
    
    //路径赋给图层
    lineLayer.path = linePath.CGPath;
    //设置图层的属性
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = RGB(0, 158, 255).CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layerArray addObject:lineLayer];
    [self.contentView.layer addSublayer:lineLayer];
    [CATransaction commit];
    
    UIBezierPath *gradientPath = [[UIBezierPath alloc] init];
    CGPoint firstPoint = CGPointMake((StockMaxKLineWidth + StockKLineSpacing) * 1 + 4, [calculator calculatorModelY:self.visibleModels.firstObject]) ;
    CGPoint lastPoint = CGPointMake((StockMaxKLineWidth + StockKLineSpacing) * (self.visibleModels.count - 1) + 4, [calculator calculatorModelY:self.visibleModels.lastObject]);
    [gradientPath moveToPoint:firstPoint];
    [self.visibleModels enumerateObjectsUsingBlock:^(KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [gradientPath addLineToPoint:CGPointMake((StockMaxKLineWidth + StockKLineSpacing) * idx + 4, [calculator calculatorModelY:obj])];
    }];
    
    CGPoint endPoint = lastPoint;
    endPoint = CGPointMake(endPoint.x ,160);
    [gradientPath addLineToPoint:endPoint];
    
    
}

/** UIScrollView 滑动回调 */
- (void)updateContentOffset:(CGPoint)offset {
    self.contentView.frame = CGRectMake(offset.x, CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.contentOffset = offset;
}

#pragma mark 懒加载

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _contentView;
}

- (NSMutableArray *)layerArray {
    if (!_layerArray) {
        _layerArray = [[NSMutableArray alloc] init];
    }
    return _layerArray;
}
@end
