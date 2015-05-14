//
//  DataProcessor.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSTableViewModel.h"

@interface DataProcessor : NSObject

+ (void)convertXLSFile:(NSString *)filePath toTableModelWithBlock:(void(^)(NSArray *columns, NSArray *rows))block;

/**
 *  将 XLS 数据模型转化为便于计算的 double 数组
 *
 *  @param filePath XLS 文件路径
 *  @param block    回调 block，回调数组结构为：@[@[rowArray], @[rowArray]]
 */
+ (void)convertXLSFile:(NSString *)filePath toDoubleArrayWithBlock:(void(^)(NSArray *doubleArr))block;

+ (NSArray *)convertTableModelToFloatArray:(TSTableViewModel *)model;

@end
