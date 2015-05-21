//
//  DataManager.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKDataManager.h"
#import <Realm/Realm.h>
#import <JXLS/JXLS.h>

@implementation QKDataManager

+ (void)loadLocalExcelFilesWithBlock:(void (^)(NSArray *))block {
    NSMutableArray *excelArr = [[NSMutableArray alloc] init];
    for (NSString *tmpFile in [self allFilesInDocumentDirectory]) {
        NSString *extStr = [tmpFile pathExtension];
        if ([extStr isEqualToString:@"xls"]) {
            [excelArr addObject:tmpFile];
        }
    }
    block(excelArr);
}

+ (void)loadLocalRealmDatabasesWithBlock:(void (^)(NSArray *))block {
    NSMutableArray *realmArr = [[NSMutableArray alloc] init];
    for (NSString *tmpFile in [self allFilesInDocumentDirectory]) {
        NSString *extStr = [tmpFile pathExtension];
        if ([extStr isEqualToString:@"realm"]) {
            [realmArr addObject:tmpFile];
        }
    }
    block(realmArr);
}

+ (NSArray *)allFilesInDocumentDirectory {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@", path);
    NSArray *fileArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    return fileArr;
}

+ (NSString *)fullPathOfFile:(NSString *)file {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:file];
}

+ (void)removeLocalFile:(NSString *)filePath {
    NSString *path = [self fullPathOfFile:filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    
    if ([[filePath pathExtension] isEqualToString:@"realm"]) {
        NSArray *allFiles = [self allFilesInDocumentDirectory];
        for (NSString *tmpPath in allFiles) {
            if ([tmpPath hasPrefix:filePath]) {
                [fileManager removeItemAtPath:tmpPath error:nil];
            }
        }
    }
}

+ (void)createLocalFile:(NSString *)fileName extension:(NSString *)extension {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:extension]];
    if ([extension isEqualToString:@"xls"]) {
        
        JXLSCell *cell;
        JXLSWorkBook *workBook = [JXLSWorkBook new];
        JXLSWorkSheet *workSheet = [workBook workSheetWithName:@"SHEET1"];
        
        [workSheet setWidth:2500 forColumn:0 defaultFormat:NULL];
        
        for(uint32_t idx = 0; idx < 1; idx ++) {
            cell = [workSheet setCellAtRow:idx column:0 toDoubleValue:0];
        }
        
        [workBook writeToFile:filePath];
        
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
}

+ (void)createLocalXLSFile:(NSString *)fileName columnNumber:(NSInteger)num {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    JXLSCell *cell;
    JXLSWorkBook *workBook = [JXLSWorkBook new];
    JXLSWorkSheet *workSheet = [workBook workSheetWithName:@"SHEET1"];
    
    for(uint32_t idx = 0; idx < num; idx ++) {
        [workSheet setWidth:2500 forColumn:idx defaultFormat:NULL];
        cell = [workSheet setCellAtRow:0 column:idx toDoubleValue:0];
    }
    
    [workBook writeToFile:filePath];
}

+ (void)saveLocalXLSFile:(NSString *)fileName withDataArray:(NSArray *)dataArr {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    JXLSCell *cell;
    JXLSWorkBook *workBook = [JXLSWorkBook new];
    JXLSWorkSheet *workSheet = [workBook workSheetWithName:@"SHEET1"];
    
    for (uint32_t i = 0; i < dataArr.count; i ++) {
        NSArray *rowArr = dataArr[i];
        for (uint32_t j = 0; j < rowArr.count; j ++) {
            if (i == 0) {
                [workSheet setWidth:2500 forColumn:j defaultFormat:NULL];
            }
            cell = [workSheet setCellAtRow:i column:j toDoubleValue:[rowArr[j] doubleValue]];
        }
    }
    
    [workBook writeToFile:filePath];
}

+ (void)createLocalRealm:(NSString *)fileName dataModel:(RLMObject *)data finishBlock:(void (^)())block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        RLMRealm *realm = [RLMRealm realmWithPath:[self fullPathOfFile:[fileName stringByAppendingPathExtension:@"realm"]]];
        [realm beginWriteTransaction];
        [realm addObject:data];
        [realm commitWriteTransaction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
        
    });
}

+ (void)addData:(RLMObject *)data ToRealm:(NSString *)realmName {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        RLMRealm *realm = [RLMRealm realmWithPath:[self fullPathOfFile:realmName]];
        [realm beginWriteTransaction];
        [realm addObject:data];
        [realm commitWriteTransaction];
    });
}

+ (void)removeData:(RLMObject *)data InRealm:(NSString *)realmName {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        RLMRealm *realm = [RLMRealm realmWithPath:[self fullPathOfFile:realmName]];
        [realm beginWriteTransaction];
        [realm deleteObject:data];
        [realm commitWriteTransaction];
    });
}

@end
