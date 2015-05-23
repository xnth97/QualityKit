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

@property (weak, nonatomic) IBOutlet UITextField *uslField;
@property (weak, nonatomic) IBOutlet UITextField *lslField;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@property (strong, nonatomic) id <ProcessCapabilityAnalysisDelegate> delegate;

- (IBAction)backgroundTapped;
- (IBAction)calculateProcessCapabilityAnalysis;

@end
