//
//  DataProcessor.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSTableViewModel.h"
#import <Realm/Realm.h>

@interface DataProcessor : NSObject

+ (void)convertXLSFile:(NSString *)filePath toTableModelWithBlock:(void(^)(NSArray *columns, NSArray *rows))block;

/**
 *  将 XLS 数据模型转化为便于计算的 double 数组，数组结构为：@[@[rowArray], @[rowArray]]
 *
 *  @param filePath XLS 文件路径
 */
+ (NSArray *)convertXLSFileToDoubleArray:(NSString *)filePath;

+ (NSArray *)convertTableModelToFloatArray:(TSTableViewModel *)model;

+ (void)convertRealm:(NSString *)filePath dataModelClass:(NSString *)dataModelClass toTableModelWithBlock:(void(^)(NSArray *columns, NSArray *rows))block;

+ (NSArray *)convertRealmToDoubleArray:(NSString *)filePath dataModelClass:(NSString *)dataModelClass;

@end
