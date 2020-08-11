//
//  AvailableDriverCell.m
//  ridegreen
//
//  Created by Ridegreen on 31/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "AvailableDriverCell.h"

@implementation AvailableDriverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)driverImgBtnPressed:(id)sender 
{
    if (_isImage)
    {
     [EXPhotoViewer showImageFrom:self.driverImageView];
    }
    
    
}
- (void)dealloc {
    [_bgView release];
    [super dealloc];
}
@end
