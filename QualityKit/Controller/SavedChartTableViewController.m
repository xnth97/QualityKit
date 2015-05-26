//
//  SavedChartTableViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/26.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "SavedChartTableViewController.h"
#import "ALActionBlocks.h"
#import "QKDef.h"
#import "QKDataManager.h"
#import <Realm/Realm.h>
#import "ControlChartViewController.h"

@interface SavedChartTableViewController ()

@end

@implementation SavedChartTableViewController {
    RLMResults *chartData;
    NSMutableArray *chartDataInTable;
}

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"已保存的控制图";
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel block:^(id weakSender) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.navigationItem setRightBarButtonItem:cancelItem];
    
    RLMRealm *realm = [QKDataManager realmByName:QKSavedControlCharts];
    chartData = [QKSavedControlChart allObjectsInRealm:realm];
    
    chartDataInTable = [[NSMutableArray alloc] init];
    for (QKSavedControlChart *tmp in chartData) {
        [chartDataInTable addObject:@{@"name": tmp.name,
                                      @"type": tmp.controlChartType}];
    }
    
    _token = [realm addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
        chartData = [QKSavedControlChart allObjectsInRealm:realm];
    }];
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
    return chartDataInTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
    }
    // Configure the cell...
    NSUInteger row = [indexPath row];
    cell.textLabel.text = (chartDataInTable[row])[@"name"];
    cell.detailTextLabel.text = (chartDataInTable[row])[@"type"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    QKSavedControlChart *chart = chartData[row];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [delegate generateControlChartWithSavedChart:chart];
    }];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUInteger row = [indexPath row];
        [chartDataInTable removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        QKSavedControlChart *chart = chartData[row];
        RLMRealm *realm = [QKDataManager realmByName:QKSavedControlCharts];
        
        [realm beginWriteTransaction];
        [realm deleteObject:chart];
        [realm commitWriteTransaction];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
