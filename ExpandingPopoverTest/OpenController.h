//
//  OpenController.h
//  UIExpandingPopover
//
//  Created by Alexei Baboulevitch on 2015-6-6.
//  Copyright (c) 2015 Alexei Baboulevitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenController : UINavigationController <UINavigationControllerDelegate>
@end

@interface OpenDemoController : UIViewController
-(IBAction) resizeTapped:(UIButton*)resize;
@end

@interface OpenTextController : UIViewController
@end
