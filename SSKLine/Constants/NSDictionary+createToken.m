//
//  NSDictionary+createToken.m
//  StockWatch
//
//  Created by shangshuai on 2019/4/1.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "NSDictionary+createToken.h"
#import "Constants.h"
#import "NSString+MD5.h"

@implementation NSDictionary (createToken)

- (NSDictionary *)createToken {
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:3];
    for (NSString *key in [self allKeys]) {
        NSString *string = [NSString stringWithFormat:@"%@=%@",key,[self objectForKey:key]];
        [array addObject:string];
    }
    NSArray *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];
    __block NSString *preString = @"";
    [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        preString = [preString stringByAppendingString:obj];
    }];
    preString = [preString stringByAppendingString:kTokenSuffix];
    preString = [preString MD5Hash];
    
    NSMutableDictionary *cryDictonary = [[NSMutableDictionary alloc]initWithDictionary:self];
    [cryDictonary setValue:preString forKey:@"token"];
    
    return cryDictonary;
}

@end
