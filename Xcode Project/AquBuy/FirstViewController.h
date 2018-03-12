//
//  FirstViewController.h
//  AquBuy
//
//  Created by Aaron on 06/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Model.h"

@interface FirstViewController : UIViewController{
    
    IBOutlet UIImageView *appicon;
    Model *model;
    FBSDKLoginButton *loginButton;
    
}

@end
