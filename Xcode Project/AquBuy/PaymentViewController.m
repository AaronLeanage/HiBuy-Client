//
//  PaymentViewController.m
//  AquBuy
//
//  Created by Aaron on 11/03/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Got here");
    
    model = [[Model alloc] init];
    
    float amount = [[NSUserDefaults standardUserDefaults] floatForKey:@"amountToPay"];
    NSString *URL = [NSString stringWithFormat:@"http://paypal.me/THudson786/%.2f", amount];
    
    NSLog(@"%@", URL);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    webView.UIDelegate = self;
    [webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
    [webView loadRequest:urlRequest];

}

//This method is called when the URL changes
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context{

    if ([[NSString stringWithFormat:@"%@", [change valueForKey:@"new"]] isEqualToString:@"https://www.paypal.com/myaccount/"]){
        //Update on server to make the seller pay the fee
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"paymentUser"]  isEqual: @"buyer"]){
            [model PostQuery:[NSString stringWithFormat:@"UPDATE listingStatus SET hasBeenPaid = '1' WHERE ListingID = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"tempStorage"]]];
        }
        //Update on server so that payment akerts stop
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"paymentUser"]  isEqual: @"seller"]){
            [model PostQuery:[NSString stringWithFormat:@"UPDATE listingStatus SET hasFeePaid = '1' WHERE ListingID = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"tempStorage"]]];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
