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
    ControlChartView *subChartView;
}

@synthesize chartType;
@synthesize dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([chartType isEqualToString:QKControlChartTypeXBarR]) {
        
        chartView = [[ControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        chartView.translatesAutoresizingMaskIntoConstraints = NO;
        /*
        chartView.UCLValue = 10.0f;
        chartView.LCLValue = 5.0f;
        chartView.CLValue = 7.5f;
        chartView.dataArr = @[@6, @10, @8, @9, @7, @9.6, @5.8, @7.75, @6.9];
        chartView.indexesOfErrorPoints = @[@1, @2, @5];
         */
        [ControlChartDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:@[] controlChartType:QKControlChartTypeXBar withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
        }];
        [self.view addSubview:chartView];
        
        subChartView = [[ControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        subChartView.translatesAutoresizingMaskIntoConstraints = NO;
        [ControlChartDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:@[] controlChartType:QKControlChartTypeR withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            subChartView.UCLValue = _UCLValue;
            subChartView.LCLValue = _LCLValue;
            subChartView.CLValue = _CLValue;
            subChartView.dataArr = _plotArr;
            subChartView.indexesOfErrorPoints = _indexesOfErrorPoints;
        }];
        [self.view addSubview:subChartView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(chartView, subChartView);
        NSDictionary *metrics = @{@"lowerDist": @240};
        NSString *vfl = @"|-16-[chartView]-16-|";
        NSString *vfl2 = @"V:|-64-[chartView]-32-[subChartView(chartView)]-lowerDist-|";
        NSString *vfl3 = @"|-16-[subChartView]-16-|";
        for (NSString *tmpVFL in @[vfl, vfl2, vfl3]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:tmpVFL options:0 metrics:metrics views:views]];
        }
    }
    
    self.title = [NSString stringWithFormat:@"%@ 控制图", chartType];
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
