//
//  BrowseViewController.h
//  AquBuy
//
//  Created by Aaron on 17/01/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestTableViewCell.h"

@interface BrowseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    IBOutlet UITextField *searchBar;
    IBOutlet UIButton *closeSearch;
    
}

@property (strong,nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSArray *categories;

@end
