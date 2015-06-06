//
//  UIExpandingPopoverController_Private.h
//  ExpandingPopoverTest
//
//  Created by Alexei Baboulevitch on 2015-6-5.
//  Copyright (c) 2015 Alexei Baboulevitch. All rights reserved.
//

#import "UIExpandingPopoverController.h"

@interface UIExpandingPopoverController ()

@property (nonatomic, retain) UIViewController* closedController;
@property (nonatomic, retain) UIViewController* openController;

@property (nonatomic, assign) BOOL viewControllersInitialized;
@property (nonatomic, assign) BOOL isOpen;

// constraints
@property (nonatomic, retain) NSLayoutConstraint* width;
@property (nonatomic, retain) NSLayoutConstraint* height;
@property (nonatomic, retain) NSArray* closedControllerFullscreenConstraints;
@property (nonatomic, retain) NSArray* openControllerFullscreenConstraints;

// caches
@property (nonatomic, assign) BOOL isOpenLastUpdateView;
@property (nonatomic, assign) BOOL isOpenLastUpdateBounds;

-(void) initializeViews;

-(void) updateViewAnimated:(BOOL)animated;
-(void) updateBoundsAnimated:(BOOL)animated;

@end
