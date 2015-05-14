//
//  DataManager.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "DataManager.h"
#import "RSworkBook.h"
#import <Realm/Realm.h>

@implementation DataManager

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
}

+ (void)createLocalFile:(NSString *)fileName extension:(NSString *)extension {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if ([extension isEqualToString:@"xls"]) {
        RSworkBook *workBook = [[RSworkBook alloc] init];
        workBook.author = @"Qin Yubo";
        workBook.version = 1.0;
        RSworkSheet *workSheet = [[RSworkSheet alloc] init];
        RSworkSheetRow *row = [[RSworkSheetRow alloc] initWithHeight:20];
        [row addCellNumber:0];
        [workSheet addWorkSheetRow:row];
        [workBook addWorkSheet:workSheet];
        [workBook writeWithName:fileName toPath:path];
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [path stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:extension]];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
}

@end
