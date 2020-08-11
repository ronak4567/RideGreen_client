//
//  RWInventoryCell.h
//  RWPuppies
//
//  Created by Pietro Rea on 12/24/12.
//  Copyright (c) 2012 Pietro Rea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWInventoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *puppyImageView;
@property (strong, nonatomic) IBOutlet UILabel *puppyName;
@property (strong, nonatomic) IBOutlet UILabel *puppyBreed;

@end
