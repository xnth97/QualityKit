//
//  ProcessCapabilityAnalysisViewController.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProcessCapabilityAnalysisDelegate <NSObject>

- (void)pushPDFPreviewViewControllerWithFileName:(NSString *)fileName;

@end

@interface ProcessCapabilityAnalysisViewController : UIViewController

@property (strong, nonatomic) NSString *controlChartType;
@property (strong, nonatomic) NSArray *dataArr;

@property (weak, nonatomic) IBOutlet UILabel *cpLabel;
@property (weak, nonatomic) IBOutlet UILabel *cpValue;
@property (weak, nonatomic) IBOutlet UILabel *cpuLabel;
@property (weak, nonatomic) IBOutlet UILabel *cpuValue;
@property (weak, nonatomic) IBOutlet UILabel *cplLabel;
@property (weak, nonatomic) IBOutlet UILabel *cplValue;
@property (weak, nonatomic) IBOutlet UILabel *cpkLabel;
@property (weak, nonatomic) IBOutlet UILabel *cpkValue;

@property (strong, nonatomic) id <ProcessCapabilityAnalysisDelegate> delegate;

@end
