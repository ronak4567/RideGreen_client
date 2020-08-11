//
//  PopupView.m
//  ridegreen
//
//  Created by Ridegreen on 29/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView

- (IBAction)onButtonTUI:(id)sender {
    if (_isImage) 
    {
     [EXPhotoViewer showImageFrom:self.clientImageView];   
    }
    
}

- (void)dealloc {
    [_clientImageView release];
    [_nameLabel release];
    [_phoneLabel release];
    [_callBtn release];
    [_lbl_ClientRating release];
    [_bgView release];
   
    [super dealloc];
}
@end
