//
//  SSNetwork.h
//  StockWatch
//
//  Created by shangshuai on 2019/3/29.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^successBlock)(id _Nullable requset, id _Nullable responseObject);

typedef void(^failureBlock)(NSError * _Nullable error);

@interface SSNetwork : NSObject

/** 协议 */
@property (nonatomic, copy  ) NSString     *scheme;
/** 主机地址 */
@property (nonatomic, copy  ) NSString     *host;
/** 端口 */
@property (nonatomic, copy  ) NSString     *port;
/** 路径 */
@property (nonatomic, copy  ) NSString     *path;
/** 完整 url */
@property (nonatomic, copy  ) NSString     *url;
/** 需要 token */
@property (nonatomic, assign) BOOL         needToken;
/** 参数 */
@property (nonatomic, copy  ) NSDictionary *parameters;
/** 打印日志 */
@property (nonatomic, assign) BOOL         Log;
/** 是否显示默认 hud */
@property (nonatomic, assign) BOOL         showHUD;

/** GET请求 */
- (void)GET:(NSString * _Nullable)URLString
 parameters:(id _Nullable)parameters
  needToken:(BOOL)needToken
    success:(successBlock)success
    failure:(failureBlock)failure;

/** POST请求 */
- (void)POST:(NSString * _Nullable)URLString
  parameters:(id _Nullable)parameters
   needToken:(BOOL)needToken
     success:(successBlock)success
     failure:(failureBlock)failure;

/**
 上传图片
 @param URLString  请求地址
 @param parameters 请求参数
 @param needToken  需要 token
 @param name       图片对应服务器上的字段
 @param images     图片数组
 @param fileNames  图片文件名数组,默认为当前日期时间"yyyyMMddHHmmss
 @param imageType  文件的类型
 @param success    请求成功的回调
 @param failure    请求失败的回调
 */
- (void)uploadImageUrl:(NSString * _Nullable)URLString
            parameters:(id _Nullable)parameters
             needToken:(BOOL)needToken
                  name:(NSString * _Nullable)name
                images:(NSArray * _Nullable)images
             fileNames:(NSArray<NSString *> * _Nullable)fileNames
             imageType:(NSString * _Nullable)imageType
               success:(successBlock)success
               failure:(failureBlock)failure;

@end

NS_ASSUME_NONNULL_END
