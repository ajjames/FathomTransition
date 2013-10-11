//
//  SecondViewController.m
//  FathomTransition
//
//  Created by Andrew James on 10/10/13.
//  Copyright (c) 2013 Andrew James. All rights reserved.
//

#import "SecondViewController.h"
#import "AJFathomTransitionController.h"

@interface SecondViewController ()
@property (nonatomic, strong) AJFathomTransitionController *transitionController;
@end

@implementation SecondViewController


- (IBAction)didTouchBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTouchNextButton:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* destinationController = [storyboard instantiateViewControllerWithIdentifier:@"LastViewController"];
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    self.transitionController = [AJFathomTransitionController fathomTransition];
    self.transitionController.boundsStart = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    destinationController.transitioningDelegate = self.transitionController;
    [self presentViewController:destinationController animated:YES completion:nil];
}

@end
