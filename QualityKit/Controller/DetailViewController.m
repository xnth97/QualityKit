//
//  DetailViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/10.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "DetailViewController.h"
#import "ALActionBlocks.h"
#import "DataManager.h"
#import "DataProcessor.h"
#import "TSTableViewModel.h"
#import "ControlChartViewController.h"
#import "RulesTableViewController.h"
#import "QualityKitDef.h"

@interface DetailViewController () {
    TSTableViewModel *tableModel;
}

@end

@implementation DetailViewController

@synthesize dataTableView;
@synthesize detailItem;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        detailItem = newDetailItem;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataTableView.hidden = YES;
    self.title = detailItem;
    dataTableView.delegate = self;
    
    if (detailItem) {
        UIBarButtonItem *checkRules = [[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStylePlain block:^(id weakSender) {
            [self chooseCheckRules];
        }];
        UIBarButtonItem *controlSheetStyles = [[UIBarButtonItem alloc] initWithTitle:@"控制图" style:UIBarButtonItemStylePlain block:^(id weakSender) {
            [self chooseControlSheetStyle];
        }];
        self.navigationItem.rightBarButtonItems = @[controlSheetStyles, checkRules];
        
        dataTableView.hidden = NO;
        
        [self updateData];
    }
}

- (void)updateData {
    if ([[detailItem pathExtension] isEqualToString:@"xls"]) {
        [DataProcessor convertXLSFile:detailItem toTableModelWithBlock:^(NSArray *columns, NSArray *rows) {
            tableModel = [[TSTableViewModel alloc] initWithTableView:dataTableView andStyle:kTSTableViewStyleLight];
            [tableModel setColumns:columns andRows:rows];
            [dataTableView resetColumnSelectionWithAnimtaion:YES];
            [dataTableView resetRowSelectionWithAnimtaion:YES];
        }];
    }
}

- (void)chooseControlSheetStyle {
    UIAlertController *styleController = [UIAlertController alertControllerWithTitle:@"选择控制图类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *xBarR = [UIAlertAction actionWithTitle:@"XBar-R" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ControlChartViewController *chart = [[ControlChartViewController alloc] init];
        [self.navigationController pushViewController:chart animated:YES];
        chart.chartType = QKControlChartTypeXBarR;
        if ([[detailItem pathExtension] isEqualToString:@"xls"]) {
            [DataProcessor convertXLSFile:detailItem toDoubleArrayWithBlock:^(NSArray *_dataArr) {
                chart.dataArr = _dataArr;
            }];
        }
        
    }];
    UIAlertAction *xBarS = [UIAlertAction actionWithTitle:@"XBar-S" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ControlChartViewController *chart = [[ControlChartViewController alloc] init];
        [self.navigationController pushViewController:chart animated:YES];
        chart.chartType = QKControlChartTypeXBarS;
        if ([[detailItem pathExtension] isEqualToString:@"xls"]) {
            [DataProcessor convertXLSFile:detailItem toDoubleArrayWithBlock:^(NSArray *_dataArr) {
                chart.dataArr = _dataArr;
            }];
        }
        
    }];
    [styleController addAction:xBarR];
    [styleController addAction:xBarS];
    styleController.modalPresentationStyle = UIModalPresentationPopover;
    styleController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    styleController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems[0];
    [self presentViewController:styleController animated:YES completion:nil];
}

- (void)chooseCheckRules {
    RulesTableViewController *rulesTableViewController = [[RulesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *rulesTableController = [[UINavigationController alloc] initWithRootViewController:rulesTableViewController];
    rulesTableController.modalPresentationStyle = UIModalPresentationPopover;
    rulesTableController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    rulesTableController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems[1];
    [self presentViewController:rulesTableController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Edit

- (void)saveDataWithModel:(TSTableViewModel *)model {
    
}

#pragma mark - TSTableViewDelegate

- (void)tableView:(TSTableView *)tableView willSelectColumnAtPath:(NSIndexPath *)columnPath animated:(BOOL)animated {
    return;
}

- (void)tableView:(TSTableView *)tableView didSelectColumnAtPath:(NSIndexPath *)columnPath {
    return;
}

- (void)tableView:(TSTableView *)tableView willSelectRowAtPath:(NSIndexPath *)rowPath selectedCell:(NSInteger)cellIndex animated:(BOOL)animated {
    return;
}

- (void)tableView:(TSTableView *)tableView didSelectRowAtPath:(NSIndexPath *)rowPath selectedCell:(NSInteger)cellIndex {
    UIAlertController *addAlert = [UIAlertController alertControllerWithTitle:@"编辑数据" message:@"对数据进行编辑" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [tableView resetRowSelectionWithAnimtaion:YES];
    }];
    UIAlertAction *editDataAction = [UIAlertAction actionWithTitle:@"编辑数据" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIAlertController *editAlert = [UIAlertController alertControllerWithTitle:@"输入新数值" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [editAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"输入新数值";
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [tableView resetRowSelectionWithAnimtaion:YES];
        }];
        UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *tmpField = editAlert.textFields[0];
            float newData = ([tmpField.text isEqualToString:@""]) ? 0 : [tmpField.text floatValue];
            NSUInteger row = [rowPath indexAtPosition:0];
            TSRow *oldRow = tableModel.rows[row];
            NSMutableArray *oldCells = [[oldRow cells] mutableCopy];
            TSCell *newCell = [TSCell cellWithDictionary:@{@"value": [NSNumber numberWithFloat:newData]}];
            [oldCells removeObjectAtIndex:cellIndex];
            [oldCells insertObject:newCell atIndex:cellIndex];
            TSRow *newRow = [TSRow rowWithDictionary:@{@"cells": oldCells}];
            [tableModel removeRowAtPath:rowPath];
            [tableModel insertRow:newRow atPath:rowPath];
            
            [self saveDataWithModel:tableModel];
        }];
        
        [editAlert addAction:cancelAction];
        [editAlert addAction:editAction];
        [self presentViewController:editAlert animated:YES completion:nil];
        
    }];
    UIAlertAction *insertRowAction = [UIAlertAction actionWithTitle:@"在上方插入新行" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIAlertController *insertRowAlert = [UIAlertController alertControllerWithTitle:@"输入新行数据" message:nil preferredStyle:UIAlertControllerStyleAlert];
        NSInteger columnsCount = tableModel.columns.count;
        for (int i = 0; i < columnsCount; i ++) {
            [insertRowAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = [NSString stringWithFormat:@"输入第%d列数据", i + 1];
            }];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [tableView resetRowSelectionWithAnimtaion:YES];
        }];
        UIAlertAction *insertRow = [UIAlertAction actionWithTitle:@"插入" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableArray *newRowArr = [[NSMutableArray alloc] init];
            NSMutableArray *newRowDoubleArr = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < columnsCount; j ++) {
                UITextField *tmpTextField = insertRowAlert.textFields[j];
                double tmpValue = ([tmpTextField.text isEqualToString:@""]) ? 0 : [tmpTextField.text doubleValue];
                [newRowDoubleArr addObject:[NSNumber numberWithDouble:tmpValue]];
                [newRowArr addObject:@{@"value": [NSNumber numberWithDouble:tmpValue]}];
            }
            
            TSRow *newRow = [TSRow rowWithDictionary:@{@"cells": newRowArr}];
            [tableModel insertRow:newRow atPath:rowPath];
            
            [self saveDataWithModel:tableModel];
            
            [tableView resetRowSelectionWithAnimtaion:YES];
        }];
        [insertRowAlert addAction:cancelAction];
        [insertRowAlert addAction:insertRow];
        [self presentViewController:insertRowAlert animated:YES completion:nil];
        
    }];
    UIAlertAction *removeRowAction = [UIAlertAction actionWithTitle:@"删除此行" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [tableModel removeRowAtPath:rowPath];
        [self saveDataWithModel:tableModel];
        
        [tableView resetRowSelectionWithAnimtaion:YES];
        
    }];
    for (UIAlertAction *action in @[cancelAction, editDataAction, insertRowAction, removeRowAction]) {
        [addAlert addAction:action];
    }
    [self presentViewController:addAlert animated:YES completion:nil];
}

- (void)tableView:(TSTableView *)tableView widthDidChangeForColumnAtIndex:(NSInteger)columnIndex {
    return;
}

- (void)tableView:(TSTableView *)tableView expandStateDidChange:(BOOL)expand forRowAtPath:(NSIndexPath *)rowPath {
    return;
}

@end