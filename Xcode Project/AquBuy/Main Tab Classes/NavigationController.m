//
//  NavigationController.m
//  AquBuy
//
//  Created by Aaron on 17/01/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "NavigationController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface NavigationController ()

@end

@implementation NavigationController

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserverForName:FBSDKAccessTokenDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:
     ^(NSNotification *notification) {
         if (notification.userInfo[FBSDKAccessTokenDidChangeUserID]) {
             // Handle user change
             [self performSegueWithIdentifier:@"loggedout" sender:self];
         }
     }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
