//
//  AddListingViewController.m
//  AquBuy
//
//  Created by Aaron on 18/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "AddListingViewController.h"

@interface AddListingViewController ()

@end

@implementation AddListingViewController


-(IBAction)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)dismissKeyboard:(id)sender{
    [lisTitle resignFirstResponder];
    [description resignFirstResponder];
}

-(IBAction)post:(id)sender{
    NSLog(@"%@", picture.image);
    if (![lisTitle.text  isEqual: @""] && ![category.text  isEqual: @""] && ![description.text  isEqual: @""] && picture.image != nil) {
    
        NSString *seller = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentProfile"] objectAtIndex:0];
        float currentBid = 0.00;
        NSString *currentBidder = NULL;
        NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocation"];
        int timePosted = (int)[[NSDate date] timeIntervalSince1970];
    
        [model PostQuery:[NSString stringWithFormat:@"INSERT INTO listings (seller, location, currentBid, currentBidder, title, category, description, timePosted) VALUES ('%@', '%@', '%f', '%@', '%@', '%@', '%@', '%d');", seller, location, currentBid, currentBidder, lisTitle.text, category.text, description.text, timePosted]];
        [model PostQuery:[NSString stringWithFormat:@"INSERT INTO listingStatus (seller) VALUES ('%@')", seller]];
        
        [model postImage:picture.image];
        
        NSArray *listing = [model PostQuery:[NSString stringWithFormat:@"SELECT ListingID FROM listings WHERE timePosted = '%d' AND seller = %@", timePosted, seller]];
        NSMutableArray *selling = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"selling"]];
        [selling addObject:[[listing objectAtIndex:0] objectForKey:@"ListingID"]];
        [[NSUserDefaults standardUserDefaults] setObject:selling forKey:@"selling"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else {
        [model showAlert:@"Required Fields" withMessage:@"Please fill in all the fields and take a photo before posting." withAction:0 sender:self];
    }
    
}

-(IBAction)takePicture:(id)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if (TARGET_IPHONE_SIMULATOR){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else{
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"postedBefore"] == NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"postedBefore"];
        [model showAlert:@"Mini Agreement" withMessage:@"By listing on HiBuy you agree to the following:\n\n1) Your listing is a real item that you own or have permission to sell.\n2) The item is not illegal to sell \n3) Your listing will be accurate to the item. \n4) You agree to give HiBuy 5% of the final price." withAction:0 sender:self];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //Initialise the model class
    model = [[Model alloc] init];
    
    NSMutableArray *categories = [[NSMutableArray alloc] initWithArray:@[@"Books and Magazines", @"Business, Industry and Science", @"Clothes, Shoes and Watches", @"Collectibles and Art", @"Electronics and Computers", @"Handmade", @"Health and Beauty", @"Home, Garden, Pets and DIY", @"Motors", @"Movies, TV, Music and Games", @"Sports, Hobbies and Leisure", @"Toys, Children and Baby", @"Other"]];
    dropDown = [[DownPicker alloc] initWithTextField:category withData:categories];
}

-(UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect: CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Here");
    [self dismissViewControllerAnimated:YES completion:nil];
    image = [info valueForKey:UIImagePickerControllerOriginalImage];
    picture.image = [self resizeImage:image scaledToSize:CGSizeMake(250, 250)];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
