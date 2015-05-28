//
//  ControlChartDataAnalyzer.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKDataAnalyzer : NSObject

/**
 *  获取数组的统计学特征数据
 *
 *  @param dataArr  原数据数组
 *  @param rulesArr 对数据进行检测所应用的规则
 *  @param type     数据统计类型，如 C 图，XBar-R等
 *  @param block    回调 block，回调 UCL 值、LCL 值、CL 值、画图数组、出错点在画图数组中下标的数组及错误描述
 */
+ (void)getStatisticalValuesOfDoubleArray:(NSArray *)dataArr checkRulesArray:(NSArray *)rulesArr controlChartType:(NSString *)type withBlock:(void(^)(id UCLValue, id LCLValue, float CLValue, NSArray *plotArr, NSArray *indexesOfErrorPoints, NSString *errorDescription))block;

/**
 *  对数据进行计算
 *
 *  @param dataArray 原数据数组
 *  @param type      控制图类型
 *  @param block     回调 block，回调 UCL 值、LCL 值、CL 值、画图数组
 */
+ (void)calculateControlLineValuesOfData:(NSArray *)dataArray controlChartType:(NSString *)type block:(void(^)(id UCLValue, id LCLValue, float CLValue, NSArray *plotArr))block;

/**
 *  对绘图点数组进行检验
 *
 *  @param plotArray 绘图点数组
 *  @param UCL       UCL 值
 *  @param LCL       LCL 值
 *  @param CL        CL 值
 *  @param checkRule 检验规则，定义在 QKDef 里
 *  @param block     回调 block，回调出错点在绘图数组中的坐标、出错信息
 */
+ (void)checkData:(NSArray *)plotArray UCLValue:(id)UCL LCLValue:(id)LCL CLValue:(float)CL rule:(NSString *)checkRule block:(void(^)(NSArray *indexesOfErrorPoints, NSString *errorDescription))block;

/**
 *  对出错点进行修正。初始出错点数组个数不能为 0
 *
 *  @param dataArr            原始数据
 *  @param indexesOfErrorRows 出错点个数，即原始数据出错行数
 *  @param rulesArr           应用检测规则，定义在 QualityKitDef 里
 *  @param type               控制图类型
 *  @param block              回调 block，回调 UCL 值、LCL 值、CL 值、画图数组、出错点在画图数组中下标的数组及错误描述
 */
+ (void)fixData:(NSArray *)dataArr indexesOfErrorRows:(NSArray *)indexesOfErrorRows checkRules:(NSArray *)rulesArr controlChartType:(NSString *)type block:(void(^)(id UCLValue, id LCLValue, float CLValue, NSArray *plotArr, NSArray *indexesOfErrorPoints, NSString *errorDescription))block;

+ (void)getStatisticalValuesUsingSavedControlChartFromData:(NSArray *)dataArr UCL:(id)UCLValue LCL:(id)LCLValue CL:(float)CLValue checkRulesArray:(NSArray *)rulesArr controlChartType:(NSString *)type withBlock:(void(^)(NSArray *plotArr, NSArray *indexesOfErrorPoints, NSString *errorDescription))block;

@end
