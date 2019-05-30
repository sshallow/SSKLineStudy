//
//  SSNetwork.m
//  StockWatch
//
//  Created by shangshuai on 2019/3/29.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "SSNetwork.h"
#import <AFNetworking.h>
#import "Constants.h"
#import "NSDictionary+createToken.h"
#import <SVProgressHUD.h>

@implementation SSNetwork

/** GET请求 */
- (void)GET:(NSString *)URLString parameters:(id)parameters needToken:(BOOL)needToken success:(successBlock)success failure:(failureBlock)failure {
    if (URLString)
        self.url = URLString;
    else
        self.url = [self configURLString];
    self.needToken = needToken;
    if (self.needToken) parameters = [parameters createToken];
    self.parameters = parameters;
    //解包
    [self unwrapping];
    [SVProgressHUD showWithStatus:@"loading"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    [manager GET:self.url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        success(@{@"url":self.url},responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        failure(error);
    }];
}

/** POST请求 */
- (void)POST:(NSString *)URLString parameters:(id)parameters needToken:(BOOL)needToken success:(successBlock)success failure:(failureBlock)failure {
    if (URLString)
        self.url = URLString;
    else
        self.url = [self configURLString];
    self.needToken = needToken;
    if (self.needToken) parameters = [parameters createToken];
    self.parameters = parameters;
    //解包
    [self unwrapping];
    if (self.showHUD) [SVProgressHUD showWithStatus:@"loading"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    [manager POST:self.url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.showHUD) [SVProgressHUD dismiss];
        success([self requestBody],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.showHUD) [SVProgressHUD showErrorWithStatus:@"Time out"];
        failure(error);
    }];
}

- (void)uploadImageUrl:(NSString *)URLString parameters:(id)parameters needToken:(BOOL)needToken name:(NSString *)name images:(NSArray *)images fileNames:(NSArray<NSString *> *)fileNames imageType:(NSString *)imageType success:(successBlock)success failure:(failureBlock)failure {
    if (URLString)
        self.url = URLString;
    else
        self.url = [self configURLString];
    self.needToken = needToken;
    if (self.needToken) parameters = [parameters createToken];
    self.parameters = parameters;
    //解包
    [self unwrapping];
    [SVProgressHUD showWithStatus:@"loading"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:self.url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < images.count; i++ ) {
            NSData *imageData = UIImageJPEGRepresentation(images[i], 1.0f);
            //默认图片名为时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *dateName = [NSString  stringWithFormat:@"%@.jpg",dateString];
            /**
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:name fileName:fileNames[i] ? fileNames[i] : dateName mimeType:[NSString stringWithFormat:@"image/%@",imageType ? imageType : @"png"]];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"progress is %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        success([self requestBody],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        failure(error);
    }];
    
}

/** 默认 showhud
- (BOOL)showHUD {
    if (!_showHUD) {
        _showHUD = YES;
    }
    return _showHUD;
}*/

- (void)unwrapping {
    NSURL *url = [NSURL URLWithString:self.url];
    self.scheme = url.scheme;
    self.host = url.host;
    self.port = url.port > 0 ? [url.port stringValue]:@"443";
    self.path = url.path;
    self.parameters = self.parameters ? self.parameters : @{};
    ///...
}

/** requestBody */
- (NSDictionary *)requestBody {
    NSDictionary *requestBodys = @{
                                  @"scheme": self.scheme,
                                  @"host": self.host,
                                  @"port": self.port,
                                  @"path": self.path,
                                  @"url": self.url,
                                  @"parameters": self.parameters,
                                  };
    return requestBodys;
}

/** 配置url */
- (NSString *)configURLString {
    if (!self.scheme) {
        self.scheme = kScheme;
    }
    if (!self.host) {
        self.host = kHOST;
    }
    if (!self.port) {
        self.port = kPort;
    }
    if (!self.path) {
        self.path = kPath;
    }
    self.url = [NSString stringWithFormat:@"%@%@:%@%@",self.scheme,self.host,self.port,self.path];
    return self.url;
}

@end
