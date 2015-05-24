//
//  SelectControlChartViewController.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/24.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectControlChartDelegate <NSObject>

- (void)selectXBarRChart;
- (void)selectXBarSChart;
- (void)selectXMRChart;
- (void)selectPChart;
- (void)selectPnChart;
- (void)selectCChart;
- (void)selectUChart;

@end

@interface SelectControlChartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) id <SelectControlChartDelegate> delegate;

@end
