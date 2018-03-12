//
//  Model.m
//  AquBuy
//
//  Created by Aaron on 15/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "Model.h"

@implementation Model

-(NSArray *)PostQuery:(NSString *)SQL{
    //Create parameter string using the SQL to send to server
    NSString *userUpdate = [NSString stringWithFormat:@"DATA=%@&",SQL, nil];
    NSLog(@"%@", userUpdate);
    
    return [self startRequest:userUpdate toFile:@"SQLService.php"];
}

-(UIImage *)getImage:(NSString *)imageID{
    //Get the content (image) from the server at the URL using the imageID
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.236/hibuy/images/%@", imageID]];
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    //Create a data object with the string above and return it as a UIImage
    NSData *data = [[NSData alloc]initWithBase64EncodedString:content options:0];
    return [UIImage imageWithData:data];
}

-(NSArray *)postImage:(UIImage *)image{
    
    //Convert UIImage to JPEG and encode as base 64 string
    NSString *imageString = [UIImageJPEGRepresentation(image, 0.66f) base64EncodedStringWithOptions:0];
    
    //Replace '+' sign with '%2B' so the php server can interpret correctly
    NSString *imageStringForPlusSign = [imageString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];

    //Create parameter string using the SQL to send to server
    NSString *userUpdate = [NSString stringWithFormat:@"DATA=%@", imageStringForPlusSign];
    NSLog(@"%@", userUpdate);
    
    return [self startRequest:userUpdate toFile:@"IMGService.php"];
}


-(NSArray *)startRequest:(NSString *)userUpdate toFile:(NSString *)file{
    //Initialise the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set the URL to localhost or server's IP depending on whether app is running on an real device or the simulator
    if (TARGET_IPHONE_SIMULATOR){
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/hibuy/%@", file]]];
    }
    else if (TARGET_OS_IPHONE){
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.236/hibuy/%@", file]]]; //192.168.1.236
    }
    
    //Create the method as "POST" because we are sending data
    [request setHTTPMethod:@"POST"];
    
    //Apply the data to the HTML body
    [request setHTTPBody:[userUpdate dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Create URL session with server and handle response and error
    NSURLSession *session = [NSURLSession sharedSession];
    __block NSArray *json = [[NSArray alloc] init];
    __block BOOL flag = NO;
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Handle response
        NSString *echo = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"Response:%@, \nError:%@", echo, error);
        flag = YES;
    }] resume];
    
    while (!flag) {}
    return json;
}

-(void)showAlert:(NSString *)title withMessage:(NSString *)message withAction:(int)actionID sender:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (actionID == 0){
        [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    }
    else if (actionID == 1){
        [alert addAction:[UIAlertAction actionWithTitle:@"Proceed to payment" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [sender performSegueWithIdentifier:@"payment" sender:sender];
        }]];
    }
    [sender presentViewController:alert animated:YES completion:nil];
}

@end
