//
//  QKData5.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/15.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Realm/Realm.h>

@interface QKData5 : RLMObject

@property float value1;
@property float value2;
@property float value3;
@property float value4;
@property float value5;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<QKData5>
RLM_ARRAY_TYPE(QKData5)
