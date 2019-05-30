//
//  Constants.h
//  StockWatch
//
//  Created by shangshuai on 2019/3/28.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Constants : NSObject

#pragma mark - 宏定义

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

/** const */
#define ThemeRiseColor RGB(2,171,60)

#define ThemeFallColor RGB(239,63,59)

#define ThemeBackgroundLineColor RGB(54,64,85)

#pragma mark 颜色

extern UIColor * BackgroundLineColor;

#pragma mark - 常量
extern NSString * const kTokenSuffix;

extern NSString * const kScheme;

extern NSString * const kHOST;

extern NSString * const kPort;

extern NSString * const kPath;

@end

NS_ASSUME_NONNULL_END
