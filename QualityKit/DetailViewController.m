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

- (void)configureView {
    // Update the user interface for the detail item.
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataTableView.hidden = YES;
    self.title = @"详情";
    
    if (detailItem) {
        UIBarButtonItem *controlSheetStyles = [[UIBarButtonItem alloc] initWithTitle:@"样式" style:UIBarButtonItemStylePlain block:^(id weakSender) {
            [self chooseControlSheetStyle];
        }];
        self.navigationItem.rightBarButtonItems = @[controlSheetStyles];
        
        dataTableView.hidden = NO;
        
        if ([[detailItem pathExtension] isEqualToString:@"xls"]) {
            [DataProcessor convertXLSFile:detailItem toTableModelWithBlock:^(NSArray *columns, NSArray *rows) {
                tableModel = [[TSTableViewModel alloc] initWithTableView:dataTableView andStyle:kTSTableViewStyleLight];
                [tableModel setColumns:columns andRows:rows];
                [dataTableView resetColumnSelectionWithAnimtaion:YES];
                [dataTableView resetRowSelectionWithAnimtaion:YES];
                [self configureView];
            }];
        }
    }
}

- (void)chooseControlSheetStyle {
    UIAlertController *styleController = [UIAlertController alertControllerWithTitle:@"选择控制图类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *xBarR = [UIAlertAction actionWithTitle:@"XBar-R" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ControlChartViewController *chart = [[ControlChartViewController alloc] initWithNibName:@"ControlChartViewController" bundle:nil];
        [self.navigationController pushViewController:chart animated:YES];
    }];
    UIAlertAction *RSheet = [UIAlertAction actionWithTitle:@"R" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [styleController addAction:xBarR];
    [styleController addAction:RSheet];
    styleController.modalPresentationStyle = UIModalPresentationPopover;
    styleController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    styleController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController:styleController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
