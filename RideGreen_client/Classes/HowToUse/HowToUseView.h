//
//  HowToUseView.h
//  ridegreen
//
//  Created by Ridegreen on 23/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "AppDelegate.h"

@interface HowToUseView : UIViewController<UIScrollViewDelegate> {
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    
    BOOL pageControlBeingUsed;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) IBOutlet UIView *view1;
@property (nonatomic, retain) IBOutlet UIView *view2;
@property (nonatomic, retain) IBOutlet UIView *view3;
@property (nonatomic, retain) IBOutlet UIView *view4;
@property (nonatomic, retain) IBOutlet UIView *view5;
@property (retain, nonatomic) IBOutlet UIView *view6;
@property (retain, nonatomic) IBOutlet UIView *view7;
@property (retain, nonatomic) IBOutlet UIView *view8;

- (IBAction)changePage;
- (IBAction)buttonPressed:(id)sender;


@end
