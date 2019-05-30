//
//  KLineModel.m
//  SSKLine
//
//  Created by shangshuai on 2019/4/24.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "KLineModel.h"

@implementation KLineModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    KLineModel *model = [[KLineModel alloc]init];
    [model setValuesForKeysWithDictionary:dictionary];
    return model;
}

@end
