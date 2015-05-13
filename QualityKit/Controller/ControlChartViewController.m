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
    UITextView *errorMsgView;
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
        
        errorMsgView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        errorMsgView.translatesAutoresizingMaskIntoConstraints = NO;
        errorMsgView.font = [UIFont systemFontOfSize:14.0];
        [self.view addSubview:errorMsgView];
        
        [ControlChartDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeXBar withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text = ([_errDescription isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"X-bar 图：%@", _errDescription];
        }];
        [self.view addSubview:chartView];
        
        subChartView = [[ControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        subChartView.translatesAutoresizingMaskIntoConstraints = NO;
        [ControlChartDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeR withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            subChartView.UCLValue = _UCLValue;
            subChartView.LCLValue = _LCLValue;
            subChartView.CLValue = _CLValue;
            subChartView.dataArr = _plotArr;
            subChartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text =  ([_errDescription isEqualToString:@""]) ? errorMsgView.text : [NSString stringWithFormat:@"%@\n\nR 图：%@", errorMsgView.text, _errDescription];
        }];
        [self.view addSubview:subChartView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(chartView, subChartView, errorMsgView);
        NSDictionary *metrics = @{@"lowerDist": @240};
        NSString *vfl = @"|-16-[chartView]-16-|";
        NSString *vfl2 = @"V:|-64-[chartView]-32-[subChartView(chartView)]-16-[errorMsgView(180)]-16-|";
        NSString *vfl3 = @"|-16-[subChartView]-16-|";
        NSString *vfl4 = @"|-16-[errorMsgView]-16-|";
        for (NSString *tmpVFL in @[vfl, vfl2, vfl3, vfl4]) {
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
