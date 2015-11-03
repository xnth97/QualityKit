//
//  MainSplitViewController.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/25.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "MainSplitViewController.h"
#import "ALActionBlocks.h"
#import "MsgDisplay.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface MainSplitViewController ()

@end

@implementation MainSplitViewController {
    UIView *loginView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self initializeLoginView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeLoginView {
    loginView = [[UIView alloc] initWithFrame:self.view.frame];
    loginView.backgroundColor = [UIColor whiteColor];
    
    UITextField *usernameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    usernameField.borderStyle = UITextBorderStyleRoundedRect;
    usernameField.placeholder = @"请输入用户名";
    usernameField.translatesAutoresizingMaskIntoConstraints = NO;
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [loginView addSubview:usernameField];
    [usernameField becomeFirstResponder];
    
    UITextField *passwdField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    passwdField.borderStyle = UITextBorderStyleRoundedRect;
    passwdField.placeholder = @"请输入密码";
    passwdField.secureTextEntry = YES;
    passwdField.translatesAutoresizingMaskIntoConstraints = NO;
    passwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [loginView addSubview:passwdField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 1, 1)];
    [btn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        if ([usernameField.text isEqualToString:@""] || [passwdField.text isEqualToString:@""]) {
            [MsgDisplay showErrorMsg:@"请填写完整用户名和密码"];
        } else if ([usernameField.text isEqualToString:@"syx"] && [passwdField.text isEqualToString:@"syxsb"]) {
            [UIView animateWithDuration:0.5 animations:^{
                loginView.center = CGPointMake(loginView.center.x, loginView.center.y + self.view.frame.size.height);
            } completion:^(BOOL finished) {
                if (finished) {
                    [loginView removeFromSuperview];
                }
            }];
        } else {
            [MsgDisplay showErrorMsg:@"用户名或密码不正确"];
        }
        
    }];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:0.000 green:0.400 blue:0.800 alpha:1.000];
    btn.layer.cornerRadius = 5.0;
    btn.clipsToBounds = YES;
    [loginView addSubview:btn];
    
    UIButton *touchIdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [touchIdBtn setTitle:@"Touch ID" forState:UIControlStateNormal];
    [touchIdBtn setFrame:CGRectMake(0, 0, 1, 1)];
    [touchIdBtn handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        LAContext *context = [[LAContext alloc] init];
        context.localizedFallbackTitle = @"";
        NSError *error = [[NSError alloc] init];
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证指纹" reply:^(BOOL success, NSError *error) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5 animations:^{
                            loginView.center = CGPointMake(loginView.center.x, loginView.center.y + self.view.frame.size.height);
                        } completion:^(BOOL finished) {
                            if (finished) {
                                [loginView removeFromSuperview];
                            }
                        }];
                    });
                } else {
                    if (error.code == -1) {
                        [MsgDisplay showErrorMsg:@"指纹验证失败"];
                    }
                }
            }];
        }
    }];
    touchIdBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [touchIdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    touchIdBtn.backgroundColor = [UIColor colorWithRed:0.000 green:0.400 blue:0.800 alpha:1.000];
    touchIdBtn.layer.cornerRadius = 5.0;
    touchIdBtn.clipsToBounds = YES;
    [loginView addSubview:touchIdBtn];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(usernameField, passwdField, btn, touchIdBtn);
    NSDictionary *metrics = @{@"horiBorderDist": @372,
                              @"vertiBorderDist": @120};
    NSString *vfl1 = @"|-horiBorderDist-[usernameField]-horiBorderDist-|";
    NSString *vfl2 = @"|-horiBorderDist-[passwdField(usernameField)]-horiBorderDist-|";
    NSString *vfl3 = @"|-horiBorderDist-[btn]-8-[touchIdBtn(btn)]-horiBorderDist-|";
    NSString *vfl4 = @"V:|-vertiBorderDist-[usernameField]-16-[passwdField(usernameField)]-16-[btn(40)]";
    NSString *vfl5 = @"V:[passwdField]-16-[touchIdBtn(40)]";
    for (NSString *tmpVFL in @[vfl1, vfl2, vfl3, vfl4, vfl5]) {
        [loginView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:tmpVFL options:0 metrics:metrics views:views]];
    }
    
    [self.view addSubview:loginView];
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
