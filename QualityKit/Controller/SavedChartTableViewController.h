//
//  SavedChartTableViewController.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/26.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QKSavedControlChart.h"

@protocol SavedChartDelegate <NSObject>

- (void)generateControlChartWithSavedChart:(QKSavedControlChart *)savedChart;

@end

@interface SavedChartTableViewController : UITableViewController

@property (strong, nonatomic) id <SavedChartDelegate> delegate;
@property (strong) RLMNotificationToken *token;

@end
