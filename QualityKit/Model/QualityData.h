//
//  QualityData.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Realm/Realm.h>

@interface QualityData : RLMObject

@property double time;
@property double sample;
@property double value;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<QualityData>
RLM_ARRAY_TYPE(QualityData)
