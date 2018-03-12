//
//  DataTestViewController.h
//  AquBuy
//
//  Created by Aaron on 15/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface DataTestViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
    
    Model *model;
    IBOutlet UITextField *input;
    IBOutlet UITextView *output;
    
    IBOutlet UIImageView *imageView;
    IBOutlet UITextField *imageID;
    
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
