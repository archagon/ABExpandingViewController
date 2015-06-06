//
//  UIExpandingPopoverController.h
//  ExpandingPopoverTest
//
//  Created by Alexei Baboulevitch on 2015-6-5.
//  Copyright (c) 2015 Alexei Baboulevitch. All rights reserved.
//

#import <UIKit/UIKit.h>

// For the time being, this class requires autolayout. (That is, you cannot position its view using frame.)
// That's not to say that this is impossible, but this is not my use case for the time being.
//
// The children view controllers must have their preferred content size set!
//
// The only thing that should be changing the bounds of this controller is the controller itself.
//
// Once the controller is initialized, its children are strictly under its control. Do not modify their views or
// add constraints to them!

@class UIExpandingPopoverController;

@protocol UIExpandingPopoverControllerDelegate

@optional

// If you want other views that are bound by autolayout constraints to this popover to move based on its
// expansion/contraction, you need to manually pass them in with this delegate call. Is there a better way to do this?
// I'm not sure. But by default, if we don't include these extra views in the animation blocks, they just snap into
// place.
-(NSArray*) expandingPopoverShouldTriggerLayoutForAdditionalViewsDuringBoundsChangeAnimation:(UIExpandingPopoverController*)controller;

@end

@interface UIExpandingPopoverController : UIViewController

@property (nonatomic, assign) id<NSObject,UIExpandingPopoverControllerDelegate> delegate;

-(id) initWithClosed:(UIViewController*)closedVC open:(UIViewController*)openVC;

-(void) open;
-(void) close;

@end
