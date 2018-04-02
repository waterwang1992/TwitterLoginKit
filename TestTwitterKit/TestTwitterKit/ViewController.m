//
//  ViewController.m
//  TestTwitterKit
//
//  Created by Clarence on 2018/3/23.
//  Copyright © 2018年 Clarence. All rights reserved.
//

#import "ViewController.h"
#import "TWTRKit.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"------%ld", [Twitter sharedInstance].sessionStore.existingUserSessions.count);
    
    [[Twitter sharedInstance]  logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error1) {
        
        if (error1) {
            return ;
        }
        [[TWTRAPIClient clientWithCurrentUser] loadUserWithID:session.userID completion:^(TWTRUser * _Nullable user, NSError * _Nullable error2) {
            if (!error2) {
                if (user) {
                    NSLog(@"头像url:%@",user.profileImageURL);
                }else{
                    NSLog(@"error:%@",error2.localizedDescription);
                }
            }
            [[TWTRAPIClient clientWithCurrentUser] requestEmailForCurrentUser:^(NSString * _Nullable email, NSError * _Nullable error3) {
                if (!error3) {
                    NSLog(@"email error: %@", error3);
                }else{
                    NSLog(@"-----email: %@", email);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (TWTRSession *aSession in [Twitter sharedInstance].sessionStore.existingUserSessions) {
                        NSString *sessionUserId = aSession.userID;
                        [Twitter.sharedInstance.sessionStore logOutUserID:sessionUserId];
                        NSLog(@"logout %@", sessionUserId);
                    }
                    NSLog(@"complete");
                });
                
            }];
            
        }];
    }];
}


@end
