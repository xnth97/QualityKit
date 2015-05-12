//
//  ControlChartViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "ControlChartViewController.h"
#import "ControlChartView.h"
#import "QualityKitDef.h"
#import "ControlChartDataAnalyzer.h"

@interface ControlChartViewController ()

@end

@implementation ControlChartViewController {
    ControlChartView *chartView;
}

@synthesize chartType;
@synthesize dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([chartType isEqualToString:QKControlChartTypeXBarR]) {
        chartView = [[ControlChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        chartView.translatesAutoresizingMaskIntoConstraints = NO;
        /*
        chartView.UCLValue = 10.0f;
        chartView.LCLValue = 5.0f;
        chartView.CLValue = 7.5f;
        chartView.dataArr = @[@6, @10, @8, @9, @7, @9.6, @5.8, @7.75, @6.9];
        chartView.indexesOfErrorPoints = @[@1, @2, @5];
         */
        [ControlChartDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:@[] controlChartType:QKControlChartTypeR withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
        }];
        [self.view addSubview:chartView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(chartView);
        NSDictionary *metrics = @{@"lowerDist": @240};
        NSString *vfl = @"|-16-[chartView]-16-|";
        NSString *vfl2 = @"V:|-64-[chartView]-lowerDist-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:views]];
    }
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
