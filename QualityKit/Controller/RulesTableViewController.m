//
//  RulesTableViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "RulesTableViewController.h"
#import "QualityKitDef.h"

@interface RulesTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RulesTableViewController {
    NSArray *rulesArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    rulesArr = @[@{@"key": QKCheckRuleOutsideControlLine,
                   @"value": @"点在控制线外部"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return rulesArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    NSUInteger row = indexPath.row;
    cell.textLabel.text = (rulesArr[row])[@"value"];
    NSMutableArray *checkRules = [[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules];
    if ([checkRules containsObject:(rulesArr[row])[@"key"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    NSDictionary *tmp = rulesArr[row];
    NSMutableArray *checkRules = [[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules];
    if ([checkRules containsObject:tmp[@"key"]]) {
        [checkRules removeObject:tmp[@"key"]];
    } else {
        [checkRules addObject:tmp[@"key"]];
    }
    [tableView reloadData];
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
