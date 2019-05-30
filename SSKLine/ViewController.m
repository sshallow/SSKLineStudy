//
//  ViewController.m
//  SSKLine
//
//  Created by shangshuai on 2019/4/22.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "ViewController.h"
#import "SSStockChart.h"
#import "SSNetwork/SSNetwork.h"
#import "KLineModel.h"
#import "Calculator.h"
#import "SSStockCharts.h"
#import "EModel.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController
SSStockChart *ssStockView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor grayColor];
    ssStockView = [[SSStockChart alloc]initWithFrame:CGRectMake(20, 60, 600, 300)];
    [self.view addSubview:ssStockView];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 20; i ++) {
        EModel *model = [[EModel alloc]init];
        float value = (arc4random() % 90) + 10;
        model.height = value / 100.0;
        model.title = [NSString stringWithFormat:@"%.3f",value / 100.0];
        model.textValue = [NSString stringWithFormat:@"%d",i];
        [array addObject:model];
    }
    ssStockView.dataEntries = array;
//    [self load];
}

- (void)load {
    NSDictionary *parameters = @{@"symbol":@"AMD",
                                 @"ktype":@"day",
                                 };
    SSNetwork *network = [[SSNetwork alloc]init];
    network.path = @"/stock/kline";
    [network POST:nil parameters:parameters needToken:YES success:^(id  _Nullable requset, id  _Nullable responseObject) {
        NSLog(@"***** response :%@ *****",responseObject);
        NSDictionary *responseDictionary = responseObject;
        if ([responseDictionary[@"code"] isEqualToNumber:@200]) {
            NSArray *data = responseDictionary[@"data"];
            if (data.count > 0) {
                [responseDictionary[@"data"][@"klines"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    KLineModel *model = [KLineModel modelWithDictionary:obj];
                    [self.dataArray addObject:model];
                }];
//                ssStockView.dataEntries = self.dataArray;
                Calculator *calcutor = [Calculator sharedInstance];
                calcutor.dataSourceArray = self.dataArray;
            }
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"***** error :%@ *****",error);
    }];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
