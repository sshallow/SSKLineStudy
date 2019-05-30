//
//  SSStockView.m
//  SSKLine
//
//  Created by shangshuai on 2019/4/23.
//  Copyright © 2019 shangshuai. All rights reserved.
//

#import "SSStockView.h"
#import "SSStockScrollView.h"
#import "Calculator.h"

@interface SSStockView ()<UIScrollViewDelegate>

@property (nonatomic, strong) SSStockScrollView *ssStockScrollView;

@property (nonatomic, strong) SSStockScrollView *secondSSStockScrollView;

@property (nonatomic, assign) CGFloat preOffsetX;
@end

@implementation SSStockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.ssStockScrollView];
    [self addSubview:self.secondSSStockScrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x - self.preOffsetX;
    NSLog(@"***** contentOffset.x :%f ********** offset :%f *****self.preOffsetX:%f",scrollView.contentOffset.x,offset,self.preOffsetX);
//    return;
    [scrollView setNeedsDisplay];
    if (scrollView.contentOffset.x > 0) {
        /** 计算 */
        Calculator *calculator = [Calculator sharedInstance];
        [calculator calculatorNextIndexWithOffset:CGPointMake(offset, 0)];
        [calculator calculatorVisibleNumberWithOffset:CGRectGetWidth(scrollView.bounds)];
        NSArray * visibleModels = [calculator calculatorVisibleModels];
        /** 调用StockScrollView绘制 */
        self.ssStockScrollView.visibleModels = visibleModels;
//        [self.ssStockScrollView drawKLineLayer:visibleModels];
//        [self.secondSSStockScrollView updateContentOffset:scrollView.contentOffset];
    }
    /** 偏移 StockScrollView.contentView */
    [self.ssStockScrollView updateContentOffset:CGPointMake(offset, 0)];
//    [self.secondSSStockScrollView updateContentOffset:CGPointMake(offset, 0)];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.preOffsetX = scrollView.contentOffset.x;
    NSLog(@"***** end   self.preOffsetX :%f *****",self.preOffsetX);
}

#pragma mark 懒加载
- (SSStockScrollView *)ssStockScrollView {
    if (!_ssStockScrollView) {
        _ssStockScrollView = [[SSStockScrollView alloc] init];
        _ssStockScrollView.showBackgroundGird = YES;
        _ssStockScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 200);
        _ssStockScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 3, 0);
        _ssStockScrollView.delegate = self;
    }
    return _ssStockScrollView;
}

- (SSStockScrollView *)secondSSStockScrollView {
    if (!_secondSSStockScrollView) {
        _secondSSStockScrollView = [[SSStockScrollView alloc] init];
        _secondSSStockScrollView.showBackgroundGird = YES;
        _secondSSStockScrollView.frame = CGRectMake(0, 210, CGRectGetWidth(self.bounds), 80);
        _secondSSStockScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 3, 0);
        _secondSSStockScrollView.delegate = self;
    }
    return _secondSSStockScrollView;
}
@end
