//
//  SelectControlChartViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/24.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "SelectControlChartViewController.h"
#import "ALActionBlocks.h"
#import "SavedChartTableViewController.h"

@interface SelectControlChartViewController () <SavedChartDelegate>

@end

@implementation SelectControlChartViewController

@synthesize scrollView;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择控制图";
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel block:^(id weakSender) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    
    UIBarButtonItem *useSavedControlChart = [[UIBarButtonItem alloc] initWithTitle:@"使用控制图" style:UIBarButtonItemStylePlain block:^(id weakSender) {
        SavedChartTableViewController *savedChart = [[SavedChartTableViewController alloc] initWithStyle:UITableViewStylePlain];
        savedChart.delegate = self;
        [self.navigationController pushViewController:savedChart animated:YES];
    }];
    [self.navigationItem setRightBarButtonItem:useSavedControlChart];
    
    UIImageView *baseImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectChart"]];
    [scrollView addSubview:baseImg];
    [scrollView setContentSize:CGSizeMake(baseImg.frame.size.width, 0)];
    scrollView.showsVerticalScrollIndicator = NO;
    
    for (int i = 0; i < 7; i ++) {
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(baseImg.frame.size.width - 320, 15 + i * 75, 320, 75)];
        tapView.tag = i;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithBlock:^(id weakSender) {
            UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)weakSender;
            NSUInteger tagIndex = recognizer.view.tag;
            if (tagIndex == 0) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [delegate selectXMRChart];
                }];
            } else if (tagIndex == 1) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [delegate selectXBarRChart];
                }];
            } else if (tagIndex == 2) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [delegate selectXBarSChart];
                }];
            } else if (tagIndex == 3) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [delegate selectPnChart];
                }];
            } else if (tagIndex == 4) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [delegate selectPChart];
                }];
            } else if (tagIndex == 5) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [delegate selectCChart];
                }];
            } else if (tagIndex == 6) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [delegate selectUChart];
                }];
            }
        }];
        [tapView addGestureRecognizer:tapRecognizer];
        [scrollView addSubview:tapView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - select chart table delegate

- (void)generateControlChartWithSavedChart:(QKSavedControlChart *)savedChart {
    [delegate generateChartWithSavedChart:savedChart];
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
