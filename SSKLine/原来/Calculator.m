//
//  Calculator.m
//  SSKLine
//
//  Created by shangshuai on 2019/4/24.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "Calculator.h"
#import "SSStockConst.h"
#import "KLineModel.h"

@interface Calculator ()

@property (nonatomic, assign) CGFloat max;

@property (nonatomic, assign) CGFloat min;

@end

@implementation Calculator
@synthesize dataSourceArray = _dataSourceArray;

+ (instancetype)sharedInstance {
    static Calculator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (void)config {
    self.max = 0;
    self.min = 0;
}

- (void)calculatorNextIndex:(NSInteger)index visibleNumber:(NSInteger)number {
    
}

/** 返回要显示的索引 */
- (NSInteger)calculatorNextIndexWithOffset:(CGPoint)offset {
    CGFloat offsetWidth = offset.x;
    NSInteger offsetIndex = offsetWidth / (StockKLineSpacing + self.currentKLineWidth);//偏移量/(间距+宽度)=偏移个数
//    NSInteger firstShowIndex = self.dataSourceArray.count - offsetIndex;//总数-偏移个数=将要显示的索引
    NSLog(@"***** offsetIndex :%ld *****",offsetIndex);
    self.firstIndex = offsetIndex;
    return offsetIndex;
}

/** 返回显示个数 */
- (NSInteger)calculatorVisibleNumberWithOffset:(CGFloat)width {
    //test
    self.currentKLineWidth = StockDefaultKLineWidth;
    NSInteger visibleNumber = width / (StockKLineSpacing + self.currentKLineWidth);//偏移量/(间距+宽度)=偏移个数
    self.currentVisibleNumber = visibleNumber;
    return visibleNumber;
}

/** 返回显示数组 */
- (NSArray *)calculatorVisibleModels {
    if (self.dataSourceArray.count > 0) {
        @synchronized(self) {
            _visibleModels = nil;
            NSMutableArray *arrar = [[NSMutableArray alloc]init];
            for (NSInteger i = self.firstIndex; i < (self.firstIndex + self.currentVisibleNumber); i ++) {
                [arrar addObject:self.dataSourceArray[i]];
            }
            _visibleModels = [[NSArray alloc]initWithArray:arrar];
            [self calculatorCurrentMax_Y];
            [self calculatorCurrentMin_Y];
        }
    }
    return self.visibleModels;
}

- (CGFloat)calculatorModelY:(KLineModel *)model {
    CGFloat coefficient = (200 - 40) / (self.currentMAX_Y - self.currentMIN_Y);
    CGFloat y = 180 - ([model.close floatValue] - self.currentMIN_Y) * coefficient;
    return y;
}

/** 计算当前显示的最大 y 值 */
- (CGFloat)calculatorCurrentMax_Y {
    __block CGFloat max_y = -1;
    if (self.visibleModels.count > 0) {
        [self.visibleModels enumerateObjectsUsingBlock:^(KLineModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat high = [obj.high floatValue];
            if (high > 0) {
                max_y = max_y > high ? max_y : high;
                self.currentMAX_Y = max_y;
            }
        }];
    }
    return max_y;
}
/** 计算当前显示的最小 y 值 */
- (CGFloat)calculatorCurrentMin_Y {
    __block CGFloat min_y = -1;
    if (self.visibleModels.count > 0) {
        [self.visibleModels enumerateObjectsUsingBlock:^(KLineModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat low = [obj.low floatValue];
            if (low > 0) {
                min_y = min_y > 0 && min_y < low ? min_y : low;
                self.currentMIN_Y = min_y;
            }
        }];
    }
    return min_y;
}

/** 计算所有最大最小 y 值 */
- (void)setDataSourceArray:(NSMutableArray *)dataSourceArray {
    _dataSourceArray = dataSourceArray;
    /** 找峰值(最大/最小) */
    [dataSourceArray enumerateObjectsUsingBlock:^(KLineModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat high = [obj.high floatValue];
        if (high > 0) {
            self.max = self.max > high ? self.max : high;
        }
        CGFloat low = [obj.low floatValue];
        if (low > 0) {
            self.min = self.min < low ? self.min : low;
        }
    }];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

@end
