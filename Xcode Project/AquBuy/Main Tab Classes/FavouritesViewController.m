//
//  FavouritesViewController.m
//  AquBuy
//
//  Created by Aaron on 17/01/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "FavouritesViewController.h"

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController

@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [[Model alloc] init];
    
    [segementControl setSelectedSegmentIndex:0];
    
    //Create navigation buttons
    edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:nil];
    table.delegate = self;
    table.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self updateTableView];
    
    //Set navigation items every time view is on screen
    [self.tabBarController.navigationItem setTitle:@"Favourites"];
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

-(IBAction)segmentChanged:(id)sender{[self updateTableView];}

-(void)updateTableView{
    
    favourites = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favourites"]];
    
    
    tempArray = [[NSMutableArray alloc] initWithArray:favourites];
    
    if ([segementControl selectedSegmentIndex] == 0){//User looking at active listings
        //Iterate and remove listings where they are inactive (time ending is in past)
        for (id object in favourites) {
            if ([[object objectForKey:@"timePosted"] intValue] + 432000 < (int)[[NSDate date] timeIntervalSince1970]){
                [tempArray removeObject:object];
            }
        }
    }
    
    else {//User looking at inactive listings
        //Iterate and remove listings where they are active (time ending is in future)
        for (id object in favourites) {
            if ([[object objectForKey:@"timePosted"] intValue] + 432000 >= (int)[[NSDate date] timeIntervalSince1970]){
                [tempArray removeObject:object];
            }
        }
    }
    
    [table reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tempArray.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Deleted row
        [favourites removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:favourites forKey:@"favourites"];
        [self updateTableView];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"listing";
    
    TestTableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    tableView.rowHeight = 100;
    
    if (cell == nil) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //Set Labels on cell
    NSDictionary *currentItem = [tempArray objectAtIndex:indexPath.row];
    
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
    NSDictionary *itemSelected = [tempArray objectAtIndex:indexPath.row];
    //If expired, tell detail view not to show bid button
    if ([segementControl selectedSegmentIndex] == 1){
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hideBidButton"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hideBidButton"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:itemSelected forKey:@"selectedItem"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"itemDetail" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
