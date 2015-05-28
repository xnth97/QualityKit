//
//  MainSplitViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/25.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "MainSplitViewController.h"
#import "ALActionBlocks.h"

@interface MainSplitViewController ()

@end

@implementation MainSplitViewController {
    UIView *loginView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*
    loginView = [[UIView alloc] initWithFrame:self.view.frame];
    loginView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"Log In" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(200, 200, 300, 80)];
    [btn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [loginView removeFromSuperview];
    }];
    [loginView addSubview:btn];
    
    [self.view addSubview:loginView];
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
