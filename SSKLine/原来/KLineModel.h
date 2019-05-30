//
//  KLineModel.h
//  SSKLine
//
//  Created by shangshuai on 2019/4/24.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLineModel : NSObject

@property (nonatomic, copy) NSString *open;

@property (nonatomic, copy) NSString *close;

@property (nonatomic, copy) NSString *high;

@property (nonatomic, copy) NSString *low;

@property (nonatomic, copy) NSString *symbol;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *volume;

@property (nonatomic, copy) NSString *format_date;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
