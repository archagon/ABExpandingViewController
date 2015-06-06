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

NSTimeInterval animationTime = 0.5f;

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
        _isOpenLastUpdateView = YES; //force update
        _isOpenLastUpdateBounds = YES; //force update
    }
    
    return self;
}

-(void) initializeViews {
    if (!self.viewControllersInitialized) {
        // we want to be able to change the dimensions from within the controller, but we also want to retain the
        // ability for outside code to reposition the controller; hence, manual dimension constraints
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.width = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        self.height = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        self.width.priority = UILayoutPriorityRequired;
        self.height.priority = UILayoutPriorityRequired;
        [self.view addConstraints:@[self.width, self.height]];
        
        self.view.layer.borderWidth = 5;
        self.view.layer.cornerRadius = 20;
        self.view.layer.borderColor = [[UIColor greenColor] CGColor];
        self.view.clipsToBounds = YES;
        
        NSArray* (^fullscreenConstraints)(UIView*, UIView*) = ^NSArray*(UIView* parent, UIView* child) {
            NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            
            return @[left, right, top, bottom];
        };
        
        // each sub view controller is fullscreen, but we can't activate these constraints until the views are added
        // during the transition
        self.closedController.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.openController.view.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray* closedControllerConstraints = fullscreenConstraints(self.view, self.closedController.view);
        NSArray* openControllerConstraints = fullscreenConstraints(self.view, self.openController.view);
        [self.view addConstraints:closedControllerConstraints];
        [self.view addConstraints:openControllerConstraints];
        [NSLayoutConstraint deactivateConstraints:closedControllerConstraints];
        [NSLayoutConstraint deactivateConstraints:openControllerConstraints];
        self.closedControllerFullscreenConstraints = closedControllerConstraints;
        self.openControllerFullscreenConstraints = openControllerConstraints;
        
        self.viewControllersInitialized = YES;
        
        // force update on close and set initial state
        self.openController.view.alpha = 0;
        self.isOpen = YES;
        self.isOpenLastUpdateView = self.isOpen;
        self.isOpenLastUpdateBounds = self.isOpen;
        [self close];
    }
}

-(void) ensureInit {
    self.view = self.view;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    [self initializeViews];
}

-(void) preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    self.isOpenLastUpdateBounds = !self.isOpen;
    [self updateBoundsAnimated:YES];
}

-(void) open {
    [self ensureInit];
    
    if (!self.isOpen) {
        self.isOpen = YES;
        [self updateViewAnimated:YES];
    }
}

-(void) close {
    [self ensureInit];
    
    if (self.isOpen) {
        self.isOpen = NO;
        [self updateViewAnimated:YES];
    }
}

-(void) updateViewAnimated:(BOOL)animated {
    if (self.isOpen != self.isOpenLastUpdateView) {
        UIViewController* from = (self.isOpen ? self.closedController : self.openController);
        UIViewController* to = (self.isOpen ? self.openController : self.closedController);

        animated = (animated && from.parentViewController != nil);
        
        [from willMoveToParentViewController:nil];
        [self addChildViewController:to];
        [self.view addSubview:to.view]; //we need to do this here to make the constraints work
        [NSLayoutConstraint activateConstraints:(self.isOpen ? self.openControllerFullscreenConstraints : self.closedControllerFullscreenConstraints)];
        
        [from.view layoutIfNeeded];
        [to.view layoutIfNeeded];
        
        if (animated) {
            [self transitionFromViewController:from toViewController:to duration:animationTime options:0 animations:^{
                to.view.alpha = 1;
                from.view.alpha = 0;
            } completion:^(BOOL finished) {
                [from removeFromParentViewController];
                [to didMoveToParentViewController:self];
            }];
            
            [self updateBoundsAnimated:YES];
        }
        else {
            to.view.alpha = 1;
            
            [to didMoveToParentViewController:self];
            
            [self updateBoundsAnimated:NO];
        }
        
        self.isOpenLastUpdateView = self.isOpen;
    }
}

-(void) updateBoundsAnimated:(BOOL)animated {
    if (self.isOpen != self.isOpenLastUpdateBounds) {
        NSArray* additionalViews = nil;
        if ([self.delegate respondsToSelector:@selector(expandingPopoverShouldTriggerLayoutForAdditionalViewsDuringBoundsChangeAnimation:)]) {
            additionalViews = [self.delegate expandingPopoverShouldTriggerLayoutForAdditionalViewsDuringBoundsChangeAnimation:self];
        }
        
        CGSize size = (self.isOpen ? self.openController.preferredContentSize : self.closedController.preferredContentSize);
        self.width.constant = size.width;
        self.height.constant = size.height;
        [self.view setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:(animated ? animationTime : 0) delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseOut animations:^{
            [self.view layoutIfNeeded];
            
            for (UIView* view in additionalViews) {
                [view layoutIfNeeded];
            }
        } completion:^(BOOL finished) {
        }];
        
        self.isOpenLastUpdateBounds = self.isOpen;
    }
}

@end
