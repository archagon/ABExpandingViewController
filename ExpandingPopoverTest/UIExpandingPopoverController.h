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

@interface UIExpandingPopoverController : UIViewController

@property (nonatomic, assign) CGPoint expansionAnchorPoint;
@property (nonatomic, assign) CGPoint center;

-(id) initWithClosed:(UIViewController*)closedVC open:(UIViewController*)openVC;

-(IBAction) open;
-(IBAction) close;

@end
