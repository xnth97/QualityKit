//
//  ControlChartDataAnalyzer.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlChartDataAnalyzer : NSObject

/**
 *  获取数组的统计学特征数据
 *
 *  @param dataArr  原数据数组
 *  @param rulesArr 对数据进行检测所应用的规则
 *  @param type     数据统计类型，如 C 图，XBar-R等
 *  @param block    回调 block，回调 UCL 值、LCL 值、CL 值、画图数组、出错点在画图数组中下标的数组及错误描述
 */
+ (void)getStatisticalValuesOfDoubleArray:(NSArray *)dataArr checkRulesArray:(NSArray *)rulesArr controlChartType:(NSString *)type withBlock:(void(^)(float UCLValue, float LCLValue, float CLValue, NSArray *plotArr, NSArray *indexesOfErrorPoints, NSString *errorDescription))block;

/**
 *  对数据进行计算
 *
 *  @param dataArray 原数据数组
 *  @param type      控制图类型
 *  @param block     回调 block，回调 UCL 值、LCL 值、CL 值、画图数组
 */
+ (void)calculateControlLineValuesOfData:(NSArray *)dataArray controlChartType:(NSString *)type block:(void(^)(float UCLValue, float LCLValue, float CLValue, NSArray *plotArr))block;

/**
 *  对绘图点数组进行检验
 *
 *  @param plotArray 绘图点数组
 *  @param UCL       UCL 值
 *  @param LCL       LCL 值
 *  @param CL        CL 值
 *  @param checkRule 检验规则
 *  @param block     回调 block，回调出错点在绘图数组中的坐标、出错信息
 */
+ (void)checkData:(NSArray *)plotArray UCLValue:(float)UCL LCLValue:(float)LCL CLValue:(float)CL rule:(NSString *)checkRule block:(void(^)(NSArray *indexesOfErrorPoints, NSString *errorDescription))block;

@end
