//
//  ControlChartViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "ControlChartViewController.h"

@interface ControlChartViewController ()

@end

@implementation ControlChartViewController

@synthesize chartView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    chartView.UCLValue = 10.0f;
    chartView.LCLValue = 5.0f;
    chartView.CLValue = 7.5f;
    chartView.dataArr = @[@6, @10, @8, @9, @7, @9.6, @5.8, @7.75, @6.9];
    chartView.indexesOfErrorPoints = @[@1, @2, @5];
    [chartView strokeControlChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
