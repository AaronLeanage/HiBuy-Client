//
//  FirstViewController.m
//  AquBuy
//
//  Created by Aaron on 06/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    appicon.layer.cornerRadius = 30;
    
    //Initialise the model class
    model = [[Model alloc] init];
    
    //Add FaceBook login button
    loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [loginButton setFrame:CGRectMake(loginButton.frame.origin.x, 510, loginButton.frame.size.width, loginButton.frame.size.height)];
    loginButton.readPermissions = @[@"public_profile", @"email"];
    [self.view addSubview:loginButton];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self performSelector:@selector(afterPresented) withObject:nil afterDelay:0.1];
}

-(void)afterPresented{
    //Check if already logged into FaceBook (from prior app launch)
    if ([FBSDKAccessToken currentAccessToken]) {
        //User is logged in
        loginButton.hidden = YES;
        
        //Get user data to put into database
        __block NSString *email;
        __block NSString *name;
        __block NSString *userid;
        __block int flags = 0;
        [FBSDKProfile loadCurrentProfileWithCompletion: ^(FBSDKProfile *profile, NSError *error) {
            name = profile.name;
            userid = profile.userID;
            flags += 1;
            NSLog(@"%@, %@", profile.name, profile.userID);
        }];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"user:%@", result);
                 email = [result objectForKey:@"email"];
                 flags += 1;
             }
             NSLog(@"%@", error);
         }];
        
        while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && flags != 2){}
        NSLog(@"%@ %@ %@", email, name, userid);
        [model PostQuery:[NSString stringWithFormat:@"INSERT INTO users (FBid, fullName, email) VALUES ('%@', '%@', '%@')", userid, name, email]];
        [[NSUserDefaults standardUserDefaults] setObject:@[userid, name, email] forKey:@"currentProfile"];
        [self performSegueWithIdentifier:@"loggedin" sender:self];
    }
    
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
