//
//  ControlChartDataAnalyzer.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "ControlChartDataAnalyzer.h"
#import "ControlChartView.h"

@implementation ControlChartDataAnalyzer

+ (void)getStatisticalValuesOfDoubleArray:(NSArray *)dataArr checkRulesArray:(NSArray *)rulesArr controlChartType:(NSString *)type withBlock:(void (^)(float, float, float, NSArray *, NSString *))block {
    
}

+ (void)calculateControlLineValuesOfData:(NSArray *)dataArray controlChartType:(NSString *)type block:(void (^)(float, float, float))block {
    if ([type isEqualToString:ControlChartTypeXBarR]) {
        
    }
}

+ (void)checkData:(NSArray *)dataArray withRule:(NSString *)checkRule block:(void (^)(NSArray *, NSString *))block {
    
}

@end
