//
//  UIExpandingPopoverController.m
//  ExpandingPopoverTest
//
//  Created by Alexei Baboulevitch on 2015-6-5.
//  Copyright (c) 2015 Alexei Baboulevitch. All rights reserved.
//

#import "UIExpandingPopoverController.h"
#import "UIExpandingPopoverController_Private.h"

@interface UIExpandingPopoverController ()
@end

CGRect bounds1;
CGRect bounds2;
NSTimeInterval animationTime = 0.25f;

@implementation UIExpandingPopoverController

-(void) dealloc {
    [_closedController release];
    [_openController release];
    
    [super dealloc];
}

-(id) initWithClosed:(UIViewController*)closedVC open:(UIViewController*)openVC {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _closedController = [closedVC retain];
        _openController = [openVC retain];
        _viewControllersInitialized = NO;
        
        _isOpen = NO;
        _isOpenLastUpdateView = YES; //to force update
        _isOpenLastUpdateBounds = YES; //to force update
    }
    
    return self;
}

-(void) setExpansionAnchorPoint:(CGPoint)expansionAnchorPoint {
    [self ensureInit];
    
    if (!CGPointEqualToPoint(expansionAnchorPoint, _expansionAnchorPoint)) {
        _expansionAnchorPoint = expansionAnchorPoint;
        
        self.isOpenLastUpdateBounds = !self.isOpen;
        [self updateBoundsAnimated:NO];
    }
}

-(void) setCenter:(CGPoint)center {
    [self ensureInit];
    
    if (!CGPointEqualToPoint(center, _center)) {
        _center = center;
        
        self.isOpenLastUpdateBounds = !self.isOpen;
        [self updateBoundsAnimated:NO];
    }
}

-(void) initializeViews {
    if (!self.viewControllersInitialized) {
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.view.layer.borderWidth = 5;
        self.view.layer.cornerRadius = 20;
        self.view.layer.borderColor = [[UIColor greenColor] CGColor];
        self.view.clipsToBounds = YES;
        
        bounds1 = self.closedController.view.bounds;
        bounds2 = self.openController.view.bounds;
        
        [self addChildViewController:self.closedController];
        [self addChildViewController:self.openController];
        
        [self.view addSubview:self.openController.view];
        [self.view addSubview:self.closedController.view];
        
        self.viewControllersInitialized = YES;
    }
}

-(void) ensureInit {
    self.view = self.view;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self initializeViews];
    
    [self updateViewAnimated:NO];
    [self updateBoundsAnimated:NO];
}

-(IBAction) open {
    [self ensureInit];
    
    self.isOpen = YES;
    
    [self updateViewAnimated:YES];
    [self updateBoundsAnimated:YES];
    
//    [UIView animateWithDuration:1 animations:^{
//        self.closedController.view.frame = CGRectMake(0, 0, bounds1.size.width + arc4random() % 20 - 10, bounds1.size.height + arc4random() % 20 - 10);
//    }];
    
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//        self.closedController.view.frame = CGRectMake(0, 0, bounds1.size.width + arc4random() % 20 - 10, bounds1.size.height + arc4random() % 20 - 10);
//    } completion:^(BOOL finished) {
//    }];
}

-(IBAction) close {
    [self ensureInit];
    
    self.isOpen = NO;

    [self updateViewAnimated:YES];
    [self updateBoundsAnimated:YES];
}

-(void) updateViewAnimated:(BOOL)animated {
    // TODO: animation
    
    if (self.isOpen != self.isOpenLastUpdateView) {
//        [self.openController.view removeFromSuperview];
//        [self.closedController.view removeFromSuperview];
//        
//        if (self.isOpen) {
//            [self.view addSubview:self.openController.view];
//        }
//        else {
//            [self.view addSubview:self.closedController.view];
//        }
        
        self.closedController.view.userInteractionEnabled = (self.isOpen ? NO : YES);
        self.openController.view.userInteractionEnabled = (self.isOpen ? YES : NO);
        
        [UIView animateWithDuration:animationTime animations:^{
            self.closedController.view.alpha = (self.isOpen ? 0 : 1);
            self.openController.view.alpha = (self.isOpen ? 1 : 0);
        }];
        
        self.isOpenLastUpdateView = self.isOpen;
    }
}

-(void) updateBoundsAnimated:(BOOL)animated {
    if (self.isOpen != self.isOpenLastUpdateBounds) {
        if (self.isOpen) {
            [UIView animateWithDuration:(animated ? animationTime : 0) delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect bounds = bounds2;
                self.view.frame = bounds;
                self.openController.view.frame = bounds;
                self.closedController.view.frame = bounds;
                self.view.center = CGPointMake(self.center.x + (self.view.bounds.size.width * (1 - self.expansionAnchorPoint.x) / 2.0f),
                                               self.center.y + (self.view.bounds.size.height * (1 - self.expansionAnchorPoint.y) / 2.0f));
            } completion:^(BOOL finished) {
            }];
        }
        else {
            [UIView animateWithDuration:(animated ? animationTime : 0) delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect bounds = bounds1;
                self.view.frame = bounds;
                self.openController.view.frame = bounds;
                self.closedController.view.frame = bounds;
                self.view.center = CGPointMake(self.center.x + (self.view.bounds.size.width * (1 - self.expansionAnchorPoint.x) / 2.0f),
                                               self.center.y + (self.view.bounds.size.height * (1 - self.expansionAnchorPoint.y) / 2.0f));
            } completion:^(BOOL finished) {
            }];
        }
        
        self.isOpenLastUpdateBounds = self.isOpen;
    }
}

@end
