//
//  RWCheckoutCell.h
//  RWPuppies
//
//  Created by Pietro Rea on 12/25/12.
//  Copyright (c) 2012 Pietro Rea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWCheckoutPuppyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *puppyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *puppyBreedLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
