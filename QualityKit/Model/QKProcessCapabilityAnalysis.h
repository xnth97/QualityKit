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

+ (float)CPValueOfData:(NSArray *)dataArr USL:(float)USL LSL:(float)LSL;
+ (float)CPUValueOfData:(NSArray *)dataArr USL:(float)USL LSL:(float)LSL;
+ (float)CPLValueOfData:(NSArray *)dataArr USL:(float)USL LSL:(float)LSL;
+ (float)CPKValueOfData:(NSArray *)dataArr USL:(float)USL LSL:(float)LSL;

// 对于计件值，包括 PBar, UBar, CBar

+ (float)PiecesCapabilityValueOfData:(NSArray *)dataArr;

@end
