//
//  ControlChartViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "ControlChartViewController.h"
#import "ALActionBlocks.h"
#import "QKControlChartView.h"
#import "QKDef.h"
#import "QKDataAnalyzer.h"
#import "MsgDisplay.h"
#import "QKStatisticalFoundations.h"

@interface ControlChartViewController ()

@end

@implementation ControlChartViewController {
    QKControlChartView *chartView;
    QKControlChartView *subChartView;
    UITextView *errorMsgView;
}

@synthesize chartType;
@synthesize dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *processAnalysisBtn = [[UIBarButtonItem alloc] initWithTitle:@"过程能力分析" style:UIBarButtonItemStylePlain block:^(id weakSender) {
        if ((chartView != nil && chartView.indexesOfErrorPoints.count != 0) || (chartView != nil && chartView.indexesOfErrorPoints.count != 0 && subChartView != nil && subChartView.indexesOfErrorPoints.count != 0)) {
            // 控制图不受控
            [MsgDisplay showErrorMsg:@"过程不受控\n无法进行过程能力分析"];
        } else if (chartView != nil && subChartView != nil) {
            // 有两个图
            if ([QKStatisticalFoundations shapiroWilkTest:chartView.dataArr]) {
                [self processCapabilityAnalysis];
            } else {
                [MsgDisplay showErrorMsg:@"数据不满足正态分布"];
            }
        } else if (chartView != nil) {
            // 有一个图
            if ([QKStatisticalFoundations shapiroWilkTest:chartView.dataArr]) {
                [self processCapabilityAnalysis];
            } else {
                [MsgDisplay showErrorMsg:@"数据不满足正态分布"];
            }
        }
    }];
    [self.navigationItem setRightBarButtonItems:@[processAnalysisBtn]];
    
    errorMsgView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    errorMsgView.translatesAutoresizingMaskIntoConstraints = NO;
    errorMsgView.font = [UIFont systemFontOfSize:14.0];
    errorMsgView.editable = NO;
    [self.view addSubview:errorMsgView];
    
    if ([chartType isEqualToString:QKControlChartTypeXBarR]) {
        
        chartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        chartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeXBar withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text = ([_errDescription isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"X-bar 图：\n%@", _errDescription];
        }];
        [self.view addSubview:chartView];
        
        subChartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        subChartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeR withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            subChartView.UCLValue = _UCLValue;
            subChartView.LCLValue = _LCLValue;
            subChartView.CLValue = _CLValue;
            subChartView.dataArr = _plotArr;
            subChartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text =  ([_errDescription isEqualToString:@""]) ? errorMsgView.text : [NSString stringWithFormat:@"%@\nR 图：\n%@", errorMsgView.text, _errDescription];
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
    
    if ([chartType isEqualToString:QKControlChartTypeXBarS]) {
        
        chartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        chartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeXBarUsingS withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text = ([_errDescription isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"X-bar 图：\n%@", _errDescription];
        }];
        [self.view addSubview:chartView];
        
        subChartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        subChartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeS withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            subChartView.UCLValue = _UCLValue;
            subChartView.LCLValue = _LCLValue;
            subChartView.CLValue = _CLValue;
            subChartView.dataArr = _plotArr;
            subChartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text =  ([_errDescription isEqualToString:@""]) ? errorMsgView.text : [NSString stringWithFormat:@"%@\nS 图：\n%@", errorMsgView.text, _errDescription];
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
    
    if ([chartType isEqualToString:QKControlChartTypeXMR]) {
        
        chartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        chartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeX withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text = ([_errDescription isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"X 图：\n%@", _errDescription];
        }];
        [self.view addSubview:chartView];
        
        subChartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        subChartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeMR withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            subChartView.UCLValue = _UCLValue;
            subChartView.LCLValue = _LCLValue;
            subChartView.CLValue = _CLValue;
            subChartView.dataArr = _plotArr;
            subChartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text =  ([_errDescription isEqualToString:@""]) ? errorMsgView.text : [NSString stringWithFormat:@"%@\nMR 图：\n%@", errorMsgView.text, _errDescription];
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
    
    if ([chartType isEqualToString:QKControlChartTypeP]) {
        
        chartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        chartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeP withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text = ([_errDescription isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"P 图：%@", _errDescription];
        }];
        [self.view addSubview:chartView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(chartView, errorMsgView);
        NSDictionary *metrics = @{@"lowerDist": @240};
        NSString *vfl = @"|-16-[chartView]-16-|";
        NSString *vfl2 = @"V:|-64-[chartView]-32-[errorMsgView(240)]-16-|";
        NSString *vfl4 = @"|-16-[errorMsgView]-16-|";
        for (NSString *tmpVFL in @[vfl, vfl2, vfl4]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:tmpVFL options:0 metrics:metrics views:views]];
        }
        
    }
    
    if ([chartType isEqualToString:QKControlChartTypePn]) {
        
        chartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        chartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypePn withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text = ([_errDescription isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"Pn 图：\n%@", _errDescription];
        }];
        [self.view addSubview:chartView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(chartView, errorMsgView);
        NSDictionary *metrics = @{@"lowerDist": @240};
        NSString *vfl = @"|-16-[chartView]-16-|";
        NSString *vfl2 = @"V:|-64-[chartView]-32-[errorMsgView(240)]-16-|";
        NSString *vfl4 = @"|-16-[errorMsgView]-16-|";
        for (NSString *tmpVFL in @[vfl, vfl2, vfl4]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:tmpVFL options:0 metrics:metrics views:views]];
        }
        
    }
    
    if ([chartType isEqualToString:QKControlChartTypeC]) {
        chartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        chartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeC withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text = ([_errDescription isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"C 图：\n%@", _errDescription];
        }];
        [self.view addSubview:chartView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(chartView, errorMsgView);
        NSDictionary *metrics = @{@"lowerDist": @240};
        NSString *vfl = @"|-16-[chartView]-16-|";
        NSString *vfl2 = @"V:|-64-[chartView]-32-[errorMsgView(240)]-16-|";
        NSString *vfl4 = @"|-16-[errorMsgView]-16-|";
        for (NSString *tmpVFL in @[vfl, vfl2, vfl4]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:tmpVFL options:0 metrics:metrics views:views]];
        }
    }
    
    if ([chartType isEqualToString:QKControlChartTypeU]) {
        chartView = [[QKControlChartView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        chartView.translatesAutoresizingMaskIntoConstraints = NO;
        [QKDataAnalyzer getStatisticalValuesOfDoubleArray:dataArr checkRulesArray:[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] controlChartType:QKControlChartTypeU withBlock:^(float _UCLValue, float _LCLValue, float _CLValue, NSArray *_plotArr, NSArray *_indexesOfErrorPoints, NSString *_errDescription) {
            chartView.UCLValue = _UCLValue;
            chartView.LCLValue = _LCLValue;
            chartView.CLValue = _CLValue;
            chartView.dataArr = _plotArr;
            chartView.indexesOfErrorPoints = _indexesOfErrorPoints;
            errorMsgView.text = ([_errDescription isEqualToString:@""]) ? @"" : [NSString stringWithFormat:@"U 图：\n%@", _errDescription];
        }];
        [self.view addSubview:chartView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(chartView, errorMsgView);
        NSDictionary *metrics = @{@"lowerDist": @240};
        NSString *vfl = @"|-16-[chartView]-16-|";
        NSString *vfl2 = @"V:|-64-[chartView]-32-[errorMsgView(240)]-16-|";
        NSString *vfl4 = @"|-16-[errorMsgView]-16-|";
        for (NSString *tmpVFL in @[vfl, vfl2, vfl4]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:tmpVFL options:0 metrics:metrics views:views]];
        }
    }
    
    self.title = [NSString stringWithFormat:@"%@ 控制图", chartType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processCapabilityAnalysis {
    NSLog(@"Fuck the PCA");
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
