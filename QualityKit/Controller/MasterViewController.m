//
//  MasterViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/10.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "DataManager.h"
#import "MsgDisplay.h"
#import "QKData5.h"

@interface MasterViewController ()

@property NSMutableArray *objects;

@end

@implementation MasterViewController

@synthesize dataSourceSegmented;
@synthesize objects;

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [dataSourceSegmented addTarget:self action:@selector(dataSourceChanged) forControlEvents:UIControlEventValueChanged];
    dataSourceSegmented.selectedSegmentIndex = 0;
    objects = [[NSMutableArray alloc] init];
    [self dataSourceChanged];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!objects) {
        objects = [[NSMutableArray alloc] init];
    }
    //[objects insertObject:[NSDate date] atIndex:0];
    
    if (dataSourceSegmented.selectedSegmentIndex == 0) {
        
        UIAlertController *inputTitleController = [UIAlertController alertControllerWithTitle:@"创建文件" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [inputTitleController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入文件标题";
            textField.keyboardAppearance = UIKeyboardAppearanceDefault;
        }];
        [inputTitleController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入列数";
            textField.keyboardAppearance = UIKeyboardAppearanceDefault;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *titleField = inputTitleController.textFields[0];
            UITextField *titleField2 = inputTitleController.textFields[1];
            if ([titleField.text isEqualToString:@""]) {
                [MsgDisplay showErrorMsg:@"文件名不能为空"];
            } else {
                
                NSString *numStr = titleField2.text;
                if ([numStr integerValue] <= 0) {
                    [MsgDisplay showErrorMsg:@"列数出错"];
                    return;
                } else {
                    [DataManager createLocalXLSFile:[titleField.text stringByAppendingPathExtension:@"xls"] columnNumber:[numStr integerValue]];
                    [objects insertObject:[titleField.text stringByAppendingPathExtension:@"xls"] atIndex:0];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }];
        [inputTitleController addAction:cancelAction];
        [inputTitleController addAction:okAction];
        [self presentViewController:inputTitleController animated:YES completion:nil];
        
    } else if (dataSourceSegmented.selectedSegmentIndex == 1) {
        
        UIAlertController *selectRealmTypeController = [UIAlertController alertControllerWithTitle:@"新建数据库" message:@"请输入数据库名称并选择数据类型" preferredStyle:UIAlertControllerStyleAlert];
        [selectRealmTypeController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"输入数据库名称";
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *qkData5Action = [UIAlertAction actionWithTitle:@"每组5个样本" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UITextField *field = selectRealmTypeController.textFields[0];
            if ([field.text isEqualToString:@""]) {
                [MsgDisplay showErrorMsg:@"数据库名不能为空"];
            } else {
                QKData5 *data = [[QKData5 alloc] init];
                [DataManager createLocalFile:field.text extension:@"realm"];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    RLMRealm *realm = [RLMRealm realmWithPath:[DataManager fullPathOfFile:[field.text stringByAppendingPathExtension:@"realm"]]];
                    [realm beginWriteTransaction];
                    [realm addObject:data];
                    [realm commitWriteTransaction];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [objects insertObject:[field.text stringByAppendingPathExtension:@"realm"] atIndex:0];
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    });
                    
                });
            }
            
        }];
        for (UIAlertAction *action in @[cancelAction, qkData5Action]) {
            [selectRealmTypeController addAction:action];
        }
        [self presentViewController:selectRealmTypeController animated:YES completion:nil];
        
    }
    
}

- (void)dataSourceChanged {
    [objects removeAllObjects];
    if (dataSourceSegmented.selectedSegmentIndex == 0) {
        // Excel
        [DataManager loadLocalExcelFilesWithBlock:^(NSArray *excelFiles) {
            objects = [excelFiles mutableCopy];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    } else if (dataSourceSegmented.selectedSegmentIndex == 1) {
        // Realm
        [DataManager loadLocalRealmDatabasesWithBlock:^(NSArray *realmDatabases) {
            objects = [realmDatabases mutableCopy];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:objects[indexPath.row]];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSUInteger row = [indexPath row];
    cell.textLabel.text = objects[row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [DataManager removeLocalFile:objects[indexPath.row]];
        [objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
