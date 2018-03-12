//
//  UserProfileViewController.m
//  AquBuy
//
//  Created by Aaron on 17/01/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [[Model alloc] init];
    
    //Add FaceBook login button
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [loginButton setFrame:CGRectMake(174, 223, loginButton.frame.size.width, loginButton.frame.size.height)];
    [self.view addSubview:loginButton];
    
    //TabBar customisations
    [[UITabBar appearance] setBarTintColor:[UIColor orangeColor]];
    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:180.0/255.0 green:60.0/255.0 blue:40.0/255.0 alpha:1.0]];
    
    //Navigation Bar customisations
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:180.0/255.0 green:60.0/255.0 blue:40.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    
    //Create navigation buttons
    new = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newListing)];
    
    //Profile labels at top of screen
    NSArray *profile = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentProfile"];
    profileID.text = [profile objectAtIndex:0];
    name.text = [profile objectAtIndex:1];
    email.text = [profile objectAtIndex:2];
    
    //Profile Picture from FaceBook
    FBSDKProfilePictureView *profilePictureView = [[FBSDKProfilePictureView alloc] init];
    profilePictureView.frame = CGRectMake(15,110,150,150);
    profilePictureView.profileID = [[FBSDKAccessToken currentAccessToken] userID];
    [self.view addSubview:profilePictureView];
    
    //Initialise Location Manager
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
     //ITERATE OVER Purchased User Default AND check if items that have been bid on have ended. If they have, and they are the winner, force to pay. If loser, tell them sorry but they missed out.
     
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"purchased"]];
    for (id object in [[NSUserDefaults standardUserDefaults] objectForKey:@"purchased"]){
        NSDictionary *realItem = [[model PostQuery:[NSString stringWithFormat:@"SELECT * FROM listings WHERE ListingID = %@", object]] objectAtIndex:0];
        
        if ([[realItem objectForKey:@"timePosted"] intValue] + 432000 < (int)[[NSDate date] timeIntervalSince1970]){
            //Listing has expired
            NSLog(@"%@ : %@", [realItem objectForKey:@"currentBidder"], [profile objectAtIndex:0]);
            if ([profileID.text isEqualToString: [NSString stringWithFormat:@"%@",[realItem objectForKey:@"currentBidder"]]]){
                //User has won
                [[NSUserDefaults standardUserDefaults] setFloat:[[realItem objectForKey:@"currentBid"] floatValue] forKey:@"amountToPay"];
                [[NSUserDefaults standardUserDefaults] setObject:object forKey:@"tempStorage"];
                [[NSUserDefaults standardUserDefaults] setObject:@"buyer" forKey:@"paymentUser"];
                [model showAlert:@"You won the bid!" withMessage:[realItem objectForKey:@"title"] withAction:1 sender:self];
                [tempArr removeObject:object];
            }
            else {
                //User has not won
                [model showAlert:@"You did not win the Bid" withMessage:[realItem objectForKey:@"title"] withAction:0 sender:self];
                [tempArr removeObject:object];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempArr forKey:@"purchased"];
    
    //ITERATE OVER Selling User Default AND check if items that were listed have ended. If they have, and user has not paid, tell them we are awaiting payment. If they have paid, force to pay 5% fee.
    
    tempArr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"selling"]];
    for (id object in [[NSUserDefaults standardUserDefaults] objectForKey:@"selling"]){
        NSDictionary *realItem = [[model PostQuery:[NSString stringWithFormat:@"SELECT * FROM listingStatus WHERE ListingID = %@", object]] objectAtIndex:0];
        
        if ([[realItem objectForKey:@"timePosted"] intValue] + 432000 < (int)[[NSDate date] timeIntervalSince1970]){
            //Listing has expired
            if ([[realItem objectForKey:@"hasBeenPaid"] integerValue] == 0){
                //Buyer has not yet paid
                [model showAlert:@"Your item sold but the buyer has not yet paid." withMessage:[realItem objectForKey:@"title"] withAction:0 sender:self];
            }
            else if ([[realItem objectForKey:@"hasBeenPaid"] integerValue] == 1 && [[realItem objectForKey:@"hasFeePaid"] integerValue] == 0){
                //Buyer has paid but seller has not paid fee
                float amount = ([[[[model PostQuery:[NSString stringWithFormat:@"SELECT * FROM listings WHERE ListingID = %@", object]] objectAtIndex:0] objectForKey:@"currentBid"] floatValue] /10 /2);
                NSLog(@"amount:%.2f", amount);
                [[NSUserDefaults standardUserDefaults] setFloat:amount forKey:@"amountToPay"];
                [[NSUserDefaults standardUserDefaults] setObject:object forKey:@"tempStorage"];
                [[NSUserDefaults standardUserDefaults] setObject:@"seller" forKey:@"paymentUser"];
                [model showAlert:@"Your item sold and the buyer has paid. Time to pay the 5% fee." withMessage:[realItem objectForKey:@"title"] withAction:1 sender:self];
                [tempArr removeObject:object];
            }
        }
    }
}

-(void)newListing{
    [self.navigationController performSegueWithIdentifier:@"newListing" sender:self.navigationController];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    //Set navigation items every time view is on screen
    [self.tabBarController.navigationItem setTitle:@"Your Profile"];
    self.tabBarController.navigationItem.rightBarButtonItem = new;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [locationManager stopUpdatingLocation];
    currentLocation = [locations objectAtIndex:0];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){[locationManager startUpdatingLocation];}
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSLog(@"Current Location: %@", placemark.locality);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", placemark.locality] forKey:@"currentLocation"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
