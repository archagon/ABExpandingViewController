//
//  OpenController.m
//  UIExpandingPopover
//
//  Created by Alexei Baboulevitch on 2015-6-6.
//  Copyright (c) 2015 Alexei Baboulevitch. All rights reserved.
//

#import "OpenController.h"

@implementation OpenController

CGSize originalPreferredContentSize;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.delegate = self;
        originalPreferredContentSize = self.preferredContentSize;
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.delegate = self;
        originalPreferredContentSize = self.preferredContentSize;
    }
    
    return self;
}

-(void) preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    if ([container preferredContentSize].width && [container preferredContentSize].height) {
        self.preferredContentSize = [container preferredContentSize];
    }
    else {
        self.preferredContentSize = originalPreferredContentSize;
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.preferredContentSize.width && viewController.preferredContentSize.height) {
        self.preferredContentSize = viewController.preferredContentSize;
    }
    else {
        self.preferredContentSize = originalPreferredContentSize;
    }
}


@end

@implementation OpenDemoController

-(IBAction) resizeTapped:(UIButton*)resize {
    CGSize size = CGSizeMake(arc4random() % 200 + 100, arc4random() % 400 + 200);
    self.preferredContentSize = size;
}

@end

@implementation OpenTextController

-(CGSize) preferredContentSize {
    return CGSizeMake(300, 150);
}

@end
