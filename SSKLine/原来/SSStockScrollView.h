//
//  SSStockScrollView.h
//  SSKLine
//
//  Created by shangshuai on 2019/4/22.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSStockScrollView : UIScrollView

/** 内容视图 */
@property (nonatomic, strong) UIView *contentView;
/** 显示背景网格 */
@property (nonatomic, assign) BOOL showBackgroundGird;
/** 可见K线数组 */
@property (nonatomic, copy) NSArray *visibleModels;

- (void)updateContentOffset:(CGPoint)offset;
/** 画K线 */
- (void)drawKLineLayer:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
