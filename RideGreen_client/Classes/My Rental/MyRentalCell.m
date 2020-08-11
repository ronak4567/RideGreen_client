//
//  MyRentalCell.m
//  ridegreen
//
//  Created by Ridegreen on 28/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "EXPhotoViewer.h"
#import "MyRentalCell.h"

@implementation MyRentalCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onButtonTUI:(id)sender {
    if (_isImage)
    {
        [EXPhotoViewer showImageFrom:self.roomImgView];
    }

}

- (void)dealloc {
    
    [_roomImgView release];
    [_imgBtn release];
    [_roomType release];
    [super dealloc];
}
@end
