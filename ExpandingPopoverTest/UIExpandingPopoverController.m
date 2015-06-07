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
        _isOpenLastUpdateView = !_isOpen; //force update
        
        self.preferredContentSize = _closedController.preferredContentSize;
    }
    
    return self;
}

-(void) initializeViews {
    if (!self.viewControllersInitialized) {
        self.view.layer.borderWidth = 5;
        self.view.layer.cornerRadius = 20;
        self.view.layer.borderColor = [[UIColor greenColor] CGColor];
        self.view.clipsToBounds = YES;
        
        // fullscreen
        self.closedController.view.translatesAutoresizingMaskIntoConstraints = YES;
        self.openController.view.translatesAutoresizingMaskIntoConstraints = YES;
        self.closedController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.openController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // force update on close and set initial state
        self.openController.view.alpha = 0;
        self.isOpen = YES;
        self.isOpenLastUpdateView = self.isOpen;
        [self close];
        
        self.viewControllersInitialized = YES;
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
    self.preferredContentSize = [container preferredContentSize];
}

// still don't know when this gets called
-(void) systemLayoutFittingSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super systemLayoutFittingSizeDidChangeForChildContentContainer:container];
}

-(void) open {
    [self ensureInit];
    
    if (!self.isOpen) {
        self.isOpen = YES;
        [self transitionIfNeeded];
    }
}

-(void) close {
    [self ensureInit];
    
    if (self.isOpen) {
        self.isOpen = NO;
        [self transitionIfNeeded];
    }
}

-(void) transitionIfNeeded {
    if (self.isOpen != self.isOpenLastUpdateView) {
        UIViewController* from = (self.isOpen ? self.closedController : self.openController);
        UIViewController* to = (self.isOpen ? self.openController : self.closedController);

        // don't animate the transition if we're in an initial state
        BOOL animated = from.parentViewController != nil;
        
        [from willMoveToParentViewController:nil];
        [self addChildViewController:to];
        
        to.view.frame = self.view.bounds;
        from.view.frame = self.view.bounds;
        
        if (animated) {
            // TODO: this produces a warning, but without it, there's artifacting on first open
            [self.view addSubview:to.view];
            [from.view layoutIfNeeded];
            [to.view layoutIfNeeded];
            
            [self transitionFromViewController:from toViewController:to duration:animationTime options:0 animations:^{
                to.view.alpha = 1;
                from.view.alpha = 0;
            } completion:^(BOOL finished) {
                [from removeFromParentViewController];
                [to didMoveToParentViewController:self];
            }];
        }
        else {
            to.view.alpha = 1;
            
            [self.view addSubview:to.view];
            [from removeFromParentViewController];
            [from.view removeFromSuperview];
            [to didMoveToParentViewController:self];
        }
        
        self.preferredContentSize = to.preferredContentSize;
        
        self.isOpenLastUpdateView = self.isOpen;
    }
}

@end
