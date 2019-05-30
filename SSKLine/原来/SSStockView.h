//
//  SSStockView.h
//  SSKLine
//
//  Created by shangshuai on 2019/4/23.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SSStockView,KLineModel;
#pragma mark 数据源代理
@protocol SSStockViewDataSource <NSObject>

/** 返回 model */
- (KLineModel *)ssStockViewDelegate:(SSStockView *)ssStockView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/** 返回 model 显示个数 */
- (NSInteger)numberOfSectionsInSSStockView:(SSStockView *)ssStockView;

@optional

@end

#pragma mark 代理
@protocol SSStockViewDelegate <NSObject>

/** 长按 */
- (KLineModel *)ssStockView:(SSStockView *)ssStockView longPressItemAtIndexPath:(nullable NSIndexPath *)indexPath;

@end

@interface SSStockView : UIView

@property (nonatomic, readonly) NSArray *visibleModels;

@property (nonatomic, weak) id <SSStockViewDataSource,SSStockViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
