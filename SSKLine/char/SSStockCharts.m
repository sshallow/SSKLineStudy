//
//  SSStockCharts.m
//  SSKLine
//
//  Created by shangshuai on 2019/4/25.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "SSStockCharts.h"
#import "EModel.h"
//#import "SSStockConst.h"

@interface SSStockCharts ()

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) CAShapeLayer *mainLayer;

@property (nonatomic, strong) CAShapeLayer *dataLayer;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) CAShapeLayer *gridLayer;

@property (nonatomic, strong) UIView *scrollViewContentView;

@end

@implementation SSStockCharts
@synthesize dataEntries = _dataEntries;

CGFloat bottomSpace = 40.0;
CGFloat topSpace = 100;
CGFloat topBubbleRadius = 20.0;
CGFloat barWidth1 = 140;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.mainScrollView.layer addSublayer:self.mainLayer];
    [self addSubview:self.mainScrollView];
}

- (void)drawCurvedChart {
    if (self.dataPoints.count <= 0) {
        return;
    }
//    UIBezierPath *path =
//    if let path = CurveAlgorithm.shared.createCurvedPath(dataPoints) {
//        let lineLayer = CAShapeLayer()
//        lineLayer.path = path.cgPath
//        lineLayer.strokeColor = UIColor.white.cgColor
//        lineLayer.fillColor = UIColor.clear.cgColor
//        dataLayer.addSublayer(lineLayer)
//    }
}

- (void)setupGird {
    NSArray * horizontalLineInfos = @[@{@"value": @0.0, @"dashed": [NSNumber numberWithBool:false]},
                                      @{@"value": @0.25, @"dashed": [NSNumber numberWithBool:true]},
                                      @{@"value": @0.5, @"dashed": [NSNumber numberWithBool:true]},
                                      @{@"value": @0.75, @"dashed": [NSNumber numberWithBool:true]},
                                      @{@"value": @1.0, @"dashed": [NSNumber numberWithBool:false]}];
    for (NSDictionary * dic in horizontalLineInfos) {
        CGFloat xPos = 0.0;
        CGFloat yPos = [self translateHeightValueToYPosition:[dic[@"value"] floatValue]];
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(xPos, yPos)];
        [linePath addLineToPoint:CGPointMake(self.mainScrollView.frame.size.width, yPos)];
        lineLayer.lineWidth = 1;
        lineLayer.path = linePath.CGPath;
        if ([dic[@"dashed"] boolValue]) {
            lineLayer.lineDashPattern = @[@4,@4];
        }
        lineLayer.strokeColor = [UIColor redColor].CGColor;
        [self.layer insertSublayer:lineLayer atIndex:0];
    }
}

- (CGFloat)translateHeightValueToYPosition:(CGFloat)value {
    CGFloat height = value * (self.mainLayer.frame.size.height - bottomSpace - topSpace);
    return self.mainLayer.frame.size.height - bottomSpace - height;
}

- (void)showEntry:(NSInteger)index  entry:(EModel *)object {
    CGFloat height = object.height * (self.mainLayer.frame.size.height - bottomSpace - topSpace);
    /// Starting x postion of the bar
    CGFloat xPos  = index * barWidth1 / 2;
    
    /// Starting y postion of the bar
    CGFloat yPos = [self translateHeightValueToYPosition:object.height];
    
    [self drawBar:xPos yPos:yPos height:height];
    
    /// Draw the top bubble
    [self drawTopBuble:xPos+barWidth1/2-topBubbleRadius yPos:round(yPos - height - 80)];
    
    [self drawLinkingLine:xPos+barWidth1/2 yPos:yPos - height - 4];
    
    /// Draw text above the bar
    [self drawBar:xPos+barWidth1/2-topBubbleRadius yPos:yPos - height - 86 textValue:object.textValue];
    
    /// Draw text below the bar
    [self drawTitle:xPos  yPos:yPos + 10 title:object.title];
}

- (void)drawBar:(CGFloat)xPos yPos:(CGFloat)yPos height:(CGFloat)height{
    CAShapeLayer *leftLine = [CAShapeLayer layer];
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(xPos, yPos)];
    [leftPath addCurveToPoint:CGPointMake(xPos+barWidth1/2, xPos+barWidth1/2) controlPoint1:CGPointMake((xPos+barWidth1/2),  yPos) controlPoint2:CGPointMake(xPos + barWidth1*3/10,yPos - height)];
    [leftPath addLineToPoint:CGPointMake(xPos + barWidth1/2,  yPos)];
    leftPath.lineWidth = 0.0;
    leftLine.path = leftPath.CGPath;
    leftLine.strokeColor = [UIColor redColor].CGColor;
    leftLine.fillColor = [UIColor greenColor].CGColor;
    
    CAShapeLayer *rigthLine = [CAShapeLayer layer];
    UIBezierPath *righteftPath = [UIBezierPath bezierPath];
    [righteftPath moveToPoint:CGPointMake(xPos+barWidth1, yPos)];
    [righteftPath addCurveToPoint:CGPointMake(xPos + barWidth1/2,  yPos-height) controlPoint1:CGPointMake(xPos+barWidth1/2, yPos) controlPoint2:CGPointMake(xPos + barWidth1*7/10, yPos-height)];
    [righteftPath addLineToPoint:CGPointMake(xPos + barWidth1/2,  yPos)];
    righteftPath.lineWidth = 0.0;
    rigthLine.path = righteftPath.CGPath;
    rigthLine.strokeColor = [UIColor redColor].CGColor;
    rigthLine.fillColor = [UIColor greenColor].CGColor;
    
    [self.mainLayer addSublayer:leftLine];
    [self.mainLayer addSublayer:rigthLine];
}

- (void)maskGradientLayer:(CGFloat)xPos yPos:(CGFloat)yPos height:(CGFloat)height path:(UIBezierPath *)path1{
    if (self.dataPoints.count > 0) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(xPos, self.dataLayer.frame.size.height)];
        [path addLineToPoint:CGPointMake(xPos, yPos)];

        UIBezierPath *curvedPath = path1;
        [path appendPath:curvedPath];
        CGFloat x  = (self.dataEntries.count - 1) * barWidth1 / 2;
        
        /// Starting y postion of the bar
        CGFloat y = [self translateHeightValueToYPosition:((EModel *)self.dataEntries.lastObject).height];
        CGPoint lastObjectPoints = CGPointMake(x, y);
        
        [path addLineToPoint:CGPointMake(lastObjectPoints.x, self.dataLayer.frame.size.height)];
        [path addLineToPoint:CGPointMake(xPos, self.dataLayer.frame.size.height)];
        
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = path.CGPath;
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        maskLayer.strokeColor = [UIColor clearColor].CGColor;
        maskLayer.lineWidth = 0.0;
        
        self.gradientLayer.mask = maskLayer;
    }
}

- (void)drawTopBuble:(CGFloat)xPos yPos:(CGFloat)yPos {
    CGFloat magicValue = 0.552284749831 * topBubbleRadius;
    
    CAShapeLayer *lineLayer1 = [CAShapeLayer layer];
    UIBezierPath *linePath1 = [UIBezierPath bezierPath];
    [linePath1 moveToPoint:CGPointMake(xPos, yPos)];
    [linePath1 addCurveToPoint:CGPointMake(xPos+topBubbleRadius, yPos-topBubbleRadius) controlPoint1:CGPointMake(xPos, yPos-magicValue) controlPoint2:CGPointMake(xPos+topBubbleRadius-magicValue, yPos-topBubbleRadius)];
    [linePath1 addLineToPoint:CGPointMake(xPos+topBubbleRadius, yPos)];
    lineLayer1.lineWidth = 0.0;
    lineLayer1.path = linePath1.CGPath;
    lineLayer1.strokeColor = [UIColor redColor].CGColor;
    lineLayer1.fillColor = [UIColor greenColor].CGColor;
    [self.mainLayer addSublayer:lineLayer1];
    
    CAShapeLayer *lineLayer2 = [CAShapeLayer layer];
    UIBezierPath *linePath2 = [UIBezierPath bezierPath];
    [linePath2 moveToPoint:CGPointMake(xPos+topBubbleRadius, yPos-topBubbleRadius)];
    [linePath2 addCurveToPoint:CGPointMake(xPos+topBubbleRadius*2, yPos) controlPoint1:CGPointMake(xPos+topBubbleRadius+magicValue, yPos-topBubbleRadius) controlPoint2:CGPointMake( xPos+topBubbleRadius*2, yPos-magicValue)];
    [linePath2 addLineToPoint:CGPointMake(xPos+topBubbleRadius, yPos)];
    lineLayer2.lineWidth = 0.0;
    lineLayer2.path = linePath2.CGPath;
    lineLayer2.strokeColor = [UIColor redColor].CGColor;
    lineLayer2.fillColor = [UIColor greenColor].CGColor;
    [self.mainLayer addSublayer:lineLayer2];
    
    CAShapeLayer *lineLayer3 = [CAShapeLayer layer];
    UIBezierPath *linePath3 = [UIBezierPath bezierPath];
    [linePath3 moveToPoint:CGPointMake(xPos, yPos)];
    [linePath3 addCurveToPoint:CGPointMake(xPos+topBubbleRadius, yPos+topBubbleRadius*1.5) controlPoint1:CGPointMake(xPos, yPos+magicValue) controlPoint2:CGPointMake(xPos+topBubbleRadius-magicValue, yPos+topBubbleRadius)];
    [linePath3 addLineToPoint:CGPointMake(xPos+topBubbleRadius, yPos)];
    lineLayer3.lineWidth = 0.0;
    lineLayer3.path = linePath3.CGPath;
    lineLayer3.strokeColor = [UIColor redColor].CGColor;
    lineLayer3.fillColor = [UIColor greenColor].CGColor;
    [self.mainLayer addSublayer:lineLayer3];
    
    CAShapeLayer *lineLayer4 = [CAShapeLayer layer];
    UIBezierPath *linePath4 = [UIBezierPath bezierPath];
    [linePath4 moveToPoint:CGPointMake(xPos+topBubbleRadius*2, yPos)];
    [linePath4 addCurveToPoint:CGPointMake(xPos+topBubbleRadius, yPos+topBubbleRadius*1.5) controlPoint1:CGPointMake(xPos+topBubbleRadius*2,yPos+magicValue) controlPoint2:CGPointMake(xPos+topBubbleRadius+magicValue, yPos+topBubbleRadius)];
    [linePath4 addLineToPoint:CGPointMake(xPos+topBubbleRadius, yPos)];
    lineLayer4.lineWidth = 0.0;
    lineLayer4.path = linePath4.CGPath;
    lineLayer4.strokeColor = [UIColor redColor].CGColor;
    lineLayer4.fillColor = [UIColor greenColor].CGColor;
    [self.mainLayer addSublayer:lineLayer4];
}

- (void)drawBar:(CGFloat)xPos yPos:(CGFloat)yPos  textValue:(NSString *)textValue {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(xPos, yPos, topBubbleRadius*2, 22);
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    //    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.fontSize = 14.0;
    textLayer.string = textValue;
    [self.mainLayer addSublayer:textLayer];
}

- (void)drawTitle:(CGFloat)xPos yPos:(CGFloat)yPos  title:(NSString *)title {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(xPos, yPos, barWidth1, 22);
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    //    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.fontSize = 14.0;
    textLayer.string = title;
    [self.mainLayer addSublayer:textLayer];
}

- (void)drawLinkingLine:(CGFloat)xPos yPos:(CGFloat)yPos {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(xPos, yPos)];
    [linePath addLineToPoint:CGPointMake(xPos, yPos-40)];
    lineLayer.lineWidth = 2;
    lineLayer.path = linePath.CGPath;
    lineLayer.strokeColor = [UIColor redColor].CGColor;
    [self.mainLayer addSublayer:lineLayer];
    
    CAShapeLayer *lineLayer1 = [CAShapeLayer layer];
    lineLayer1.frame = CGRectMake(xPos-3, yPos - 40, 6, 6);
    lineLayer1.cornerRadius = 3;
    lineLayer1.backgroundColor = [UIColor purpleColor].CGColor;
    [self.mainLayer addSublayer:lineLayer1];
}


#pragma mark 懒加载
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return _mainScrollView;
}

- (UIView *)scrollViewContentView {
    if (!_scrollViewContentView) {
        _scrollViewContentView = [[UIView alloc] init];
    }
    return _scrollViewContentView;
}

- (CAShapeLayer *)mainLayer {
    if (!_mainLayer) {
        _mainLayer = [[CAShapeLayer alloc] init];
    }
    return _mainLayer;
}

- (NSMutableArray *)dataPoints {
    if (!_dataPoints) {
        _dataPoints = [[NSMutableArray alloc] init];
    }
    return _dataPoints;
}

- (NSMutableArray *)dataEntries {
    if (!_dataEntries) {
        _dataEntries = [[NSMutableArray alloc] init];
    }
    return _dataEntries;
}

- (void)setDataEntries:(NSMutableArray <EModel *>*)dataEntries {
    _dataEntries = dataEntries;
    if (dataEntries.count > 0) {
        self.mainScrollView.contentSize = CGSizeMake(barWidth1 * (dataEntries.count + 1) / 2,self.frame.size.height);
        self.mainLayer.frame = CGRectMake(0,0,  self.mainScrollView.contentSize.width,  self.mainScrollView.contentSize.height);
        [self setupGird];
        [dataEntries enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self showEntry:idx entry:obj];
        }];
    }
}

@end
