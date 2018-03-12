//
//  FeedViewController.h
//  AquBuy
//
//  Created by Aaron on 17/01/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestTableViewCell.h"
#import "Model.h"

@interface FeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    Model *model;
    NSMutableArray *json;
    UIBarButtonItem *refresh;

}

@property (strong,nonatomic) IBOutlet UITableView *table;

@end
