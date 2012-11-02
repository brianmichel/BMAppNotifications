//
//  SweetDisplayCell.m
//  MLNotifications
//
//  Created by Brian Michel on 11/2/12.
//  Copyright (c) 2012 Foureyes. All rights reserved.
//

#import "SweetDisplayCell.h"

@implementation SweetDisplayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      self.textLabel.adjustsFontSizeToFitWidth = YES;
      self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
      UIImageView *bubble = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ImageBubbleUntailed-Blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 21, 16, 21)]];
      self.backgroundView = bubble;
      self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
