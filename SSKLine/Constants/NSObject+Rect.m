//
//  NSObject+Rect.m
//  StockWatch
//
//  Created by shangshuai on 2019/3/28.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "NSObject+Rect.h"

@implementation NSObject (Rect)

- (CGFloat)getWidth:(UIView *)view {
    return view.bounds.size.width;
}

- (CGFloat)getHeight:(UIView *)view {
    return view.bounds.size.height;
}

- (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
