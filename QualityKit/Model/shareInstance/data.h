//
//  data.h
//  QualityKit
//
//  Created by Qin Yubo on 13-10-13.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QKControlChartView.h"

@interface data : NSObject

@property (strong, nonatomic) QKControlChartView *chartView;
@property (strong, nonatomic) QKControlChartView *subChartView;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *chartTitle;
@property (strong, nonatomic) NSString *subChartTitle;

+ (data *)shareInstance;
+ (NSString *)appVersion;
+ (NSString *)appBuild;
+ (NSString *)osVersion;

@end
