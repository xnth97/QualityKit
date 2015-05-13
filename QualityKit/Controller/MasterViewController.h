//
//  MasterViewController.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/10.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *dataSourceSegmented;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end

