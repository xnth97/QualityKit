//
//  DataProcessor.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProcessor : NSObject

+ (void)convertXLSFile:(NSString *)filePath toTableModelWithBlock:(void(^)(NSArray *columns, NSArray *rows))block;

@end
