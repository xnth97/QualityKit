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
#import "MsgDisplay.h"

@interface ProcessCapabilityAnalysisViewController ()

@end

@implementation ProcessCapabilityAnalysisViewController {
    float USLValue;
    float LSLValue;
}

@synthesize controlChartType;
@synthesize dataArr;
@synthesize delegate;

@synthesize lslField;
@synthesize uslField;
@synthesize actionBtn;
@synthesize resultTextView;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *quantity = @[QKControlChartTypeXBarR, QKControlChartTypeXBarS, QKControlChartTypeXMR];
    if (![quantity containsObject:controlChartType]) {
        // 计件值
        uslField.text = @"1";
        lslField.text = @"0";
        uslField.hidden = YES;
        lslField.hidden = YES;
        actionBtn.hidden = YES;
        [self calculateProcessCapabilityAnalysis];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"过程能力分析";
    
    actionBtn.tintColor = [UIColor whiteColor];
    actionBtn.backgroundColor = [UIColor colorWithRed:0.000 green:0.600 blue:1.000 alpha:1.000];
    actionBtn.layer.cornerRadius = 5.0;
    actionBtn.clipsToBounds = YES;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel block:^(id weakSender) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    UIBarButtonItem *exportItem = [[UIBarButtonItem alloc] initWithTitle:@"导出报告" style:UIBarButtonItemStylePlain block:^(id weakSender) {
        if ([resultTextView.text isEqualToString:@""]) {
            [MsgDisplay showErrorMsg:@"请先进行过程能力分析"];
        } else {
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
        }
    }];
    [self.navigationItem setRightBarButtonItem:exportItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculateProcessCapabilityAnalysis {
    [lslField resignFirstResponder];
    [uslField resignFirstResponder];
    
    if ([uslField.text isEqualToString:@""] || [lslField.text isEqualToString:@""]) {
        [MsgDisplay showErrorMsg:@"请输入数值"];
        return;
    } else {
        USLValue = [uslField.text floatValue];
        LSLValue = [lslField.text floatValue];
        
        if (USLValue <= LSLValue) {
            [MsgDisplay showErrorMsg:@"USL 必须大于 LSL"];
        } else {
            NSArray *quantity = @[QKControlChartTypeXBarR, QKControlChartTypeXBarS, QKControlChartTypeXMR];
            if ([quantity containsObject:controlChartType]) {
                // 计量值
                NSString *cpString = [NSString stringWithFormat:@"%f",[QKProcessCapabilityAnalysis CPValueOfData:dataArr USL:USLValue LSL:LSLValue]];
                NSString *cpuString = [NSString stringWithFormat:@"%f", [QKProcessCapabilityAnalysis CPUValueOfData:dataArr USL:USLValue LSL:LSLValue]];
                NSString *cplString = [NSString stringWithFormat:@"%f", [QKProcessCapabilityAnalysis CPLValueOfData:dataArr USL:USLValue LSL:LSLValue]];
                NSString *cpkString = [NSString stringWithFormat:@"%f", [QKProcessCapabilityAnalysis CPKValueOfData:dataArr USL:USLValue LSL:LSLValue]];
                NSString *resultString = [NSString stringWithFormat:@"CP = %@\nCPU = %@\nCPL = %@\nCPK = %@\n", cpString, cpuString, cplString, cpkString];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineHeightMultiple = 30.0f;
                paragraphStyle.maximumLineHeight = 35.0f;
                paragraphStyle.minimumLineHeight = 25.0f;
                paragraphStyle.alignment = NSTextAlignmentJustified;
                NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:22.0],
                                             NSParagraphStyleAttributeName: paragraphStyle,
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
                resultTextView.attributedText = [[NSAttributedString alloc] initWithString:resultString attributes:attributes];
                
                resultTextView.text = resultString;
                
                [data shareInstance].parameters = @{@"USL": uslField.text,
                                                    @"LSL": lslField.text,
                                                    @"CP": cpString,
                                                    @"CPu": cpuString,
                                                    @"CPl": cplString,
                                                    @"CPk": cpkString};
                
            } else {
                // 计件值
                if ([controlChartType isEqualToString:QKControlChartTypeP] || [controlChartType isEqualToString:QKControlChartTypePn]) {
                    NSString *pbarString = [NSString stringWithFormat:@"%f", [QKProcessCapabilityAnalysis PiecesCapabilityValueOfData:dataArr]];
                    NSString *resultString = [NSString stringWithFormat:@"PBar = %@\n", pbarString];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineHeightMultiple = 30.0f;
                    paragraphStyle.maximumLineHeight = 35.0f;
                    paragraphStyle.minimumLineHeight = 25.0f;
                    paragraphStyle.alignment = NSTextAlignmentJustified;
                    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:22.0],
                                                 NSParagraphStyleAttributeName: paragraphStyle,
                                                 NSForegroundColorAttributeName: [UIColor blackColor]};
                    resultTextView.attributedText = [[NSAttributedString alloc] initWithString:resultString attributes:attributes];
                    
                    resultTextView.text = resultString;
                    
                    [data shareInstance].parameters = @{@"PBar": pbarString};
                } else if ([controlChartType isEqualToString:QKControlChartTypeC]) {
                    NSString *cbarString = [NSString stringWithFormat:@"%f", [QKProcessCapabilityAnalysis PiecesCapabilityValueOfData:dataArr]];
                    NSString *resultString = [NSString stringWithFormat:@"CBar = %@\n", cbarString];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineHeightMultiple = 30.0f;
                    paragraphStyle.maximumLineHeight = 35.0f;
                    paragraphStyle.minimumLineHeight = 25.0f;
                    paragraphStyle.alignment = NSTextAlignmentJustified;
                    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:22.0],
                                                 NSParagraphStyleAttributeName: paragraphStyle,
                                                 NSForegroundColorAttributeName: [UIColor blackColor]};
                    resultTextView.attributedText = [[NSAttributedString alloc] initWithString:resultString attributes:attributes];
                    
                    resultTextView.text = resultString;
                    
                    [data shareInstance].parameters = @{@"CBar": cbarString};
                } else if ([controlChartType isEqualToString:QKControlChartTypeU]) {
                    NSString *ubarString = [NSString stringWithFormat:@"%f", [QKProcessCapabilityAnalysis PiecesCapabilityValueOfData:dataArr]];
                    NSString *resultString = [NSString stringWithFormat:@"UBar = %@\n", ubarString];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineHeightMultiple = 30.0f;
                    paragraphStyle.maximumLineHeight = 35.0f;
                    paragraphStyle.minimumLineHeight = 25.0f;
                    paragraphStyle.alignment = NSTextAlignmentJustified;
                    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:22.0],
                                                 NSParagraphStyleAttributeName: paragraphStyle,
                                                 NSForegroundColorAttributeName: [UIColor blackColor]};
                    resultTextView.attributedText = [[NSAttributedString alloc] initWithString:resultString attributes:attributes];
                    
                    resultTextView.text = resultString;
                    
                    [data shareInstance].parameters = @{@"UBar": ubarString};
                }
            }
        }
    }
}

- (IBAction)backgroundTapped {
    [lslField resignFirstResponder];
    [uslField resignFirstResponder];
}

- (IBAction)nextTextField {
    [uslField resignFirstResponder];
    [lslField becomeFirstResponder];
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
