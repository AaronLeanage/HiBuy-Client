//
//  UserProfileViewController.h
//  AquBuy
//
//  Created by Aaron on 17/01/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Model.h"

@interface UserProfileViewController : UIViewController <CLLocationManagerDelegate>{
    
    IBOutlet UILabel *name, *profileID, *email;
    UIBarButtonItem *new;
    
    Model *model;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
}

@end
