//
//  QKStatisticalFoundation.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/21.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKStatisticalFoundations.h"

@implementation QKStatisticalFoundations

+ (float)sumValueOfArray:(NSArray *)array {
    float sum = 0;
    for (id tmp in array) {
        sum = sum + [tmp floatValue];
    }
    return sum;
}

+ (float)averageValueOfArray:(NSArray *)array {
    return [self sumValueOfArray:array] / array.count;
}

+ (float)maximumValueOfArray:(NSArray *)array {
    float max = [array[0] floatValue];
    for (id tmp in array) {
        if ([tmp floatValue] >= max) {
            max = [tmp floatValue];
        }
    }
    return max;
}

+ (float)minimumValueOfArray:(NSArray *)array {
    float min = [array[0] floatValue];
    for (id tmp in array) {
        if ([tmp floatValue] <= min) {
            min = [tmp floatValue];
        }
    }
    return min;
}

+ (float)standardDeviationValueOfArray:(NSArray *)array {
    float xBar = [self averageValueOfArray:array];
    
    float tmpSum = 0;
    for (id item in array) {
        tmpSum = tmpSum + ([item floatValue] - xBar) * (([item floatValue] - xBar));
    }
    float S = sqrtf(tmpSum/(array.count - 1));
    return S;
}

+ (float)rangeValueOfArray:(NSArray *)array {
    float range = [self maximumValueOfArray:array] - [self minimumValueOfArray:array];
    return range;
}

+ (NSArray *)ascendingArray:(NSArray *)array {
    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] <= [obj2 floatValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

+ (NSArray *)descendingArray:(NSArray *)array {
    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] >= [obj2 floatValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

+ (BOOL)shapiroWilkTest:(NSArray *)array {
    array = [self ascendingArray:array];
    
    float xBar = [self averageValueOfArray:array];
    float denominator = 0;
    for (id tmp in array) {
        denominator = denominator + ([tmp floatValue] - xBar) * ([tmp floatValue] - xBar);
    }
    
    float numeratorSum = 0;
    for (int i = 1; i <= array.count; i ++) {
        float a = [QKDef shapiroWilkAValue:i];
        float xi = [array[i - 1] floatValue];
        numeratorSum = numeratorSum + a * xi;
    }
    float numerator = numeratorSum * numeratorSum;
    
    float W = numerator / denominator;
    
    float significance = [[[NSUserDefaults standardUserDefaults] objectForKey:QKSignificance] floatValue];
    if (W >= [QKDef shapiroWilkWValue:array.count alpha:significance]) {
        return YES;
    } else {
        return NO;
    }
}

@end
