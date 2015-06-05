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

// The only thing that should be changing the bounds of this controller is the controller itself.

@class UIExpandingPopoverController;

@protocol UIExpandingPopoverControllerDelegate

@optional

-(void) expandingPopoverBoundsWillChange:(UIExpandingPopoverController*)controller;
-(NSArray*) expandingPopoverShouldTriggerLayoutForAdditionalViewsDuringBoundsChangeAnimation:(UIExpandingPopoverController*)controller;

@end

@interface UIExpandingPopoverController : UIViewController

@property (nonatomic, assign) id<NSObject,UIExpandingPopoverControllerDelegate> delegate;

-(id) initWithClosed:(UIViewController*)closedVC open:(UIViewController*)openVC;

-(void) open;
-(void) close;

@end
