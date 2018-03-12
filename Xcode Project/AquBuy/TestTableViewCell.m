//
//  TestTableViewCell.m
//  AquBuy
//
//  Created by Aaron on 21/02/2018.
//  Copyright © 2018 MonkeyMoon Apsp. All rights reserved.
//

#import "TestTableViewCell.h"

@implementation TestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateCellWithTitle:(NSString *)title category:(NSString *)category location:(NSString *)location timeLeft:(NSString *)timeLeft andPhoto:(UIImage *)photo{
    
    self.lisTitle.text = title;
    self.category.text = category;
    self.location.text = location;
    self.timeLeft.text = timeLeft;
    self.photo.image = photo;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
