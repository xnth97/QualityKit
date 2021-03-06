//
//  RulesTableViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "RulesTableViewController.h"
#import "QKDef.h"

@interface RulesTableViewController ()

@end

@implementation RulesTableViewController {
    NSArray *rulesArr;
    NSArray *significanceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"规则与设置";
    
    rulesArr = @[@{@"key": QKCheckRuleOutsideControlLine,
                   @"value": @"点在控制线外部"},
                 @{@"key": QKCheckRuleTwoOfThreeInAreaA,
                   @"value": @"连续三点有两点在A区"},
                 @{@"key": QKCheckRuleFourOfFiveInAreaB,
                   @"value": @"连续五点有四点在B区"},
                 @{@"key": QKCheckRuleConsecutiveSixPointsChangeInSameWay,
                   @"value": @"连续六点稳定上升或下降"},
                 @{@"key": QKCheckRuleConsecutiveNinePointsOneSide,
                   @"value": @"连续九点在中心线一侧"}];
    
    significanceArr = @[@0.1, @0.05, @0.01];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return rulesArr.count;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return significanceArr.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        cell.textLabel.text = (rulesArr[row])[@"value"];
        NSMutableArray *checkRules = [[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules];
        if ([checkRules containsObject:(rulesArr[row])[@"key"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (section == 1) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (row == 0) {
            cell.textLabel.text = @"少于三个点自动修正";
            UISwitch *autoFixSwitch = [[UISwitch alloc] init];
            autoFixSwitch.on = [userDefaults boolForKey:QKAutoFix];
            [autoFixSwitch addTarget:self action:@selector(autoFixSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = autoFixSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else if (section == 2) {
        cell.textLabel.text = [significanceArr[row] stringValue];
        if ([significanceArr[row] isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:QKSignificance]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (section == 0) {
        NSDictionary *tmp = rulesArr[row];
        NSMutableArray *checkRules = [[[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules] mutableCopy];
        if ([checkRules containsObject:tmp[@"key"]]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [checkRules removeObject:tmp[@"key"]];
            [[NSUserDefaults standardUserDefaults] setObject:checkRules forKey:QKCheckRules];
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [checkRules addObject:tmp[@"key"]];
            [[NSUserDefaults standardUserDefaults] setObject:checkRules forKey:QKCheckRules];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (section == 2) {
        if (![significanceArr[row] isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:QKSignificance]]) {
            [[NSUserDefaults standardUserDefaults] setObject:significanceArr[row] forKey:QKSignificance];
            [tableView reloadData];
        }
    }
}

- (void)autoFixSwitchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:QKAutoFix];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"检验数据应用规则";
    } else if (section == 1) {
        return @"修正设置";
    } else if (section == 2) {
        return @"Shapiro Wilk 检验显著性";
    } else {
        return nil;
    }
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
