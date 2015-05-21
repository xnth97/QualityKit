//
//  DataManager.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface QKDataManager : NSObject

+ (void)loadLocalExcelFilesWithBlock:(void(^)(NSArray *excelFiles))block;
+ (void)loadLocalRealmDatabasesWithBlock:(void(^)(NSArray *realmDatabases))block;
+ (NSString *)fullPathOfFile:(NSString *)file;
+ (void)createLocalFile:(NSString *)fileName extension:(NSString *)extension;
+ (void)createLocalXLSFile:(NSString *)fileName columnNumber:(NSInteger)num;
+ (void)createLocalRealm:(NSString *)fileName dataModel:(RLMObject *)data finishBlock:(void(^)())block;
+ (void)saveLocalXLSFile:(NSString *)fileName withDataArray:(NSArray *)dataArr;
+ (void)removeLocalFile:(NSString *)filePath;
+ (void)addData:(RLMObject *)data ToRealm:(NSString *)realmName;
+ (void)removeData:(RLMObject *)data InRealm:(NSString *)realmName;

@end
