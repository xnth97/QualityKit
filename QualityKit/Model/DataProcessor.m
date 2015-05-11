//
//  DataProcessor.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/11.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "DataProcessor.h"
#import "DataManager.h"
#import "QZXLSReader.h"
#import "TSTableViewModel.h"

@implementation DataProcessor

+ (void)convertXLSFile:(NSString *)filePath toTableModelWithBlock:(void (^)(NSArray *, NSArray *))block {
    NSURL *xlsURL = [NSURL fileURLWithPath:[DataManager fullPathOfFile:filePath]];
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

@end
