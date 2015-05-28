//
//  QKProcessCapabilityAnalysis.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKProcessCapabilityAnalysis.h"

@implementation QKProcessCapabilityAnalysis

+ (float)CPValueOfData:(NSArray *)dataArr USL:(float)USL LSL:(float)LSL {
    __block float RBar = 0;
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeR block:^(id _UCL, id _LCL, float _CL, NSArray *_plotArr) {
        RBar = _CL;
    }];
    float d2 = [QKDef QKConstant_d2:((NSArray *)dataArr[0]).count];
    float CP = (USL - LSL) / (6 * RBar / d2);
    return CP;
}

+ (float)CPUValueOfData:(NSArray *)dataArr USL:(float)USL LSL:(float)LSL {
    __block float XBar = 0;
    __block float RBar = 0;
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeXBar block:^(id _UCL, id _LCL, float _CL, NSArray *_plotArr) {
        XBar = _CL;
    }];
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeR block:^(id _UCL, id _LCL, float _CL, NSArray *_plotArr) {
        RBar = _CL;
    }];
    float d2 = [QKDef QKConstant_d2:((NSArray *)dataArr[0]).count];
    float CPU = (USL - XBar) / (3 * RBar / d2);
    return CPU;
}

+ (float)CPLValueOfData:(NSArray *)dataArr USL:(float)USL LSL:(float)LSL {
    __block float XBar = 0;
    __block float RBar = 0;
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeXBar block:^(id _UCL, id _LCL, float _CL, NSArray *_plotArr) {
        XBar = _CL;
    }];
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeR block:^(id _UCL, id _LCL, float _CL, NSArray *_plotArr) {
        RBar = _CL;
    }];
    float d2 = [QKDef QKConstant_d2:((NSArray *)dataArr[0]).count];
    float CPL = (XBar - LSL) / (3 * RBar / d2);
    return CPL;
}

+ (float)CPKValueOfData:(NSArray *)dataArr USL:(float)USL LSL:(float)LSL {
    float CPU = [self CPUValueOfData:dataArr USL:USL LSL:LSL];
    float CPL = [self CPLValueOfData:dataArr USL:USL LSL:LSL];
    return (CPU <= CPL) ? CPU : CPL;
}

+ (float)PiecesCapabilityValueOfData:(NSArray *)dataArr {
    NSMutableArray *numbersArr = [[NSMutableArray alloc] init];
    NSMutableArray *NArr = [[NSMutableArray alloc] init];
    for (NSArray *tmpArr in dataArr) {
        [numbersArr addObject:tmpArr[1]];
        [NArr addObject:tmpArr[0]];
    }
    float numberSum = [QKStatisticalFoundations sumValueOfArray:numbersArr];
    float NSum = [QKStatisticalFoundations sumValueOfArray:NArr];
    return numberSum / NSum;
}

@end
