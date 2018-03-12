//
//  FavouritesViewController.h
//  AquBuy
//
//  Created by Aaron on 17/01/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "TestTableViewCell.h"

@interface FavouritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    Model *model;
    NSMutableArray *favourites;
    NSMutableArray *tempArray;
    
    IBOutlet UISegmentedControl *segementControl;
    UIBarButtonItem *edit;
    
}

@property (strong,nonatomic) IBOutlet UITableView *table;

@end
