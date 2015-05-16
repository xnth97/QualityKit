//
//  QualityKitDef.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKData5.h"

// Control Chart Type Definitions

#define QKControlChartTypeXBar @"XBar"
#define QKControlChartTypeR @"R"
#define QKControlChartTypeXBarR @"XBar-R"
#define QKControlChartTypeC @"C"
#define QKControlChartTypeXBarUsingS @"XBar_S"
#define QKControlChartTypeS @"S"
#define QKControlChartTypeXBarS @"XBar-S"
#define QKControlChartTypeX @"X"
#define QKControlChartTypeMR @"MR"
#define QKControlChartTypeXMR @"X-MR"
#define QKControlChartTypeP @"P"
#define QKControlChartTypePn @"Pn"
#define QKControlChartTypeU @"U"

// Check Rule Definitions

#define QKCheckRuleOutsideControlLine @"OutsideControlLine"
#define QKCheckRuleTwoOfThreeInAreaA @"TwoOfThreeInAreaA" 
#define QKCheckRuleFourOfFiveInAreaB @"FourOfFiveInAreaB"
#define QKCheckRuleConsecutiveSixPointsChangeInSameWay @"ConsecutiveSixPointsChangeInSameWay"
#define QKCheckRuleConsecutiveNinePointsOneSide @"ConsecutiveNinePointsOneSide"

// Check Rules In NSUserDefaults
#define QKCheckRules @"QKCheckRules"
#define QKAutoFix @"QKAutoFix"

@interface QualityKitDef : NSObject

+ (float)QKConstant_d3:(NSInteger)n;
+ (float)QKConstantD4:(NSInteger)n;
+ (float)QKConstantD3:(NSInteger)n;
+ (float)QKConstantA2:(NSInteger)n;
+ (float)QKConstantA3:(NSInteger)n;
+ (float)QKConstantB3:(NSInteger)n;
+ (float)QKConstantB4:(NSInteger)n;
+ (float)QKConstantE2:(NSInteger)n;

@end
