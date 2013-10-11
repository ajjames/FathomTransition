//
//  StartViewController.m
//  FathomTransition
//
//  Created by Andrew James on 10/10/13.
//  Copyright (c) 2013 Andrew James. All rights reserved.
//

#import "StartViewController.h"
#import "AJFathomTransitionController.h"


@interface StartViewController ()
@property (nonatomic, strong) AJFathomTransitionController *transitionController;
@end

@implementation StartViewController


- (IBAction)didTouchWhiteButton:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* destinationController = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    self.transitionController = [AJFathomTransitionController fathomTransition];
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    self.transitionController.boundsStart = [sender frame];
    destinationController.transitioningDelegate = self.transitionController;
    [self presentViewController:destinationController animated:YES completion:nil];
}

- (IBAction)didTouchBlackButton:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* destinationController = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    self.transitionController = [AJFathomTransitionController fathomTransition];
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    self.transitionController.boundsStart = [sender frame];
    self.transitionController.blurRadius = 10;
    self.transitionController.saturationDeltaFactor = .8;
    self.transitionController.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    destinationController.transitioningDelegate = self.transitionController;
    [self presentViewController:destinationController animated:YES completion:nil];
}

- (IBAction)didTouchGreenButton:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* destinationController = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    self.transitionController = [AJFathomTransitionController fathomTransition];
    self.transitionController.boundsStart = [sender frame];
    self.transitionController.tintColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:.5];
    destinationController.transitioningDelegate = self.transitionController;
    [self.navigationController presentViewController:destinationController animated:YES completion:nil];
}

- (IBAction)didTouchBlueButton:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* destinationController = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    self.transitionController = [AJFathomTransitionController fathomTransition];
    self.transitionController.boundsStart = [sender frame];
    self.transitionController.tintColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:.5];
    self.transitionController.springWithDampening = .2;
    self.transitionController.initialSpringVelocity = 5;
    self.transitionController.presentDuration = 2;
    self.transitionController.dismissDuration = 1;
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    destinationController.transitioningDelegate = self.transitionController;
    [self presentViewController:destinationController animated:YES completion:nil];
}

- (IBAction)didTouchRedButton:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* destinationController = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    self.transitionController = [AJFathomTransitionController fathomTransition];
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    self.transitionController.blurRadius = 10;
    self.transitionController.tintColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:.8];
    self.transitionController.zoomFactor = 0;
    self.transitionController.presentDuration = 3;
    self.transitionController.dismissDuration = 3;
    self.transitionController.springWithDampening = 1;
    self.transitionController.initialSpringVelocity = 0;
    self.transitionController.animationInOptions = UIViewAnimationOptionCurveLinear;
    self.transitionController.animationOutOptions = UIViewAnimationOptionCurveLinear;
    destinationController.transitioningDelegate = self.transitionController;
    [self presentViewController:destinationController animated:YES completion:nil];
}

- (IBAction)didTouchVignetteButton:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* destinationController = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    self.transitionController = [AJFathomTransitionController fathomTransition];
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    self.transitionController.boundsStart = [sender frame];
    self.transitionController.blurRadius = 20;
    self.transitionController.saturationDeltaFactor = 0;
    self.transitionController.springWithDampening = 1;
    self.transitionController.initialSpringVelocity = 0;
    self.transitionController.presentDuration = .5;
    self.transitionController.dismissDuration = .5;
    self.transitionController.tintColor = nil;
    self.transitionController.maskImage = [UIImage imageNamed:@"vignette"];
    self.transitionController.animationInOptions = UIViewAnimationOptionCurveLinear;
    self.transitionController.animationOutOptions = UIViewAnimationOptionCurveLinear;
    destinationController.transitioningDelegate = self.transitionController;
    [self presentViewController:destinationController animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.transitionController.isPresented = YES;
    return self.transitionController;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionController.isPresented = NO;
    return self.transitionController;
}


@end
