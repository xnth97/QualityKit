//
//  QKSavedControlChart.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/26.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Realm/Realm.h>
#import "QKDef.h"

@interface QKSavedControlChart : RLMObject

@property NSString *name;
@property NSString *controlChartType;
@property float UCLValue;
@property float LCLValue;
@property float CLValue;
@property float subUCLValue;
@property float subLCLValue;
@property float subCLValue;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<QKSavedControlChart>
RLM_ARRAY_TYPE(QKSavedControlChart)
