//
//  AddListingViewController.h
//  AquBuy
//
//  Created by Aaron on 18/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "DownPicker.h"

@interface AddListingViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

    Model *model;
    DownPicker *dropDown;
    
    UIImage *image;
    
    IBOutlet UITextField *lisTitle;
    IBOutlet UITextField *category;
    IBOutlet UITextView *description;
    IBOutlet UIImageView *picture;
    
}

@end
