//
//  ControlChartDataAnalyzer.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKDataAnalyzer.h"
#import "QualityKitDef.h"

@implementation QKDataAnalyzer

#pragma mark - get statistical values

+ (void)getStatisticalValuesOfDoubleArray:(NSArray *)dataArr checkRulesArray:(NSArray *)rulesArr controlChartType:(NSString *)type withBlock:(void (^)(float, float, float, NSArray *, NSArray *, NSString *))block {
    
    __block float UCLValue;
    __block float LCLValue;
    __block float CLValue;
    __block NSMutableArray *plotArr = [[NSMutableArray alloc] init];
    __block NSMutableArray *indexesOfErrorPoints = [[NSMutableArray alloc] init];
    __block NSString *errorDescription = @"";
    
    [self calculateControlLineValuesOfData:dataArr controlChartType:type block:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr) {
        UCLValue = _UCLValue;
        LCLValue = _LCLValue;
        CLValue = _CLValue;
        plotArr = [_plotArr mutableCopy];
    }];
    
    for (NSString *rule in rulesArr) {
        [self checkData:plotArr UCLValue:UCLValue LCLValue:LCLValue CLValue:CLValue rule:rule block:^(NSArray *_indexesOfErrorPoints, NSString *_errorDescription) {
            for (id tmp in _indexesOfErrorPoints) {
                if (![indexesOfErrorPoints containsObject:tmp]) {
                    [indexesOfErrorPoints addObject:tmp];
                }
            }
            errorDescription = (indexesOfErrorPoints.count == 0) ? @"" : [NSString stringWithFormat:@"%@\n%@", errorDescription, _errorDescription];
        }];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:QKAutoFix] == YES) {
        // 【重要】
        // 如果这里不判断是否为0，之后 fixData 会直接进入为0的环节，从而返回空值
        if (indexesOfErrorPoints.count > 0) {
            [self fixData:dataArr indexesOfErrorRows:indexesOfErrorPoints checkRules:rulesArr controlChartType:type block:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errorDescription) {
                UCLValue = _UCLValue;
                LCLValue = _LCLValue;
                CLValue = _CLValue;
                plotArr = [_plotArr mutableCopy];
                indexesOfErrorPoints = [_indexesOfErrorPoints mutableCopy];
                errorDescription = _errorDescription;
            }];
        }
    }
    
    block(UCLValue, LCLValue, CLValue, plotArr, indexesOfErrorPoints, errorDescription);
}

#pragma mark - calculate data

+ (void)calculateControlLineValuesOfData:(NSArray *)dataArray controlChartType:(NSString *)type block:(void (^)(float, float, float, NSArray *))block {
    
    if ([type isEqualToString:QKControlChartTypeXBar]) {
        NSMutableArray *xBarArr = [[NSMutableArray alloc] init];
        
        for (NSArray *rowArr in dataArray) {
            float xSum = 0;
            for (NSNumber *item in rowArr) {
                xSum = xSum + [item floatValue];
            }
            [xBarArr addObject:[NSNumber numberWithFloat:xSum/(rowArr.count)]];
        }
        
        float xBarSum = 0;
        for (NSNumber *xBar in xBarArr) {
            xBarSum = xBarSum + [xBar floatValue];
        }
        float CLValue = xBarSum/(xBarArr.count);
        
        __block float rBar;
        [self calculateControlLineValuesOfData:dataArray controlChartType:QKControlChartTypeR block:^(float _UCLR, float _LCLR, float _CLR, NSArray *_rArr) {
            rBar = _CLR;
        }];
        
        float A2 = [QualityKitDef QKConstantA2:xBarArr.count];
        float UCLValue = CLValue + A2 * rBar;
        float LCLValue = CLValue - A2 * rBar;
        
        block(UCLValue, LCLValue, CLValue, xBarArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeR]) {
        NSMutableArray *rArr = [[NSMutableArray alloc] init];
        for (NSArray *rowArr in dataArray) {
            float minValue = [rowArr[0] floatValue];
            float maxValue = [rowArr[0] floatValue];
            for (NSNumber *tmpNum in rowArr) {
                float tmpFloat = [tmpNum floatValue];
                if (tmpFloat >= maxValue) {
                    maxValue = tmpFloat;
                }
                if (tmpFloat <= minValue) {
                    minValue = tmpFloat;
                }
            }
            [rArr addObject:[NSNumber numberWithFloat:maxValue - minValue]];
        }
        
        float rSum = 0;
        for (NSNumber *tmpR in rArr) {
            rSum = rSum + [tmpR floatValue];
        }
        float CLValue = rSum/(rArr.count);
        
        float D4 = [QualityKitDef QKConstantD4:rArr.count];
        float UCLValue = D4 * CLValue;
        float D3 = [QualityKitDef QKConstantD3:rArr.count];
        float LCLValue = D3 * CLValue;
        
        block(UCLValue, LCLValue, CLValue, rArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeXBarUsingS]) {
        NSMutableArray *xBarArr = [[NSMutableArray alloc] init];
        
        for (NSArray *rowArr in dataArray) {
            float xSum = 0;
            for (NSNumber *item in rowArr) {
                xSum = xSum + [item floatValue];
            }
            [xBarArr addObject:[NSNumber numberWithFloat:xSum/(rowArr.count)]];
        }
        
        float xBarSum = 0;
        for (NSNumber *xBar in xBarArr) {
            xBarSum = xBarSum + [xBar floatValue];
        }
        float CLValue = xBarSum / xBarArr.count;
        
        __block float sBar = 0;
        [self calculateControlLineValuesOfData:dataArray controlChartType:QKControlChartTypeS block:^(float _UCL, float _LCL, float _CL, NSArray *_sArr) {
            sBar = _CL;
        }];
        
        float A3 = [QualityKitDef QKConstantA3:xBarArr.count];
        float UCLValue = CLValue + A3 * sBar;
        float LCLValue = CLValue - A3 * sBar;
        
        block(UCLValue, LCLValue, CLValue, xBarArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeS]) {
        NSMutableArray *sArr = [[NSMutableArray alloc] init];
        
        for (NSArray *rowArr in dataArray) {
            float xSum = 0;
            for (NSNumber *item in rowArr) {
                xSum = xSum + [item floatValue];
            }
            float xBar = xSum/dataArray.count;
            
            float tmpSum = 0;
            for (NSNumber *item in rowArr) {
                tmpSum = tmpSum + ([item floatValue] - xBar) * (([item floatValue] - xBar));
            }
            float S = sqrtf(tmpSum/(rowArr.count - 1));
            [sArr addObject:[NSNumber numberWithFloat:S]];
        }
        
        float sSum = 0;
        for (NSNumber *tmpS in sArr) {
            sSum = sSum + [tmpS floatValue];
        }
        float sBar = sSum / sArr.count;
        
        float B3 = [QualityKitDef QKConstantB3:sArr.count];
        float B4 = [QualityKitDef QKConstantB4:sArr.count];
        
        float UCLValue = B4 * sBar;
        float LCLValue = B3 * sBar;
        
        block(UCLValue, LCLValue, sBar, sArr);
    }
}

#pragma mark - check data

+ (void)checkData:(NSArray *)plotArray UCLValue:(float)UCL LCLValue:(float)LCL CLValue:(float)CL rule:(NSString *)checkRule block:(void (^)(NSArray *, NSString *))block {
    
    if ([checkRule isEqualToString:QKCheckRuleOutsideControlLine]) {
        NSMutableArray *indexesOfErrorPoints = [[NSMutableArray alloc] init];
        for (int i = 0; i < plotArray.count; i ++) {
            float tmpFloat = [plotArray[i] floatValue];
            if (tmpFloat > UCL || tmpFloat < LCL) {
                [indexesOfErrorPoints addObject:[NSNumber numberWithInt:i]];
            }
        }
        
        NSString *errorDescription = @"";
        if (indexesOfErrorPoints.count > 0) {
            errorDescription = @"点";
            for (int j = 0; j < indexesOfErrorPoints.count; j ++) {
                if (j == 0) {
                    errorDescription = [NSString stringWithFormat:@"%@%ld", errorDescription, (long)[indexesOfErrorPoints[j] integerValue] + 1];
                } else {
                    errorDescription = [NSString stringWithFormat:@"%@, %ld", errorDescription, (long)[indexesOfErrorPoints[j] integerValue] + 1];
                }
            }
            errorDescription = [NSString stringWithFormat:@"%@在控制线外部。可能原因：测量误差、设备出错等。", errorDescription];
        }
        
        block(indexesOfErrorPoints, errorDescription);
    }
    
    if ([checkRule isEqualToString:QKCheckRuleTwoOfThreeInAreaA]) {
        float unitArea = (UCL - LCL) / 6;
        // 下 A 区上限
        float lowerAreaAUpperLimit = LCL + unitArea;
        // 上 A 区下限
        float upperAreaALowerLimit = UCL - unitArea;
        
        NSMutableArray *indexesOfErrorPoints = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < plotArray.count - 2; i ++) {
            float inAreaAPointsNum = 0;
            NSMutableArray *indexesOfCheckedPossibleErrorPoints = [[NSMutableArray alloc] init];
            for (int j = i; j <= i + 2; j ++) {
                float pointValue = [plotArray[j] floatValue];
                if ((pointValue >= LCL && pointValue <= lowerAreaAUpperLimit) || (pointValue >= upperAreaALowerLimit && pointValue <= UCL)) {
                    [indexesOfCheckedPossibleErrorPoints addObject:[NSNumber numberWithInteger:j]];
                    inAreaAPointsNum ++;
                }
            }
            if (inAreaAPointsNum >= 2) {
                for (id tmp in indexesOfCheckedPossibleErrorPoints) {
                    if (![indexesOfErrorPoints containsObject:tmp]) {
                        [indexesOfErrorPoints addObject:tmp];
                    }
                }
            }
        }
        
        NSString *errorDescription = @"";
        if (indexesOfErrorPoints.count > 0) {
            errorDescription = @"点";
            for (int j = 0; j < indexesOfErrorPoints.count; j ++) {
                if (j == 0) {
                    errorDescription = [NSString stringWithFormat:@"%@%ld", errorDescription, (long)[indexesOfErrorPoints[j] integerValue] + 1];
                } else {
                    errorDescription = [NSString stringWithFormat:@"%@, %ld", errorDescription, (long)[indexesOfErrorPoints[j] integerValue] + 1];
                }
            }
            errorDescription = [NSString stringWithFormat:@"%@在连续三个点中有两点位于 A 区。可能原因：设备不稳定、操作有误、设备调整等。", errorDescription];
        }
        
        block(indexesOfErrorPoints, errorDescription);
        
    }
}

#pragma mark - fix data

+ (void)fixData:(NSArray *)dataArr indexesOfErrorRows:(NSArray *)indexesOfErrorRows checkRules:(NSArray *)rulesArr controlChartType:(NSString *)type block:(void (^)(float, float, float, NSArray *, NSArray *, NSString *))block {
    
    __block BOOL flag = YES;
    __block float UCLValue = 0;
    __block float LCLValue = 0;
    __block float CLValue = 0;
    __block NSMutableArray *plotArr = [[NSMutableArray alloc] init];
    __block NSMutableArray *indexesOfErrorPoints = [indexesOfErrorRows mutableCopy];
    __block NSString *errorDescription = @"";
    
    while (flag) {
        
        if (indexesOfErrorPoints.count == 0) {
            // 没有错误点
            // 此处直接返回执行修正后的 block
            // 因此如果初始错误点数组长度为 0 会直接返回空
            
            flag = NO;
            break;
            
        } else if (indexesOfErrorPoints.count <= 3) {
            // 小于等于三执行修正
            NSMutableArray *_dataArr = [dataArr mutableCopy];
            
            // 按照下标去除 indexes 数组中的下标对应在 dataArr 中数据时，需要每删除一个数据，就把 indexes 数组中所有下标减一
            NSMutableArray *indexesOfPointsToBeRemoved = [indexesOfErrorPoints mutableCopy];
            for (int i = 0; i < indexesOfErrorPoints.count; i ++) {
                [_dataArr removeObjectAtIndex:[indexesOfPointsToBeRemoved[i] integerValue]];
                for (int j = 0; j < indexesOfPointsToBeRemoved.count; j ++) {
                    indexesOfPointsToBeRemoved[j] = [NSNumber numberWithInteger:[indexesOfPointsToBeRemoved[j] integerValue] - 1];
                }
            }
            
            [plotArr removeAllObjects];
            [indexesOfErrorPoints removeAllObjects];
            errorDescription = @"";
            
            [self calculateControlLineValuesOfData:_dataArr controlChartType:type block:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr) {
                UCLValue = _UCLValue;
                LCLValue = _LCLValue;
                CLValue = _CLValue;
                plotArr = [_plotArr mutableCopy];
            }];
            
            for (NSString *rule in rulesArr) {
                [self checkData:plotArr UCLValue:UCLValue LCLValue:LCLValue CLValue:CLValue rule:rule block:^(NSArray *_indexesOfErrorPoints, NSString *_errorDescription) {
                    for (id tmp in _indexesOfErrorPoints) {
                        if (![indexesOfErrorPoints containsObject:tmp]) {
                            [indexesOfErrorPoints addObject:tmp];
                        }
                    }
                    errorDescription = (indexesOfErrorPoints.count == 0) ? @"" : [NSString stringWithFormat:@"%@\n%@", errorDescription, _errorDescription];
                }];
            }
            
            continue;
            
        } else {
            // 大于三直接返回
            errorDescription = [NSString stringWithFormat:@"%@\n错误点个数大于3，无法修正", errorDescription];
            
            flag = NO;
            break;
        }
    }
    
    block(UCLValue, LCLValue, CLValue, plotArr, indexesOfErrorPoints, errorDescription);
}

@end