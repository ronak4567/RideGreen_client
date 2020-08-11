//
//  TourCell.m
//  ridegreen
//
//  Created by Ridegreen on 01/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "TourCell.h"

@implementation TourCell

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
    [_btn_DriverInfo release];
    [super dealloc];
}
@end
