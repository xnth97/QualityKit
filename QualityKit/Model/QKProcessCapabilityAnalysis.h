//
//  QKProcessCapabilityAnalysis.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKDef.h"

@interface QKProcessCapabilityAnalysis : NSObject

// 对于计量值

+ (float)CPValueOfData:(NSArray *)dataArr;
+ (float)CPUValueOfData:(NSArray *)dataArr;
+ (float)CPLValueOfData:(NSArray *)dataArr;

// 对于计件值



@end
