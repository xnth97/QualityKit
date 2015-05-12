//
//  QualityKitDef.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

// Control Chart Type Definitions

#define QKControlChartTypeXBar @"TypeXBar"
#define QKControlChartTypeR @"TypeR"
#define QKControlChartTypeXBarR @"TypeXBar-R"
#define QKControlChartTypeCChart @"TypeCChart"

// Check Rule Definitions



@interface QualityKitDef : NSObject

+ (float)QKConstant_d3:(NSInteger)n;
+ (float)QKConstantD4:(NSInteger)n;
+ (float)QKConstantD3:(NSInteger)n;

@end
