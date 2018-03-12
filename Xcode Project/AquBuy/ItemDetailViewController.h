//
//  ItemDetailViewController.h
//  AquBuy
//
//  Created by Aaron on 07/03/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Model.h"

@interface ItemDetailViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate> {
    
    IBOutlet UIImageView *picture;
    IBOutlet UILabel *lisTitle, *location, *category;
    IBOutlet UITextView *description;
    IBOutlet UIBarButtonItem *favouriteButton;
    IBOutlet UIButton *bidButton;
    NSString *sellerID;
    
    Model *model;
    
    float currentBid;
    float textFieldValue;
    
    NSMutableArray *favourites;
    BOOL isInFavourites;
    NSInteger favouritesObject;
    NSDictionary *currentItem;
    
}

@end
