//
//  ControlChartDataAnalyzer.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKDataAnalyzer.h"
#import "QKDef.h"
#import "QKStatisticalFoundations.h"

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
            errorDescription = (indexesOfErrorPoints.count == 0) ? @"" : [NSString stringWithFormat:@"%@%@", errorDescription, _errorDescription];
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
            [xBarArr addObject:[NSNumber numberWithFloat:[QKStatisticalFoundations averageValueOfArray:rowArr]]];
        }
        
        float CLValue = [QKStatisticalFoundations averageValueOfArray:xBarArr];
        
        __block float rBar;
        [self calculateControlLineValuesOfData:dataArray controlChartType:QKControlChartTypeR block:^(float _UCLR, float _LCLR, float _CLR, NSArray *_rArr) {
            rBar = _CLR;
        }];
        
        float A2 = [QKDef QKConstantA2:xBarArr.count];
        float UCLValue = CLValue + A2 * rBar;
        float LCLValue = CLValue - A2 * rBar;
        
        block(UCLValue, LCLValue, CLValue, xBarArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeR]) {
        NSMutableArray *rArr = [[NSMutableArray alloc] init];
        for (NSArray *rowArr in dataArray) {
            [rArr addObject:[NSNumber numberWithFloat:[QKStatisticalFoundations rangeValueOfArray:rowArr]]];
        }
        
        float CLValue = [QKStatisticalFoundations averageValueOfArray:rArr];
        
        float D4 = [QKDef QKConstantD4:rArr.count];
        float UCLValue = D4 * CLValue;
        float D3 = [QKDef QKConstantD3:rArr.count];
        float LCLValue = D3 * CLValue;
        
        block(UCLValue, LCLValue, CLValue, rArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeXBarUsingS]) {
        NSMutableArray *xBarArr = [[NSMutableArray alloc] init];
        
        for (NSArray *rowArr in dataArray) {
            [xBarArr addObject:[NSNumber numberWithFloat:[QKStatisticalFoundations averageValueOfArray:rowArr]]];
        }
        
        float CLValue = [QKStatisticalFoundations averageValueOfArray:xBarArr];
        
        __block float sBar = 0;
        [self calculateControlLineValuesOfData:dataArray controlChartType:QKControlChartTypeS block:^(float _UCL, float _LCL, float _CL, NSArray *_sArr) {
            sBar = _CL;
        }];
        
        float A3 = [QKDef QKConstantA3:xBarArr.count];
        float UCLValue = CLValue + A3 * sBar;
        float LCLValue = CLValue - A3 * sBar;
        
        block(UCLValue, LCLValue, CLValue, xBarArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeS]) {
        NSMutableArray *sArr = [[NSMutableArray alloc] init];
        
        for (NSArray *rowArr in dataArray) {
            [sArr addObject:[NSNumber numberWithFloat:[QKStatisticalFoundations standardDeviationValueOfArray:rowArr]]];
        }
        
        float sBar = [QKStatisticalFoundations averageValueOfArray:sArr];
        
        float B3 = [QKDef QKConstantB3:sArr.count];
        float B4 = [QKDef QKConstantB4:sArr.count];
        
        float UCLValue = B4 * sBar;
        float LCLValue = B3 * sBar;
        
        block(UCLValue, LCLValue, sBar, sArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeX]) {
        NSMutableArray *xArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArray.count; i ++) {
            double xValue = [(dataArray[i])[0] doubleValue];
            [xArr addObject:[NSNumber numberWithDouble:xValue]];
        }
        
        float CLValue = [QKStatisticalFoundations averageValueOfArray:xArr];
        
        __block float rBar = 0;
        [self calculateControlLineValuesOfData:dataArray controlChartType:QKControlChartTypeMR block:^(float _UCL, float _LCL, float _CLR, NSArray *_rArr) {
            rBar = _CLR;
        }];
        float UCLValue = CLValue + [QKDef QKConstantE2:xArr.count] * rBar;
        float LCLValue = CLValue - [QKDef QKConstantE2:xArr.count] * rBar;
        
        block(UCLValue, LCLValue, CLValue, xArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeMR]) {
        NSMutableArray *rArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArray.count - 1; i ++) {
            double xi = [(dataArray[i])[0] doubleValue];
            double xi1 = [(dataArray[i + 1])[0] doubleValue];
            double RValue = fabs(xi - xi1);
            [rArr addObject:[NSNumber numberWithDouble:RValue]];
        }
        
        float rSum = 0;
        for (NSNumber *tmpR in rArr) {
            rSum = rSum + [tmpR floatValue];
        }
        float CLValue = rSum / rArr.count;
        
        float UCLValue = [QKDef QKConstantD4:rArr.count] * CLValue;
        float LCLValue = [QKDef QKConstantD3:rArr.count] * CLValue;
        
        block(UCLValue, LCLValue, CLValue, rArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeP]) {
        NSMutableArray *pArr = [[NSMutableArray alloc] init];
        
        float nSum = 0;
        float pniSum = 0;
        
        for (int i = 0; i < dataArray.count; i ++) {
            NSArray *tmp = dataArray[i];
            float ni = [tmp[0] floatValue];
            float pni = [tmp[1] floatValue];
            float pi = pni / ni;
            [pArr addObject:[NSNumber numberWithFloat:pi]];
            nSum = nSum + ni;
            pniSum = pniSum + pni;
        }
        
        float CLValue = pniSum / nSum;
        
        float UCLValue = CLValue + 3 * sqrt(CLValue * (1 - CLValue)) / sqrt(nSum / dataArray.count);
        float LCLValue = CLValue - 3 * sqrt(CLValue * (1 - CLValue)) / sqrt(nSum / dataArray.count);
        
        block(UCLValue, LCLValue, CLValue, pArr);
    }
    
    if ([type isEqualToString:QKControlChartTypePn]) {
        NSMutableArray *pArr = [[NSMutableArray alloc] init];
        
        float pSum = 0;
        
        for (NSArray *tmpP in dataArray) {
            pSum = pSum + [tmpP[1] floatValue];
            [pArr addObject:tmpP[1]];
        }
        float pBar = pSum / (dataArray.count * [(dataArray[0])[0] integerValue]);
        float CLValue = pSum / dataArray.count;
        
        float UCLValue = CLValue + 3 * sqrt(CLValue * (1 - pBar));
        float LCLValue = CLValue - 3 * sqrt(CLValue * (1 - pBar));
        
        block(UCLValue, LCLValue, CLValue, pArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeC]) {
        NSMutableArray *cArr = [[NSMutableArray alloc] init];
        
        float cSum = 0;
        
        for (NSArray *tmpC in dataArray) {
            cSum = cSum + [tmpC[1] floatValue];
            [cArr addObject:tmpC[1]];
        }
        float CLValue = cSum / dataArray.count;
        float UCLValue = CLValue + 3 * sqrt(CLValue);
        float LCLValue = CLValue - 3 * sqrt(CLValue);
        
        block(UCLValue, LCLValue, CLValue, cArr);
    }
    
    if ([type isEqualToString:QKControlChartTypeU]) {
        NSMutableArray *uArr = [[NSMutableArray alloc] init];
        
        float uSum = 0;
        float nSum = 0;
        for (NSArray *tmp in dataArray) {
            float U = [tmp[1] floatValue] / [tmp[0] floatValue];
            uSum = uSum + U;
            nSum = nSum + [tmp[0] floatValue];
            [uArr addObject:[NSNumber numberWithFloat:U]];
        }
        float CLValue = uSum / dataArray.count;
        
        float UCLValue = CLValue + 3 * sqrt(CLValue) / sqrt(nSum / dataArray.count);
        float LCLValue = CLValue - 3 * sqrt(CLValue) / sqrt(nSum / dataArray.count);
        
        block(UCLValue, LCLValue, CLValue, uArr);
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
            errorDescription = [NSString stringWithFormat:@"%@在控制线外部。可能原因：测量误差、设备出错等。\n", errorDescription];
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
            errorDescription = [NSString stringWithFormat:@"%@在连续三个点中有两点位于 A 区。可能原因：设备不稳定、操作有误、设备调整等。\n", errorDescription];
        }
        
        block(indexesOfErrorPoints, errorDescription);
        
    }
    
    if ([checkRule isEqualToString:QKCheckRuleFourOfFiveInAreaB]) {
        
        if (plotArray.count >= 5) {
            float unitArea = (UCL - LCL) / 6;
            // 下 B 区下限
            float lowerAreaBLowerLimit = LCL + unitArea;
            // 下 B 区上限
            float lowerAreaBUpperLimit = LCL + 2 * unitArea;
            // 上 B 区下限
            float upperAreaBLowerLimit = UCL - 2 * unitArea;
            // 上 B 区上限
            float upperAreaBUpperLimit = UCL - unitArea;
            
            NSMutableArray *indexesOfErrorPoints = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < plotArray.count - 4; i ++) {
                float inAreaAPointsNum = 0;
                NSMutableArray *indexesOfCheckedPossibleErrorPoints = [[NSMutableArray alloc] init];
                for (int j = i; j <= i + 4; j ++) {
                    float pointValue = [plotArray[j] floatValue];
                    if ((pointValue >= lowerAreaBLowerLimit && pointValue <= lowerAreaBUpperLimit) || (pointValue >= upperAreaBLowerLimit && pointValue <= upperAreaBUpperLimit)) {
                        [indexesOfCheckedPossibleErrorPoints addObject:[NSNumber numberWithInteger:j]];
                        inAreaAPointsNum ++;
                    }
                }
                if (inAreaAPointsNum >= 4) {
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
                errorDescription = [NSString stringWithFormat:@"%@在连续五个点中有四点位于 B 区。可能原因：过程偏倚、量具需要调整、设备不稳定等。\n", errorDescription];
            }
            
            block(indexesOfErrorPoints, errorDescription);
            
        } else {
            block(@[], @"");
        }
        
    }
    
    if ([checkRule isEqualToString:QKCheckRuleConsecutiveSixPointsChangeInSameWay]) {
        
        if (plotArray.count >= 6) {
            NSMutableArray *indexesOfErrorPoints = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < plotArray.count - 5; i ++) {
                
                BOOL trendChanged = NO;
                BOOL increasingFlag = YES;
                
                for (int j = i + 1; j < i + 6; j ++) {
                    float diff = [plotArray[j] floatValue] - [plotArray[j - 1] floatValue];
                    if (j == i) {
                        if (diff >= 0) {
                            increasingFlag = YES;
                        } else {
                            increasingFlag = NO;
                        }
                    } else {
                        if ((diff > 0 && increasingFlag == NO) || (diff < 0 && increasingFlag == YES)) {
                            trendChanged = YES;
                            break;
                        } else {
                            trendChanged = NO;
                            if (diff >= 0) {
                                increasingFlag = YES;
                            } else {
                                increasingFlag = NO;
                            }
                            continue;
                        }
                    }
                }
                
                if (trendChanged == YES) {
                    continue;
                } else {
                    NSArray *possibleErrorPoints = @[[NSNumber numberWithInt:i],
                                                     [NSNumber numberWithInt:i + 1],
                                                     [NSNumber numberWithInt:i + 2],
                                                     [NSNumber numberWithInt:i + 3],
                                                     [NSNumber numberWithInt:i + 4],
                                                     [NSNumber numberWithInt:i + 5]];
                    for (NSNumber *index in possibleErrorPoints) {
                        if (![indexesOfErrorPoints containsObject:index]) {
                            [indexesOfErrorPoints addObject:index];
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
                errorDescription = [NSString stringWithFormat:@"%@连续六个点稳定上升或下降。可能原因：设备逐渐损坏、操作者的疲劳、工具的磨损等。\n", errorDescription];
            }
            
            block(indexesOfErrorPoints, errorDescription);
            
        } else {
            block(@[], @"");
        }
        
    }
    
    if ([checkRule isEqualToString:QKCheckRuleConsecutiveSixPointsChangeInSameWay]) {
        if (plotArray.count >= 9) {
            NSMutableArray *indexesOfErrorPoints = [[NSMutableArray alloc] init];
            for (int i = 0; i < plotArray.count - 8; i ++) {
                float plot0 = [plotArray[0] floatValue];
                BOOL point0GreaterThanCL = (plot0 >= CL) ? YES : NO;
                for (int j = i; j < i + 9; j ++) {
                    BOOL thisPointGreaterThanCL = ([plotArray[j] floatValue] >= CL) ? YES : NO;
                    if (thisPointGreaterThanCL == point0GreaterThanCL) {
                        if (j == i + 8) {
                            NSArray *possibleErrorPoints = @[[NSNumber numberWithInt:i],
                                                             [NSNumber numberWithInt:i + 1],
                                                             [NSNumber numberWithInt:i + 2],
                                                             [NSNumber numberWithInt:i + 3],
                                                             [NSNumber numberWithInt:i + 4],
                                                             [NSNumber numberWithInt:i + 5],
                                                             [NSNumber numberWithInt:i + 6],
                                                             [NSNumber numberWithInt:i + 7],
                                                             [NSNumber numberWithInt:i + 8]];
                            for (NSNumber *index in possibleErrorPoints) {
                                if (![indexesOfErrorPoints containsObject:index]) {
                                    [indexesOfErrorPoints addObject:index];
                                }
                            }
                        }
                        continue;
                    } else {
                        break;
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
                errorDescription = [NSString stringWithFormat:@"%@连续九个点在中心线一侧。可能原因：不变的量具、旧的钢模、漂移等。\n", errorDescription];
            }
        } else {
            block(@[], @"");
        }
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
            block(UCLValue, LCLValue, CLValue, plotArr, indexesOfErrorPoints, errorDescription);
            break;
            
        } else if (indexesOfErrorPoints.count <= 3 && indexesOfErrorPoints.count > 0) {
            // 小于等于三执行修正
            NSMutableArray *_dataArr = [dataArr mutableCopy];
            
            // 需要把 indexesOfErrorPoints 排序一下
            indexesOfErrorPoints = [[QKStatisticalFoundations ascendingArray:indexesOfErrorPoints] mutableCopy];
            
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
                    errorDescription = (indexesOfErrorPoints.count == 0) ? @"" : [NSString stringWithFormat:@"%@%@", errorDescription, _errorDescription];
                }];
            }
            
            
        } else {
            // 大于三直接返回
            errorDescription = [NSString stringWithFormat:@"%@错误点个数大于3，无法修正。\n", errorDescription];
            
            [self calculateControlLineValuesOfData:dataArr controlChartType:type block:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr) {
                UCLValue = _UCLValue;
                LCLValue = _LCLValue;
                CLValue = _CLValue;
                plotArr = [_plotArr mutableCopy];
            }];
            
            flag = NO;
            block(UCLValue, LCLValue, CLValue, plotArr, indexesOfErrorPoints, errorDescription);
            break;
        }
    }
}


@end
