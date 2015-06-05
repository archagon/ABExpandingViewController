//
//  ViewController.m
//  ExpandingPopoverTest
//
//  Created by Alexei Baboulevitch on 2015-6-5.
//  Copyright (c) 2015 Alexei Baboulevitch. All rights reserved.
//

#import "ViewController.h"
#import "UIExpandingPopoverController.h"
#import "ClosedController.h"

@interface ViewController ()

@property (nonatomic, retain) UIExpandingPopoverController* expandingPopoverController;
@property (nonatomic, retain) UIExpandingPopoverController* expandingPopoverController2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ClosedController* closed = [[ClosedController alloc] initWithNibName:@"ClosedController" bundle:[NSBundle mainBundle]];
    UINavigationController* open = [[UIStoryboard storyboardWithName:@"OpenController" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    open.view.frame = CGRectMake(0, 0, 300, 400);
    
    UIExpandingPopoverController* popover = [[UIExpandingPopoverController alloc] initWithClosed:closed open:open];
    self.expandingPopoverController = popover;
    
    [self.view addSubview:self.expandingPopoverController.view];
    
    
//    self.expandingPopoverController.view.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint* constraint1 = [NSLayoutConstraint constraintWithItem:popover.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
//    constraint1.priority = UILayoutPriorityRequired;
//    NSLayoutConstraint* constraint2 = [NSLayoutConstraint constraintWithItem:popover.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:40];
//    constraint2.priority = UILayoutPriorityRequired;
//    [self.view addConstraints:@[constraint1, constraint2]];
    
    
    self.expandingPopoverController.center = CGPointMake(40, 40);
    
    UIButton* button = closed.view.subviews.firstObject;
    [button addTarget:popover action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* button2 = (UIButton*)[[open.viewControllers[0] view] viewWithTag:1];
    [button2 addTarget:popover action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
}

@end
