//
//  FeedViewController.m
//  AquBuy
//
//  Created by Aaron on 17/01/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [[Model alloc] init];
    
    refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateTableView)];
    
    table.delegate = self;
    table.dataSource = self;
    
    [self updateTableView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //Set navigation items every time view is on screen
    [self.tabBarController.navigationItem setTitle:@"Feed"];
    self.tabBarController.navigationItem.leftBarButtonItem = refresh;
    
    if (self.view.tag == 1){
        [self.navigationItem setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedCategory"]];
    }
    
}

-(void)updateTableView{
    
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocation"];
    
    //Get which view is loaded based on tag
    NSString *query = @"";
    if (self.view.tag == 0){
        query = [NSString stringWithFormat:@"SELECT * FROM listings WHERE location = '%@'", location];
    }
    else if (self.view.tag == 1) {
        query = [[NSUserDefaults standardUserDefaults] objectForKey:@"SQLQuery"];
    }
    
    json = [[NSMutableArray alloc] initWithArray:[model PostQuery:query]];
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:json];
    //Iterate over all listings in the JSON and remove the ones where the time is past the 5 day (432000 seconds) selling limit
    for (id object in tempArray) {
        if ([[object objectForKey:@"timePosted"] intValue] + 432000 < (int)[[NSDate date] timeIntervalSince1970]){
            [json removeObject:object];
        }
    }
    
    [table reloadData];
    NSLog(@"JSON: %@", json);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return json.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"listing";
    
    TestTableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    tableView.rowHeight = 100;
    
    if (cell == nil) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //Set Labels on cell
    NSDictionary *currentItem = [json objectAtIndex:indexPath.row];
    
    //Get time posted (since unix time epoch), add 5 days, convert to NSDate for use (timeEnding contains the date and time it ends.)
    NSDate *timeEnding = [NSDate dateWithTimeIntervalSince1970:[[currentItem objectForKey:@"timePosted"] intValue] + 432000];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d, h:mm:ss a"]; //Format of: "Mar 7, 9:18:18 pm"
    
    //Get item photo
    UIImage *image = [model getImage:[currentItem objectForKey:@"ListingID"]];
    
    [cell updateCellWithTitle:[currentItem objectForKey:@"title"] category:[currentItem objectForKey:@"category"] location:[currentItem objectForKey:@"location"] timeLeft:[NSString stringWithFormat:@"%@", [dateFormat stringFromDate:timeEnding]] andPhoto:image];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemSelected = [json objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:itemSelected forKey:@"selectedItem"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hideBidButton"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"itemDetail" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
