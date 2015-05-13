//
//  DetailViewController.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/10.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSTableView.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSString *detailItem;
@property (weak, nonatomic) IBOutlet TSTableView *dataTableView;

@end

