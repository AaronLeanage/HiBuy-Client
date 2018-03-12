//
//  Model.h
//  AquBuy
//
//  Created by Aaron on 15/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Model : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

-(NSArray *)PostQuery:(NSString *)SQL;
-(NSArray *)postImage:(UIImage *)image;
-(UIImage *)getImage:(NSString *)imageID;

-(void)showAlert:(NSString *)title withMessage:(NSString *)message withAction:(int )actionID sender:(id)sender;

@end
