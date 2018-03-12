//
//  ItemDetailViewController.m
//  AquBuy
//
//  Created by Aaron on 07/03/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Item Detail"];
    model = [[Model alloc] init];
    favourites = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favourites"]];
    
    currentItem = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedItem"]];
    
    [picture setImage:[model getImage:[currentItem objectForKey:@"ListingID"]]];
    lisTitle.text = [currentItem objectForKey:@"title"];
    description.text = [currentItem objectForKey:@"description"];
    location.text = [currentItem objectForKey:@"location"];
    category.text = [currentItem objectForKey:@"category"];
    sellerID = [currentItem objectForKey:@"seller"];
    currentBid = [[currentItem objectForKey:@"currentBid"] floatValue];
    
    //If user has already bid on item, hide the button
    for (id object in [[NSUserDefaults standardUserDefaults] objectForKey:@"purchased"]){
        if ([object isEqualToString:[currentItem objectForKey:@"ListingID"]]){
            bidButton.hidden = YES;
        }
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideBidButton"]  isEqual: @"YES"]){
        bidButton.hidden = YES;
    }
    
    isInFavourites = NO;
    for (id item in favourites){
        if ([[item objectForKey:@"ListingID"] isEqualToString:[currentItem objectForKey:@"ListingID"]]) {
            //If item is in favourites, set value
            isInFavourites = YES;
            favouritesObject = [favourites indexOfObject:item];
            [favouriteButton setImage:[UIImage imageNamed:@"cross"]];
        }
        else {
            [favouriteButton setImage:[UIImage imageNamed:@"tick"]];
        }
    }
    
}

-(IBAction)placeBid:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Place Bid" message: @"Input the amount you would like to bid:" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Amount in £";
        textField.textColor = [UIColor blueColor];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Submit Bid" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        currentBid = [[[[model PostQuery:[NSString stringWithFormat:@"SELECT currentBid FROM listings WHERE ListingID = %@", [currentItem objectForKey:@"ListingID"]]] objectAtIndex:0] objectForKey:@"currentBid"] floatValue];
        NSLog(@"Current: %f", currentBid);
        if (textFieldValue > currentBid){
            [model PostQuery:[NSString stringWithFormat:@"UPDATE listings SET currentBidder = '%@', currentBid = '%f' WHERE ListingID = %@", [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentProfile"] objectAtIndex:0], textFieldValue, [currentItem objectForKey:@"ListingID"]]];
            
            NSMutableArray *purchased = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"purchased"]];
            [purchased addObject:[currentItem objectForKey:@"ListingID"]];
            [[NSUserDefaults standardUserDefaults] setObject:purchased forKey:@"purchased"];
            [self viewDidLoad];
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

//The return on this method dictates whether or not the typed character should actually be typed
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //Separate the text field contents by the '.'
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *separated = [newString componentsSeparatedByString:@"."];
    
    BOOL returnFlag = YES;
    //If 2 items in array, there is one decimal place
    if([separated count] == 2) {
        //Set separatedString to the digits after the decimal place (object index 1)
        NSString *separatedString = [NSString stringWithFormat:@"%@", [separated objectAtIndex:1]];
        //return it only if there are 2 or less digits after the decimal
        returnFlag = [separatedString length] <= 2;
    }
    //If more than 2 items in array, user has entered another decimal so do not type
    else if ([separated count] > 2){
        returnFlag = NO;
    }
    
    if (returnFlag){
        textFieldValue = [newString floatValue];
    }
    NSLog(@"%f", textFieldValue);
    return returnFlag;
}

-(IBAction)favourites:(id)sender{
    //If is not already in favourites, add it
    if (isInFavourites){
        [favouriteButton setImage:[UIImage imageNamed:@"tick"]];
        [favourites removeObjectAtIndex:favouritesObject];
        [[NSUserDefaults standardUserDefaults] setObject:favourites forKey:@"favourites"];
        isInFavourites = NO;
    }
    else{
        [favouriteButton setImage:[UIImage imageNamed:@"cross"]];
        [favourites addObject:currentItem];
        [[NSUserDefaults standardUserDefaults] setObject:favourites forKey:@"favourites"];
        isInFavourites = YES;
    }
    
}

-(IBAction)sendEmail:(id)sender{
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mailController.mailComposeDelegate = self;
    
        NSString *email = [self getSellerEmail];
    
        [mailController setSubject:@"Item listed on HiBuy"];
        [mailController setToRecipients:[NSArray arrayWithObject:email]];
        [mailController setMessageBody:[NSString stringWithFormat:@"Hi there,\n\n I saw your listing for your %@ on HiBuy:\n\n", lisTitle.text] isHTML:NO];
    
        [self presentViewController:mailController animated:YES completion:nil];
    }
}

-(NSString *)getSellerEmail{
    NSArray *result = [model PostQuery:[NSString stringWithFormat:@"SELECT email FROM users WHERE FBid = '%@'", sellerID]];
    NSLog(@"%@", result);
    return [[result objectAtIndex:0] objectForKey:@"email"];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
