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

// TODO: unbalanced calls

@interface ViewController ()

@property (nonatomic, retain) NSMutableDictionary* expandingPopoverWidths;
@property (nonatomic, retain) NSMutableDictionary* expandingPopoverHeights;

@end

@implementation ViewController

-(instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.expandingPopoverWidths = [NSMutableDictionary dictionary];
        self.expandingPopoverHeights = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.expandingPopoverWidths = [NSMutableDictionary dictionary];
        self.expandingPopoverHeights = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(CGSize) sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return [container preferredContentSize];
}

-(void) preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    // the parent view controller manages the dimensions and animation of the popover; this is more or less in line,
    // I think, with the treatment of the standard popover controller, which has a bunch of custom cruft right in the
    // UIViewController interface; also, it makes sense conceptually, since it's rather dangerous for views/controllers
    // to manipulate their own dimensions directly without any knowledge of their parent
    
    NSLayoutConstraint* width = self.expandingPopoverWidths[@([container hash])];
    NSLayoutConstraint* height = self.expandingPopoverHeights[@([container hash])];
    width.constant = [container preferredContentSize].width;
    height.constant = [container preferredContentSize].height;
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // expanding button 1
    UIExpandingPopoverController* expandingPopoverController1;
    {
        expandingPopoverController1 = [self createPopoverWithTarget:nil];
        [self addChildViewController:expandingPopoverController1];
        [self.view addSubview:expandingPopoverController1.view];
        [expandingPopoverController1 didMoveToParentViewController:self];
        
        NSLayoutConstraint* constraint1 = [NSLayoutConstraint constraintWithItem:expandingPopoverController1.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
        NSLayoutConstraint* constraint2 = [NSLayoutConstraint constraintWithItem:expandingPopoverController1.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:40];
        [self.view addConstraints:@[constraint1, constraint2]];
    }
    
    // expanding button 2
    UIExpandingPopoverController* expandingPopoverController2;
    {
        expandingPopoverController2 = [self createPopoverWithTarget:nil];

        UIViewController* closedController = (UIViewController*)[expandingPopoverController2 closedController];
        [closedController.view setBackgroundColor:[UIColor lightGrayColor]];
        closedController.preferredContentSize = CGSizeMake(closedController.preferredContentSize.width * 1.25f, closedController.preferredContentSize.height);
        expandingPopoverController2.view.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        
        [self addChildViewController:expandingPopoverController2];
        [self.view addSubview:expandingPopoverController2.view];
        [expandingPopoverController2 didMoveToParentViewController:self];

        NSLayoutConstraint* constraint1 = [NSLayoutConstraint constraintWithItem:expandingPopoverController2.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
        NSLayoutConstraint* constraint2 = [NSLayoutConstraint constraintWithItem:expandingPopoverController2.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:expandingPopoverController1.view attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
        NSLayoutConstraint* constraint3 = [NSLayoutConstraint constraintWithItem:expandingPopoverController2.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:expandingPopoverController1.view attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
        constraint3.priority = UILayoutPriorityDefaultLow;
        [self.view addConstraints:@[constraint1, constraint2, constraint3]];
    }

    // just an extra view to demonstrate autolayout constraints
    UIView* blahView;
    {
        blahView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        blahView.backgroundColor = [UIColor purpleColor];
        blahView.layer.cornerRadius = 20;
        [self.view addSubview:blahView];

        blahView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint* constraint1 = [NSLayoutConstraint constraintWithItem:blahView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:expandingPopoverController1.view attribute:NSLayoutAttributeRight multiplier:1 constant:20];
        NSLayoutConstraint* constraint2 = [NSLayoutConstraint constraintWithItem:blahView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:expandingPopoverController1.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self.view addConstraints:@[constraint1, constraint2]];
        
        constraint1 = [NSLayoutConstraint constraintWithItem:blahView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
        constraint2 = [NSLayoutConstraint constraintWithItem:blahView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:expandingPopoverController1.view attribute:NSLayoutAttributeHeight multiplier:0.75f constant:0];
        [self.view addConstraints:@[constraint1, constraint2]];
        
        UILabel* testLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        testLabel.font = [testLabel.font fontWithSize:testLabel.font.pointSize * 2];
        testLabel.text = @"Hallo";
        testLabel.textColor = [UIColor whiteColor];
        [testLabel sizeToFit];
        [blahView addSubview:testLabel];
        
        testLabel.translatesAutoresizingMaskIntoConstraints = NO;
        constraint1 = [NSLayoutConstraint constraintWithItem:testLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:blahView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        constraint2 = [NSLayoutConstraint constraintWithItem:testLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:blahView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [blahView addConstraints:@[constraint1, constraint2]];
    }
    
    // nested expanding button???
    UIExpandingPopoverController* expandingPopoverController3;
    {
        UIViewController* bottomViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        bottomViewController.view.backgroundColor = [UIColor yellowColor];
        bottomViewController.preferredContentSize = CGSizeMake(600, 700);
        
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"You Win" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        backButton.titleLabel.font = [backButton.titleLabel.font fontWithSize:backButton.titleLabel.font.pointSize * 3];
        [bottomViewController.view addSubview:backButton];
        
        backButton.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint* constraint1 = [NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomViewController.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint* constraint2 = [NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomViewController.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [bottomViewController.view addConstraints:@[constraint1, constraint2]];
        
        UIViewController* middleViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        middleViewController.view.backgroundColor = [UIColor magentaColor];
        middleViewController.preferredContentSize = CGSizeMake(400, 300);
        
        UIButton* backButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton2 setTitle:@"Almost There" forState:UIControlStateNormal];
        [backButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        backButton2.titleLabel.font = [backButton2.titleLabel.font fontWithSize:backButton2.titleLabel.font.pointSize * 3];
        [backButton2 sizeToFit];
        [middleViewController.view addSubview:backButton2];
        
        backButton2.translatesAutoresizingMaskIntoConstraints = NO;
        constraint1 = [NSLayoutConstraint constraintWithItem:backButton2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:middleViewController.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        constraint2 = [NSLayoutConstraint constraintWithItem:backButton2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:middleViewController.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [middleViewController.view addConstraints:@[constraint1, constraint2]];
        
        UIExpandingPopoverController* subExpandingPopoverController = [[UIExpandingPopoverController alloc] initWithClosed:middleViewController open:bottomViewController];
        
        [backButton2 addTarget:subExpandingPopoverController action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
        
        expandingPopoverController3 = [self createPopoverWithTarget:subExpandingPopoverController];
        
        UIViewController* closedController = (UIViewController*)[expandingPopoverController3 closedController];
        [closedController.view setBackgroundColor:[UIColor cyanColor]];
        closedController.preferredContentSize = CGSizeMake(200, 100);
        expandingPopoverController3.view.layer.borderColor = [[UIColor blackColor] CGColor];
        
        [self addChildViewController:expandingPopoverController3];
        [self.view addSubview:expandingPopoverController3.view];
        [expandingPopoverController3 didMoveToParentViewController:self];

        [backButton addTarget:subExpandingPopoverController action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [backButton addTarget:expandingPopoverController3 action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
        NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:expandingPopoverController3.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
        NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:expandingPopoverController3.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:expandingPopoverController2.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint* bottom2 = [NSLayoutConstraint constraintWithItem:expandingPopoverController3.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
        NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:expandingPopoverController3.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:blahView attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
        NSLayoutConstraint* top2 = [NSLayoutConstraint constraintWithItem:expandingPopoverController3.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:expandingPopoverController1.view attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
        NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:expandingPopoverController3.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:expandingPopoverController2.view attribute:NSLayoutAttributeRight multiplier:1 constant:20];
        [self.view addConstraints:@[right, bottom, bottom2, top, top2, left]];

        NSLayoutConstraint* width = self.expandingPopoverWidths[@([expandingPopoverController3 hash])];
        width.priority = UILayoutPriorityDefaultHigh;
    }
}

-(UIExpandingPopoverController*) createPopoverWithTarget:(UIViewController*)target {
    ClosedController* closed = [[ClosedController alloc] initWithNibName:@"ClosedController" bundle:[NSBundle mainBundle]];
    UINavigationController* open = (!target ? [[UIStoryboard storyboardWithName:@"OpenController" bundle:[NSBundle mainBundle]] instantiateInitialViewController] : target);
    
    UIExpandingPopoverController* popover = [[UIExpandingPopoverController alloc] initWithClosed:closed open:open];
    
    UIButton* button = closed.view.subviews.firstObject;
    [button addTarget:popover action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    
    if (!target) {
        UIButton* button2 = (UIButton*)[[open.viewControllers[0] view] viewWithTag:1];
        [button2 addTarget:popover action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:popover.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:popover.preferredContentSize.width];
    NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:popover.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:popover.preferredContentSize.height];
    width.priority = (UILayoutPriorityDefaultLow + UILayoutPriorityDefaultHigh) / 2.0f;
    height.priority = (UILayoutPriorityDefaultLow + UILayoutPriorityDefaultHigh) / 2.0f;
    
    popover.view.translatesAutoresizingMaskIntoConstraints = NO;
    [popover.view addConstraints:@[width, height]];
    self.expandingPopoverWidths[@([popover hash])] = width;
    self.expandingPopoverHeights[@([popover hash])] = height;
    
    return [popover autorelease];
}

@end
