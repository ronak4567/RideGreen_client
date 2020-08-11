//
//  FindRoomCell.m
//  ridegreen
//
//  Created by Ridegreen on 30/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "EXPhotoViewer.h"

#import "FindRoomCell.h"

@implementation FindRoomCell

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
    [_roomTypeView release];
    [_roomTypeLabel release];
    [_priceView release];
    [_bgView release];
    [super dealloc];
}
@end
