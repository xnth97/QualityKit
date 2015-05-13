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
    
    if (detailItem) {
        UIBarButtonItem *checkRules = [[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStylePlain block:^(id weakSender) {
            [self chooseCheckRules];
        }];
        UIBarButtonItem *controlSheetStyles = [[UIBarButtonItem alloc] initWithTitle:@"控制图" style:UIBarButtonItemStylePlain block:^(id weakSender) {
            [self chooseControlSheetStyle];
        }];
        self.navigationItem.rightBarButtonItems = @[checkRules, controlSheetStyles];
        
        dataTableView.hidden = NO;
        
        if ([[detailItem pathExtension] isEqualToString:@"xls"]) {
            [DataProcessor convertXLSFile:detailItem toTableModelWithBlock:^(NSArray *columns, NSArray *rows) {
                tableModel = [[TSTableViewModel alloc] initWithTableView:dataTableView andStyle:kTSTableViewStyleLight];
                [tableModel setColumns:columns andRows:rows];
                [dataTableView resetColumnSelectionWithAnimtaion:YES];
                [dataTableView resetRowSelectionWithAnimtaion:YES];
            }];
        }
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
    UIAlertAction *RSheet = [UIAlertAction actionWithTitle:@"R" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [styleController addAction:xBarR];
    [styleController addAction:RSheet];
    styleController.modalPresentationStyle = UIModalPresentationPopover;
    styleController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    styleController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems[1];
    [self presentViewController:styleController animated:YES completion:nil];
}

- (void)chooseCheckRules {
    RulesTableViewController *rulesTableViewController = [[RulesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *rulesTableController = [[UINavigationController alloc] initWithRootViewController:rulesTableViewController];
    rulesTableController.modalPresentationStyle = UIModalPresentationPopover;
    rulesTableController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    rulesTableController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems[0];
    [self presentViewController:rulesTableController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
