//
//  EModel.h
//  SSKLine
//
//  Created by shangshuai on 2019/4/25.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface EModel : NSObject

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSString *textValue;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, assign) CGFloat color;

@end

NS_ASSUME_NONNULL_END
