//
//  Calculator.h
//  SSKLine
//
//  Created by shangshuai on 2019/4/24.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "KLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Calculator : NSObject

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
/** 当前要显示的模型数组 */
@property (nonatomic, readonly) NSArray *visibleModels;

/** 当前显示的数组的最大值 */
@property (nonatomic, assign) CGFloat currentMAX_Y;
/** 当前显示的数组的最小值 */
@property (nonatomic, assign) CGFloat currentMIN_Y;

/** 当前显示的第一个的索引 */
@property (nonatomic, assign) NSInteger firstIndex;
/** 当前 KLine 宽度 */
@property (nonatomic, assign) CGFloat currentKLineWidth;
/** 当前 KLine 显示数量 */
@property (nonatomic, assign) CGFloat currentVisibleNumber;

/** 计算要显示的索引和显示的数量 */
- (void)calculatorNextIndex:(NSInteger)index visibleNumber:(NSInteger)number;

/** 根据偏移量计算 要显示的索引 */
- (NSInteger)calculatorNextIndexWithOffset:(CGPoint)offset;
/** 根据偏移量计算 显示的数量 */
- (NSInteger)calculatorVisibleNumberWithOffset:(CGFloat)width;
/** 计算 当前 要显示的模型数组 */
- (NSArray *)calculatorVisibleModels;
/** 计算单个模型 的 y 坐标 */
- (CGFloat)calculatorModelY:(KLineModel *)model;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
