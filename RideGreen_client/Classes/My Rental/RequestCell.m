//
//  RequestCell.m
//  ridegreen
//
//  Created by Ridegreen on 29/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "EXPhotoViewer.h"
#import "RequestCell.h"

@implementation RequestCell

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
    [_cilentInfoBtn release];
    [_rejectBtn release];
    [_acceptBtn release];
    [_roomImgView release];
    [_imgBtn release];
    [_roomType release];
    [_checkInOutBtn release];
    [_checkInOutBg release];
    [_checkinDateLabel release];
    [super dealloc];
}
@end
