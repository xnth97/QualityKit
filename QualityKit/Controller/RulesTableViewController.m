//
//  RulesTableViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "RulesTableViewController.h"
#import "QualityKitDef.h"

@interface RulesTableViewController ()

@end

@implementation RulesTableViewController {
    NSArray *rulesArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"规则与设置";
    
    rulesArr = @[@{@"key": QKCheckRuleOutsideControlLine,
                   @"value": @"点在控制线外部"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return rulesArr.count;
    } else if (section == 1) {
        return 1;
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
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (row == 0) {
            cell.textLabel.text = @"少于三个点自动修正";
            UISwitch *autoFixSwitch = [[UISwitch alloc] init];
            autoFixSwitch.on = [userDefaults boolForKey:QKAutoFix];
            [autoFixSwitch addTarget:self action:@selector(autoFixSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = autoFixSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        NSDictionary *tmp = rulesArr[row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSMutableArray *checkRules = [[NSUserDefaults standardUserDefaults] objectForKey:QKCheckRules];
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
    }
}

- (void)autoFixSwitchChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:QKAutoFix];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"请选择检验数据应用规则";
    } else {
        return @"修正设置";
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
