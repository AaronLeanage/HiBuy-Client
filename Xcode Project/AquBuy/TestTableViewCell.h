//
//  TestTableViewCell.h
//  AquBuy
//
//  Created by Aaron on 21/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTableViewCell : UITableViewCell

@property (strong, nonnull) IBOutlet UIImageView *photo;
@property (strong, nonnull) IBOutlet UILabel *lisTitle;
@property (strong, nonnull) IBOutlet UILabel *category;
@property (strong, nonnull) IBOutlet UILabel *location;
@property (strong, nonnull) IBOutlet UILabel *timeLeft;

-(void)updateCellWithTitle:(NSString *_Nullable)title category:(NSString *_Nullable)category location:(NSString *_Nullable)location timeLeft:(NSString *_Nullable)timeLeft andPhoto:(UIImage *_Nullable)photo;

@end
