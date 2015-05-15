//
//  QKData5.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/15.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Realm/Realm.h>

@interface QKData5 : RLMObject

@property double value1;
@property double value2;
@property double value3;
@property double value4;
@property double value5;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<QKData5>
RLM_ARRAY_TYPE(QKData5)
