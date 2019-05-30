//
//  NSObject+Rect.h
//  StockWatch
//
//  Created by shangshuai on 2019/3/28.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Rect)

- (CGFloat)getWidth:(UIView *)view;

- (CGFloat)getHeight:(UIView *)view;

- (CGFloat)screenWidth ;

- (CGFloat)screenHeight;

@end

NS_ASSUME_NONNULL_END
