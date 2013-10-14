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
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *buttonPreview;
@property (strong, nonatomic) IBOutlet UISlider *sliderPresentationDuration;
@property (strong, nonatomic) IBOutlet UISlider *sliderDismissalDuration;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segPresentationAnimationOptions;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segDismissalAnimationOptions;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segStartPosition;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segEndPosition;
@property (strong, nonatomic) IBOutlet UISlider *sliderSpringDampening;
@property (strong, nonatomic) IBOutlet UISlider *sliderSpringVelocity;
@property (strong, nonatomic) IBOutlet UISlider *sliderZoomFactor;
@property (strong, nonatomic) IBOutlet UISlider *sliderTintRed;
@property (strong, nonatomic) IBOutlet UISlider *sliderTintGreen;
@property (strong, nonatomic) IBOutlet UISlider *sliderTintBlue;
@property (strong, nonatomic) IBOutlet UISlider *sliderTintAlpha;
@property (strong, nonatomic) IBOutlet UISlider *sliderBlurRadius;
@property (strong, nonatomic) IBOutlet UISlider *sliderSaturation;
@property (strong, nonatomic) IBOutlet UIView *viewTintColorPreview;
@end

@implementation FirstViewController

-(void)viewDidLoad
{
    self.transitionController = [AJFathomTransitionController fathomTransition];
    _sliderPresentationDuration.value = self.transitionController.presentDuration;
    _sliderDismissalDuration.value = self.transitionController.dismissDuration;
    _segPresentationAnimationOptions.selectedSegmentIndex = [self segmentIndexForAnimationOption:self.transitionController.animationInOptions];
    _segDismissalAnimationOptions.selectedSegmentIndex = [self segmentIndexForAnimationOption:self.transitionController.animationOutOptions];
    _segStartPosition.selectedSegmentIndex = 0; //default
    _segEndPosition.selectedSegmentIndex = 0; //default
    _sliderSpringDampening.value = self.transitionController.springWithDampening;
    _sliderSpringVelocity.value = self.transitionController.initialSpringVelocity;
    _sliderZoomFactor.value = self.transitionController.zoomFactor;
    const CGFloat* tintComponents = CGColorGetComponents(self.transitionController.tintColor.CGColor);
    _sliderTintRed.value = tintComponents[0];
    _sliderTintGreen.value = tintComponents[1];
    _sliderTintBlue.value = tintComponents[2];
    _sliderTintAlpha.value = CGColorGetAlpha(self.transitionController.tintColor.CGColor);
    _sliderBlurRadius.value = self.transitionController.blurRadius;
    _sliderSaturation.value = self.transitionController.saturationDeltaFactor;
    [self colorChanged:nil];
}

- (IBAction)colorChanged:(id)sender {
    self.viewTintColorPreview.backgroundColor = [self currentTintColor];
    self.viewTintColorPreview.alpha = self.sliderTintAlpha.value;
}

-(uint)segmentIndexForAnimationOption:(UIViewAnimationOptions)option
{
    switch (option) {
        case UIViewAnimationOptionCurveEaseIn:
            return 1;
            break;
        case UIViewAnimationOptionCurveEaseOut:
            return 2;
            break;
        case UIViewAnimationOptionCurveEaseInOut:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}


-(UIViewAnimationOptions)animationOptionForSegmentIndex:(uint)index
{
    switch (index) {
        case 1:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case 2:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case 3:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        default:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
}

-(CGRect)boundsStartFromSegmentIndex:(uint)index
{
    switch (index) {
        case 1:
            return self.buttonPreview.frame;
            break;
        case 2:
            return CGRectMake(self.view.frame.origin.x,
                              self.view.frame.origin.y - self.view.frame.size.height,
                              self.view.frame.size.width,
                              self.view.frame.size.height);
            break;
        case 3:
            return CGRectMake(self.view.frame.origin.x,
                              self.view.frame.origin.y + self.view.frame.size.height,
                              self.view.frame.size.width,
                              self.view.frame.size.height);
            break;
        case 4:
            return CGRectMake(self.view.frame.origin.x,
                              self.view.frame.origin.y,
                              self.view.frame.size.width - self.view.frame.size.width,
                              self.view.frame.size.height);
            break;
        case 5:
            return CGRectMake(self.view.frame.origin.x,
                              self.view.frame.origin.y + self.view.frame.size.width,
                              self.view.frame.size.width,
                              self.view.frame.size.height);
            break;
        default:
            return CGRectNull;
            break;
    }
}

- (IBAction)didTouchBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UIColor*)currentTintColor
{
    return [UIColor colorWithRed:self.sliderTintRed.value green:self.sliderTintGreen.value blue:self.sliderTintBlue.value alpha:self.sliderTintAlpha.value];
}

- (IBAction)didTouchNextButton:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* destinationController = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    self.transitionController.presentDuration = self.sliderPresentationDuration.value;
    self.transitionController.dismissDuration = self.sliderDismissalDuration.value;
    self.transitionController.animationInOptions = [self animationOptionForSegmentIndex:self.segPresentationAnimationOptions.selectedSegmentIndex];
    self.transitionController.animationOutOptions = [self animationOptionForSegmentIndex:self.segDismissalAnimationOptions.selectedSegmentIndex];
    self.transitionController.boundsStart = [self boundsStartFromSegmentIndex:self.segStartPosition.selectedSegmentIndex];
//    self.transitionController.boundsEnd =
    self.transitionController.springWithDampening = self.sliderSpringDampening.value;
    self.transitionController.initialSpringVelocity = self.sliderSpringVelocity.value;
    self.transitionController.zoomFactor = self.sliderZoomFactor.value;
    self.transitionController.tintColor = [self currentTintColor];
    self.transitionController.blurRadius = self.sliderBlurRadius.value;
    self.transitionController.saturationDeltaFactor = self.sliderSaturation.value;
    destinationController.transitioningDelegate = self.transitionController;
    [self presentViewController:destinationController animated:YES completion:nil];
}

@end
