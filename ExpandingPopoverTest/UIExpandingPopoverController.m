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

-(void) initializeViews {
    if (!self.viewControllersInitialized) {
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.width = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        self.height = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        [self.view addConstraints:@[self.width, self.height]];
        
        self.view.layer.borderWidth = 5;
        self.view.layer.cornerRadius = 20;
        self.view.layer.borderColor = [[UIColor greenColor] CGColor];
        self.view.clipsToBounds = YES;
        
        bounds1 = self.closedController.view.bounds;
        bounds2 = self.openController.view.bounds;
        
        self.closedController.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.openController.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addChildViewController:self.closedController];
        [self addChildViewController:self.openController];
        
        [self.view addSubview:self.openController.view];
        [self.view addSubview:self.closedController.view];
        
        void (^fullscreenView)(UIView*, UIView*) = ^void(UIView* parent, UIView* child) {
            NSDictionary* views = @{@"parent":parent, @"child":child};
            
            NSArray* horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[child]|" options:kNilOptions metrics:nil views:views];
            NSArray* verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[child]|" options:kNilOptions metrics:nil views:views];
            
            [parent addConstraints:horizontalConstraints];
            [parent addConstraints:verticalConstraints];
        };
        
        fullscreenView(self.view, self.openController.view);
        fullscreenView(self.view, self.closedController.view);
        
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

-(void) open {
    [self openWithDependantViews:nil];
}

-(void) close {
    [self closeWithDependantViews:nil];
}

-(void) openWithDependantViews:(NSArray*)views {
    [self ensureInit];
    
    self.isOpen = YES;
    
    [self updateViewAnimated:YES];
    [self updateBoundsAnimated:YES withDependantViews:views];
}

-(void) closeWithDependantViews:(NSArray*)views {
    [self ensureInit];
    
    self.isOpen = NO;
    
    [self updateViewAnimated:YES];
    [self updateBoundsAnimated:YES withDependantViews:views];
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
    [self updateBoundsAnimated:animated withDependantViews:nil];
}

-(void) updateBoundsAnimated:(BOOL)animated withDependantViews:(NSArray*)views {
    if (self.isOpen != self.isOpenLastUpdateBounds) {
        if (self.isOpen) {
            CGRect bounds = bounds2;
            self.width.constant = bounds.size.width;
            self.height.constant = bounds.size.height;
            [self.view setNeedsUpdateConstraints];
            
            [UIView animateWithDuration:(animated ? animationTime : 0) delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseOut animations:^{
                [self.view layoutIfNeeded];
                
                for (UIView* view in views) {
                    [view layoutIfNeeded];
                }
            } completion:^(BOOL finished) {
            }];
        }
        else {
            CGRect bounds = bounds1;
            self.width.constant = bounds.size.width;
            self.height.constant = bounds.size.height;
            [self.view setNeedsUpdateConstraints];
            
            [UIView animateWithDuration:(animated ? animationTime : 0) delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseOut animations:^{
                [self.view layoutIfNeeded];
                
                for (UIView* view in views) {
                    [view layoutIfNeeded];
                }
            } completion:^(BOOL finished) {
            }];
        }
        
        self.isOpenLastUpdateBounds = self.isOpen;
    }
}

@end
