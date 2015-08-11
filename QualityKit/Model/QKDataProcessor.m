//
//  DataProcessor.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKDataProcessor.h"
#import "QKDataManager.h"
#import "QZXLSReader.h"
#import "TSTableViewModel.h"
#import "QKDef.h"

@implementation QKDataProcessor

+ (void)convertXLSFile:(NSString *)filePath toTableModelWithBlock:(void (^)(NSArray *, NSArray *))block {
    NSURL *xlsURL = [NSURL fileURLWithPath:[QKDataManager fullPathOfFile:filePath]];
    QZWorkbook *excelReader = [[QZWorkbook alloc] initWithContentsOfXLS:xlsURL];
    QZWorkSheet *firstWorkSheet = excelReader.workSheets.firstObject;
    [firstWorkSheet open];
    
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    
    // NSUInteger rowsNumber = firstWorkSheet.rows.count;
    NSUInteger columnsNumber = ((NSArray *)firstWorkSheet.rows[0]).count;
    for (int i = 0; i < columnsNumber; i ++) {
        NSDictionary *tmpDic = @{@"title": [NSString stringWithFormat:@"%d", i + 1],
                                 @"defWidth": @80};
        [columns addObject:[TSColumn columnWithDictionary:tmpDic]];
    }
    for (NSArray *everyRow in firstWorkSheet.rows) {
        NSMutableArray *cells = [[NSMutableArray alloc] init];
        for (QZCell *tmpCell in everyRow) {
            [cells addObject:@{@"value": [NSNumber numberWithDouble:[tmpCell.content doubleValue]]}];
        }
        [rows addObject:[TSRow rowWithDictionary:@{@"cells": cells}]];
    }
    
    block(columns, rows);
}

+ (NSArray *)convertXLSFileToDoubleArray:(NSString *)filePath {
    NSURL *xlsURL = [NSURL fileURLWithPath:[QKDataManager fullPathOfFile:filePath]];
    QZWorkbook *excelReader = [[QZWorkbook alloc] initWithContentsOfXLS:xlsURL];
    QZWorkSheet *firstWorkSheet = excelReader.workSheets.firstObject;
    [firstWorkSheet open];
    
    NSMutableArray *doubleArr = [[NSMutableArray alloc] init];
    for (NSArray *tmpRow in firstWorkSheet.rows) {
        NSMutableArray *rowArr = [[NSMutableArray alloc] init];
        for (QZCell *tmpCell in tmpRow) {
            [rowArr addObject:[NSNumber numberWithDouble:[tmpCell.content doubleValue]]];
        }
        [doubleArr addObject:rowArr];
    }
    
    return doubleArr;
}

+ (NSArray *)convertTableModelToFloatArray:(TSTableViewModel *)model {
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    
    NSArray *modelRows = model.rows;
    for (TSRow *tmpRow in modelRows) {
        NSArray *cells = tmpRow.cells;
        NSMutableArray *rowArr = [[NSMutableArray alloc] init];
        for (TSCell *tmpCell in cells) {
            [rowArr addObject:[NSNumber numberWithDouble:[[[tmpCell value] description] doubleValue]]];
        }
        [dataArr addObject:rowArr];
    }
    return dataArr;
}

+ (void)convertRealm:(NSString *)filePath dataModelClass:(NSString *)dataModelClass toTableModelWithBlock:(void (^)(NSArray *, NSArray *))block {
    
    NSString *realmPath = [QKDataManager fullPathOfFile:filePath];
    RLMRealm *realm = [RLMRealm realmWithPath:realmPath];
    
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    
    if ([dataModelClass isEqualToString:[[QKData5 class] description]]) {
        for (int i = 0; i < 5; i ++) {
            NSDictionary *tmpDic = @{@"title" : [NSString stringWithFormat:@"%d", i + 1],
                    @"defWidth" : @80};
            [columns addObject:[TSColumn columnWithDictionary:tmpDic]];
        }

        RLMResults *allQKData5 = [QKData5 allObjectsInRealm:realm];
        for (QKData5 *tmp in allQKData5) {
            TSRow *row = [TSRow rowWithDictionary:@{
                @"cells": @[
                        @{@"value": [NSNumber numberWithDouble:tmp.value1]},
                        @{@"value": [NSNumber numberWithDouble:tmp.value2]},
                        @{@"value": [NSNumber numberWithDouble:tmp.value3]},
                        @{@"value": [NSNumber numberWithDouble:tmp.value4]},
                        @{@"value": [NSNumber numberWithDouble:tmp.value5]}
                ]}];
            [rows addObject:row];
        }
        block(columns, rows);
    }
}

+ (NSArray *)convertRealmToDoubleArray:(NSString *)filePath dataModelClass:(NSString *)dataModelClass {
    NSString *realmPath = [QKDataManager fullPathOfFile:filePath];
    RLMRealm *realm = [RLMRealm realmWithPath:realmPath];
    
    NSMutableArray *doubleArray = [[NSMutableArray alloc] init];
    
    if ([dataModelClass isEqualToString:[QKData5 className]]) {
        RLMResults *allQKData5 = [QKData5 allObjectsInRealm:realm];
        for (QKData5 *tmp in allQKData5) {
            [doubleArray addObject:@[[NSNumber numberWithDouble:tmp.value1],
                                     [NSNumber numberWithDouble:tmp.value2],
                                     [NSNumber numberWithDouble:tmp.value3],
                                     [NSNumber numberWithDouble:tmp.value4],
                                     [NSNumber numberWithDouble:tmp.value5]]];
        }
    }
    
    return doubleArray;
}

@end
