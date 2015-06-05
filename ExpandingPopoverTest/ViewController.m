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
@property (nonatomic, retain) UIView* blahView;

@end

@implementation ViewController

NSMutableDictionary* asdf;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    asdf = [[NSMutableDictionary dictionary] retain];

    self.expandingPopoverController = [self createPopover];
    
    NSLayoutConstraint* constraint1 = [NSLayoutConstraint constraintWithItem:self.expandingPopoverController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    NSLayoutConstraint* constraint2 = [NSLayoutConstraint constraintWithItem:self.expandingPopoverController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:40];
    [self.view addConstraints:@[constraint1, constraint2]];
    
    self.expandingPopoverController2 = [self createPopover];
    
    constraint1 = [NSLayoutConstraint constraintWithItem:self.expandingPopoverController2.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    constraint2 = [NSLayoutConstraint constraintWithItem:self.expandingPopoverController2.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.expandingPopoverController.view attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
    [self.view addConstraints:@[constraint1, constraint2]];
    
    self.blahView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.blahView.backgroundColor = [UIColor purpleColor];
    self.blahView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.blahView];
    
    constraint1 = [NSLayoutConstraint constraintWithItem:self.blahView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.expandingPopoverController.view attribute:NSLayoutAttributeRight multiplier:1 constant:20];
    constraint2 = [NSLayoutConstraint constraintWithItem:self.blahView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.expandingPopoverController.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraints:@[constraint1, constraint2]];
    constraint1 = [NSLayoutConstraint constraintWithItem:self.blahView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200];
    constraint2 = [NSLayoutConstraint constraintWithItem:self.blahView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.expandingPopoverController.view attribute:NSLayoutAttributeHeight multiplier:0.75f constant:0];
    [self.view addConstraints:@[constraint1, constraint2]];
}

-(UIExpandingPopoverController*) createPopover {
    ClosedController* closed = [[ClosedController alloc] initWithNibName:@"ClosedController" bundle:[NSBundle mainBundle]];
    UINavigationController* open = [[UIStoryboard storyboardWithName:@"OpenController" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    open.view.frame = CGRectMake(0, 0, 300, 400);
    
    UIExpandingPopoverController* popover = [[UIExpandingPopoverController alloc] initWithClosed:closed open:open];
    
    [self.view addSubview:popover.view];
    
    UIButton* button = closed.view.subviews.firstObject;
    asdf[@([button hash])] = popover;
    [button addTarget:self action:@selector(openWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* button2 = (UIButton*)[[open.viewControllers[0] view] viewWithTag:1];
    asdf[@([button2 hash])] = popover;
    [button2 addTarget:self action:@selector(closeWithButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [popover close];
    
    return [popover autorelease];
}

-(void) openWithButton:(UIButton*)button {
    UIExpandingPopoverController* controller = asdf[@([button hash])];
    [controller openWithDependantViews:@[self.expandingPopoverController.view, self.expandingPopoverController2.view, self.blahView]];
}

-(void) closeWithButton:(UIButton*)button {
    UIExpandingPopoverController* controller = asdf[@([button hash])];
    [controller closeWithDependantViews:@[self.expandingPopoverController.view, self.expandingPopoverController2.view, self.blahView]];
}

@end
