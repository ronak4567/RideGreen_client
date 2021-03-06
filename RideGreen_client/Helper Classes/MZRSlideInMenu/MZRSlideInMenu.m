//
//  MZRSlideInMenu.m
//  MZRSlideInMenu
//
//  Created by Morita Naoki on 2014/01/21.
//  Copyright (c) 2014年 molabo. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MZRSlideInMenu.h"

static const CGFloat kMenuItemBarHeight = 40.0;
static const CGFloat kMenuItemBarGap = 20.0;

static const CGFloat kMenuItemLabelMarginTop = 65.0;
static const CGFloat kMenuItemLabelMarginBottom = 4.0;
static const CGFloat kMenuItemLabelMarginLeft = 14.0;
static const CGFloat kMenuItemLabelMarginRight = 0.0;
static const CGFloat kDelayInterval = 0.02;
static const CGFloat kAnimationDuration = 0.15;
static const CGFloat kBackgroundAlpha =1.0;

static const NSUInteger kMenuItemTagBase = 100;

typedef NS_ENUM (NSUInteger, MenuDirection)
{
    MenuDirectionRight,
    MenuDirectionLeft
};

@interface MZRMenuItem : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) UIColor *textColor;
@property (copy, nonatomic) UIColor *backgroundColor;
@property (copy, nonatomic) UIImage *backgroundimage;
@end

@implementation MZRMenuItem


@end

@interface MZRSlideInMenu ()
@property (strong, nonatomic) UIScrollView *view;
@property (strong, nonatomic) NSMutableArray *menuItems;
@property (strong, nonatomic) NSMutableArray *menuButtons;
@property (assign, nonatomic) MenuDirection menuDirection;
@end

@implementation MZRSlideInMenu
CGFloat kMenuItemMarginBottom = 120.0;
+ (void)removeMenu {
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isMemberOfClass:[MZRSlideInMenu class]]) {
            [view removeFromSuperview];
            
        }
        
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        if (isiPhone4) {
            
            kMenuItemMarginBottom = kMenuItemBarHeight *1 -10;
        }
        else if (isiPhone5)
        {
            kMenuItemMarginBottom = kMenuItemBarHeight *2; 
            
        }
        else if (isiPhone6)
        {
            kMenuItemMarginBottom = kMenuItemBarHeight *3; 
            
        }
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        
        _menuItems   = @[].mutableCopy;
        _menuButtons = @[].mutableCopy;
        
        self.backgroundColor = [UIColor clearColor];
        _bgImageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-10, 0.0, self.frame.size.width/2 +10, self.frame.size.height)]; 
        [_bgImageview setImage:[UIImage imageNamed:@"faulltoo.png"]];
        [_bgImageview setAlpha:0.75];
        [self addBgShadowTo:_bgImageview];
        [self addSubview:_bgImageview];
        self.view = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        
        [self setMenuBackgroundColor:[UIColor clearColor]];
        self.view.alpha = 0.0;
        self.view.alwaysBounceVertical = YES;
        [self addSubview:self.view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouched)];
        [self addGestureRecognizer:tapGesture];
        self.dismissOnBackgroundTouch = YES;
        
        self.horizontalTransitionEffect = kAnimationDuration;
        self.buttonInsertDelay = kDelayInterval;
        self.closeMenuOnSelection = YES;
        
    }
    return self;
}

- (void)setMenuBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
    
}

- (void)addMenuItemWithTitle:(NSString *)title {
    [self addMenuItemWithTitle:title textColor:nil backgroundColor:nil backgroundImage:nil];
}

- (void)addMenuItemWithTitle:(NSString *)title textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor backgroundImage :(UIImage *)backgroundImage {
    MZRMenuItem *menuItem = [[MZRMenuItem alloc] init];
    menuItem.title = title;
    menuItem.textColor = textColor;
    menuItem.backgroundColor = backgroundColor;
    menuItem.backgroundimage = backgroundImage;
    [menuItem setBackgroundimage:backgroundImage];
    [self.menuItems addObject:menuItem];
}

- (void)showMenuFromRight {
    self.menuDirection = MenuDirectionRight;
    [self showMenu];
}

- (void)showMenuFromLeft {
    self.menuDirection = MenuDirectionLeft;
    [self showMenu];
}

- (void)showMenu {
    
    [UIView animateWithDuration:self.horizontalTransitionEffect animations:^{
        self.view.alpha = kBackgroundAlpha;
    }];
    
    for (int i = 0; i < self.menuItems.count; i++) {
        CGFloat itemBarHeight = kMenuItemBarHeight;
        if (self.itemBarHeight) {
            itemBarHeight = self.itemBarHeight;
        }
        
        CGFloat itemBarGap = kMenuItemBarGap;
        if (self.itemBarGap) {
            itemBarGap = self.itemBarGap;
        }
        
        CGFloat y = CGRectGetHeight(self.frame) - kMenuItemMarginBottom - itemBarHeight * (i + 1) - itemBarGap * i;
        
        MZRMenuItem *menuItem = self.menuItems[self.menuItems.count - i - 1];
        NSString *title = menuItem.title;
        UIColor *itemTextColor = menuItem.textColor;
        UIColor *itemBackgroundColor = menuItem.backgroundColor;
        
        UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        if (self.font) {
            labelFont = self.font;
        }
        
        UIColor *textColor = [UIColor colorWithRed:52 / 255.0 green:152 / 255.0 blue:219 / 25.0 alpha:1.0];
        if (itemTextColor) {
            textColor = itemTextColor;
        }
        else if (self.textColor) {
            textColor = self.textColor;
        }
        
        UIColor *buttonBackgroundColor = [UIColor whiteColor];
        UIImage *buttonBackgroundImage = menuItem.backgroundimage;
        if (itemBackgroundColor) {
            buttonBackgroundColor = itemBackgroundColor;
        }
        else if (self.buttonBackgroundColor) {
            buttonBackgroundColor = self.buttonBackgroundColor;
        }
        
        CGSize labelSize = [title sizeWithAttributes:@{ NSFontAttributeName:labelFont }];
        CGSize menuSize = CGSizeMake(labelSize.width + kMenuItemLabelMarginLeft + kMenuItemLabelMarginRight,
                                     labelSize.height + kMenuItemLabelMarginTop + kMenuItemLabelMarginBottom);
        
        CGFloat x = 0.0;
        if (self.menuDirection == MenuDirectionRight) {
            x = CGRectGetWidth(self.frame)-10;
        }
        else if (self.menuDirection == MenuDirectionLeft) {
            x = -menuSize.width;
        }
        
        CGRect labelRect = CGRectMake(10.0, 10.0, 160, labelSize.height);
        CGRect menuRect = CGRectMake(x, y,170, itemBarHeight);
        
        UILabel *menuLabel = [[UILabel alloc] initWithFrame:labelRect];
        [menuLabel setBackgroundColor:[UIColor clearColor]];
        [menuLabel setFont:labelFont];
        [menuLabel setTextColor:textColor];
        [menuLabel setText:title];
        [menuLabel setTextAlignment:NSTextAlignmentLeft];
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setFrame:menuRect];
        [menuButton setTag:kMenuItemTagBase + self.menuItems.count - i - 1];
        [menuButton setBackgroundColor:buttonBackgroundColor];
        [menuButton setImage:buttonBackgroundImage forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addShadowTo:menuButton];
        [self.view addSubview:menuButton];
        
        //menuLabel.center = CGPointMake(CGRectGetWidth(menuButton.frame) / 2, CGRectGetHeight(menuButton.frame) / 2);
        [menuButton addSubview:menuLabel];
        //        menuButton.layer.borderColor = buttonBackgroundColor.CGColor;
        //        menuButton.layer.borderWidth = 2.0f;
        //        menuButton.layer.cornerRadius = 12.f;
        [self.menuButtons addObject:menuButton];
        
        CGFloat delay = self.buttonInsertDelay * i;
        
        CGFloat newX = 0.0;
        if (self.menuDirection == MenuDirectionRight) {
            newX = CGRectGetWidth(self.frame) - CGRectGetWidth(menuButton.frame) +9;
        }
        else if (self.menuDirection == MenuDirectionLeft) {
            newX = 0.0;
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [UIView animateWithDuration:self.horizontalTransitionEffect delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect newFrame = CGRectMake(newX,
                                         CGRectGetMinY(menuButton.frame),
                                         CGRectGetWidth(menuButton.frame),
                                         CGRectGetHeight(menuButton.frame));
            [menuButton setFrame:newFrame];
        } completion:nil];
    }
}
-(void)addShadowTo:(UIButton *)menuButton
{
    menuButton.layer.cornerRadius = 8.0f;
    menuButton.layer.masksToBounds = NO;
    menuButton.layer.shadowOpacity = 0.8;
    menuButton.layer.shadowRadius = 12;
    menuButton.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
}
-(void)addBgShadowTo:(UIImageView *)bgImg
{
    bgImg.layer.cornerRadius = 8.0f;
    bgImg.layer.masksToBounds = NO;
    bgImg.layer.shadowOpacity = 0.8;
    bgImg.layer.shadowRadius = 12;
    bgImg.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
}
- (void)menuButtonTapped:(UIButton *)button {
    !self.closeMenuOnSelection ?: [self closeMenu];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideInMenu:didSelectAtIndex:)]) {
        [self.delegate slideInMenu:self didSelectAtIndex:button.tag - kMenuItemTagBase];
    }
}

- (void)closeMenu {
    [UIView animateWithDuration:self.horizontalTransitionEffect delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.alpha = 0.0;
    } completion:nil];
    
    if (self.menuButtons.count == 0) {
        return;
    }
    
    for (int i = 0; i < self.menuButtons.count; i++) {
        UIButton *menuButton = self.menuButtons[i];
        
        CGFloat delay = self.buttonInsertDelay * i;
        
        CGFloat newX = 0.0;
        if (self.menuDirection == MenuDirectionRight) {
            newX = CGRectGetWidth(self.frame);
        }
        else if (self.menuDirection == MenuDirectionLeft) {
            newX = -CGRectGetWidth(menuButton.frame);
        }
        
        [UIView animateWithDuration:self.horizontalTransitionEffect delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect newFrame = CGRectMake(newX,
                                         CGRectGetMinY(menuButton.frame),
                                         CGRectGetWidth(menuButton.frame),
                                         CGRectGetHeight(menuButton.frame));
              [menuButton setFrame:newFrame];
             [self.bgImageview setFrame:newFrame];
        } completion: ^(BOOL finished) {
            if (i == self.menuButtons.count - 1) {
                [self removeFromSuperview];
                
               
            }
        }];
    }
}

- (void)viewTouched {
    if (self.dismissOnBackgroundTouch) {
        [self closeMenu];
    }
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index {
    if (index >= self.menuItems.count) {
        return nil;
    }
    
    MZRMenuItem *menuItem = self.menuItems[index];
    return menuItem.title;
}

@end
