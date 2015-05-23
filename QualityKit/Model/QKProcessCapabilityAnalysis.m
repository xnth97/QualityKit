//
//  QKProcessCapabilityAnalysis.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKProcessCapabilityAnalysis.h"

@implementation QKProcessCapabilityAnalysis

+ (float)CPValueOfData:(NSArray *)dataArr {
    __block float UCLValue = 0;
    __block float LCLValue = 0;
    __block float RBar = 0;
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeXBar block:^(float _UCL, float _LCL, float _CL, NSArray *_plotArr) {
        UCLValue = _UCL;
        LCLValue = _LCL;
    }];
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeR block:^(float _UCL, float _LCL, float _CL, NSArray *_plotArr) {
        RBar = _CL;
    }];
    float d2 = [QKDef QKConstant_d2:((NSArray *)dataArr[0]).count];
    float CP = (UCLValue - LCLValue) / (6 * RBar / d2);
    return CP;
}

+ (float)CPUValueOfData:(NSArray *)dataArr {
    __block float UCLValue = 0;
    __block float LCLValue = 0;
    __block float XBar = 0;
    __block float RBar = 0;
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeXBar block:^(float _UCL, float _LCL, float _CL, NSArray *_plotArr) {
        UCLValue = _UCL;
        LCLValue = _LCL;
        XBar = _CL;
    }];
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeR block:^(float _UCL, float _LCL, float _CL, NSArray *_plotArr) {
        RBar = _CL;
    }];
    float d2 = [QKDef QKConstant_d2:((NSArray *)dataArr[0]).count];
    float CPU = (UCLValue - XBar) / (3 * RBar / d2);
    return CPU;
}

+ (float)CPLValueOfData:(NSArray *)dataArr {
    __block float UCLValue = 0;
    __block float LCLValue = 0;
    __block float XBar = 0;
    __block float RBar = 0;
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeXBar block:^(float _UCL, float _LCL, float _CL, NSArray *_plotArr) {
        UCLValue = _UCL;
        LCLValue = _LCL;
        XBar = _CL;
    }];
    [QKDataAnalyzer calculateControlLineValuesOfData:dataArr controlChartType:QKControlChartTypeR block:^(float _UCL, float _LCL, float _CL, NSArray *_plotArr) {
        RBar = _CL;
    }];
    float d2 = [QKDef QKConstant_d2:((NSArray *)dataArr[0]).count];
    float CPL = (XBar - LCLValue) / (3 * RBar / d2);
    return CPL;
}

@end
