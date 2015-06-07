//
//  UIExpandingPopoverController.h
//  ExpandingPopoverTest
//
//  Created by Alexei Baboulevitch on 2015-6-5.
//  Copyright (c) 2015 Alexei Baboulevitch. All rights reserved.
//

#import <UIKit/UIKit.h>

// The children view controllers must have their preferred content size set!
//
// Once the controller is initialized, its children are strictly under its control. Do not modify their views or
// add constraints to them!

@interface UIExpandingPopoverController : UIViewController

-(id) initWithClosed:(UIViewController*)closedVC open:(UIViewController*)openVC;

-(void) open;
-(void) close;

@end
