//
//  BrowseViewController.m
//  AquBuy
//
//  Created by Aaron on 17/01/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "BrowseViewController.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController

@synthesize table;
@synthesize categories;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    table.delegate = self;
    table.dataSource = self;
    [searchBar setDelegate:self];
    
    categories = @[@"Books and Magazines", @"Business, Industry and Science", @"Clothes, Shoes and Watches", @"Collectibles and Art", @"Electronics and Computers", @"Handmade", @"Health and Beauty", @"Home, Garden, Pets and DIY", @"Motors", @"Movies, TV, Music and Games", @"Sports, Hobbies and Leisure", @"Toys, Children and Baby", @"Other"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    //Set navigation items every time view is on screen
    [self.tabBarController.navigationItem setTitle:@"Browse/Search"];
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

#pragma mark Search methods

-(IBAction)searchBarPressed:(id)sender{
    //Resize subviews
    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, 314, searchBar.frame.size.height)];
    [table setFrame:CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, 343)];
}

-(IBAction)searchClosePressed:(id)sender{
    //Resize subviews and close keyboard
    [searchBar setFrame:CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, 343, searchBar.frame.size.height)];
    [table setFrame:CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, 596)];
    [searchBar resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"SELECT * FROM listings WHERE title LIKE '%%%@%%'", searchBar.text] forKey:@"SQLQuery"]; //%% in String = '%'
    [self performSegueWithIdentifier:@"resultsScreen" sender:self];
    return NO;
}

#pragma mark table delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"listing";
    
    TestTableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    tableView.rowHeight = 55;
    
    if (cell == nil) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell updateCellWithTitle:@"" category:[categories objectAtIndex:indexPath.row] location:@"" timeLeft:@"" andPhoto:NULL];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *itemSelected = [categories objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"SELECT * FROM listings WHERE category = '%@'", itemSelected] forKey:@"SQLQuery"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"resultsScreen" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
