//
//  DriverCell.m
//  ridegreen
//
//  Created by Ridegreen on 20/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "DriverCell.h"

@implementation DriverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)carBtnPReesed:(id)sender 
{
    //[EXPhotoViewer showImageFrom:self.carImageView];

}

- (IBAction)DriverImageBtnPressed:(id)sender 
{
///[EXPhotoViewer showImageFrom:self.driverImageView];

}
- (void)dealloc {
    [_lbl_AvailableSeats release];
    [super dealloc];
}
@end
