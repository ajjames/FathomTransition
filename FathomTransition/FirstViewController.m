//
//  FirstViewController.m
//  FathomTransition
//
//  Created by Andrew James on 10/10/13.
//  Copyright (c) 2013 Andrew James. All rights reserved.
//

#import "FirstViewController.h"
#import "AJFathomTransitionController.h"

@interface FirstViewController ()
@property (nonatomic, strong) AJFathomTransitionController *transitionController;
@end

@implementation FirstViewController


- (IBAction)didTouchBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTouchNextButton:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* destinationController = [storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    self.transitionController = [AJFathomTransitionController fathomTransition];
    destinationController.transitioningDelegate = self.transitionController;
    [self presentViewController:destinationController animated:YES completion:nil];
}

@end
