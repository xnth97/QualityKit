//
//  QKStatisticalFoundation.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/21.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKDef.h"

@interface QKStatisticalFoundations : NSObject

+ (float)sumValueOfArray:(NSArray *)array;
+ (float)averageValueOfArray:(NSArray *)array;
+ (float)maximumValueOfArray:(NSArray *)array;
+ (float)minimumValueOfArray:(NSArray *)array;
+ (float)standardDeviationValueOfArray:(NSArray *)array;
+ (float)rangeValueOfArray:(NSArray *)array;

/**
 *  重排序为递增数组
 *
 *  @param array 输入数组
 *
 *  @return 返回递增数组
 */
+ (NSArray *)ascendingArray:(NSArray *)array;

/**
 *  重排序为递减数组
 *
 *  @param array 输入数组
 *
 *  @return 返回递减数组
 */
+ (NSArray *)descendingArray:(NSArray *)array;

/**
 *  Shapiro-Wilk Normality Test
 *
 *  @param array The array to be tested.
 *
 *  @return BOOL value if the data is normally distributed.
 */
+ (BOOL)shapiroWilkTest:(NSArray *)array;

@end
