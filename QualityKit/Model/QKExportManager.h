//
//  ExportManager.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/21.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "data.h"

@interface QKExportManager : NSObject

+ (UIImage *)imageFromView:(UIView *)view;
+ (void)createPDFReportWithFileName:(NSString *)name successBlock:(void(^)())success;

@end
