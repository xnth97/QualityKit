//
//  data.m
//  QualityKit
//
//  Created by Qin Yubo on 13-10-13.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "data.h"
#import <sys/sysctl.h>

static data *INSTANCE;

@implementation data

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (data *)shareInstance {
    if (!INSTANCE) {
        INSTANCE = [[data alloc]init];
    }
    return INSTANCE;
}

+ (NSString *)appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+ (NSString *)appBuild {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return appVersion;
}

+ (NSString *)osVersion {
    UIDevice *device_ = [[UIDevice alloc] init];
    /*
     NSLog(@"设备所有者的名称－－%@",device_.name);
     NSLog(@"设备的类别－－－－－%@",device_.model);
     NSLog(@"设备的的本地化版本－%@",device_.localizedModel);
     NSLog(@"设备运行的系统－－－%@",device_.systemName);
     NSLog(@"当前系统的版本－－－%@",device_.systemVersion);
     NSLog(@"设备识别码－－－－－%@",device_.identifierForVendor.UUIDString);
     */
    return device_.systemVersion;
}

@end
