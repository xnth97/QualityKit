//
//  data.h
//  QualityKit
//
//  Created by Qin Yubo on 13-10-13.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface data : NSObject



+ (data *)shareInstance;
+ (NSString *)appVersion;
+ (NSString *)appBuild;
+ (NSString *)osVersion;

@end
