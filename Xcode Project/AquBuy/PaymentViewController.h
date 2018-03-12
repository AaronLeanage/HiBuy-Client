//
//  PaymentViewController.h
//  AquBuy
//
//  Created by Aaron on 11/03/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Model.h"

@interface PaymentViewController : UIViewController <WKUIDelegate> {
    
    IBOutlet WKWebView *webView;
    Model *model;
}

@end
