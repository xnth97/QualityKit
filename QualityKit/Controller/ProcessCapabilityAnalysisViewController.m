//
//  ProcessCapabilityAnalysisViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "ProcessCapabilityAnalysisViewController.h"
#import "ALActionBlocks.h"
#import "QKDef.h"
#import "QKExportManager.h"

@interface ProcessCapabilityAnalysisViewController ()

@end

@implementation ProcessCapabilityAnalysisViewController

@synthesize controlChartType;
@synthesize dataArr;
@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self calculateProcessCapabilityAnalysis];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"过程能力分析";
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel block:^(id weakSender) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    UIBarButtonItem *exportItem = [[UIBarButtonItem alloc] initWithTitle:@"导出报告" style:UIBarButtonItemStylePlain block:^(id weakSender) {
        UIAlertController *fileNameAlert = [UIAlertController alertControllerWithTitle:@"导出报告" message:@"请输入文件名" preferredStyle:UIAlertControllerStyleAlert];
        [fileNameAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"输入文件名";
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"导出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = fileNameAlert.textFields[0];
            [QKExportManager createPDFReportWithFileName:textField.text successBlock:^{
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [delegate pushPDFPreviewViewControllerWithFileName:textField.text];
                }];
            }];
        }];
        [fileNameAlert addAction:cancelAction];
        [fileNameAlert addAction:okAction];
        [self presentViewController:fileNameAlert animated:YES completion:nil];
        
    }];
    [self.navigationItem setRightBarButtonItem:exportItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateProcessCapabilityAnalysis {
    NSArray *quantity = @[QKControlChartTypeXBarR, QKControlChartTypeXBarS, QKControlChartTypeXMR];
    if ([quantity containsObject:controlChartType]) {
        // 计量值
        _cpValue.text = [NSString stringWithFormat:@"%f",[QKProcessCapabilityAnalysis CPValueOfData:dataArr]];
        _cpuValue.text = [NSString stringWithFormat:@"%f", [QKProcessCapabilityAnalysis CPUValueOfData:dataArr]];
        _cplValue.text = [NSString stringWithFormat:@"%f", [QKProcessCapabilityAnalysis CPLValueOfData:dataArr]];
        _cpkValue.text = [NSString stringWithFormat:@"%f", ([QKProcessCapabilityAnalysis CPUValueOfData:dataArr] < [QKProcessCapabilityAnalysis CPLValueOfData:dataArr] ? [QKProcessCapabilityAnalysis CPUValueOfData:dataArr] : [QKProcessCapabilityAnalysis CPLValueOfData:dataArr])];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
