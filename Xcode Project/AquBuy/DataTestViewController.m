//
//  DataTestViewController.m
//  AquBuy
//
//  Created by Aaron on 15/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "DataTestViewController.h"

@interface DataTestViewController ()

@end

@implementation DataTestViewController

@synthesize listTableView;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //Initialise the model class
    model = [[Model alloc] init];
    [input becomeFirstResponder];
    
}

-(IBAction)getImage:(id)sender{
    
    //imageView.image = [model getImage:imageID.text];
    [imageView setImage:[model getImage:imageID.text]];
    
}

-(IBAction)sendSQL:(id)sender{
    output.text = [NSString stringWithFormat:@"%@", [model PostQuery:input.text]]; //Test SQL: "SELECT * FROM testtable"
    [input resignFirstResponder];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
