//
//  SSStockConst.h
//  SSKLine
//
//  Created by shangshuai on 2019/4/24.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSStockConst : NSObject

/** K线 默认宽度 */
extern CGFloat const StockDefaultKLineWidth;
/** K线 最大宽度 */
extern CGFloat const StockMaxKLineWidth;
/** K线 最小宽度 */
extern CGFloat const StockMinKLineWidth;
/** K线 默认显示个数 */
extern CGFloat const StockDefaultShowKLineCounts;
/** K线 最大显示个数 */
extern CGFloat const StockMaxShowKLineCounts;
/** K线 最小显示个数 */
extern CGFloat const StockMinShowKLineCounts;
/** K线 间隔 */
extern CGFloat const StockKLineSpacing;

#pragma mark 学习
/** 宽度 */
extern CGFloat const barWidth;
/** 间距 */
extern CGFloat const barSpacing;
/** 距顶部 */
extern CGFloat const TopMargin;
/** 距底部 */
extern CGFloat const BottomMargin;
@end

NS_ASSUME_NONNULL_END
