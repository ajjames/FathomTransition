//
//  AJFathomTransitionController.m
//  iStock
//
//  Created by Andrew James on 10/3/13.
//  Copyright (c) 2013 Getty Images. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "AJFathomTransitionController.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ColorAtPixel.h"

@interface AJFathomTransitionController()
@property(nonatomic, strong)UIImageView *snapshotBlur;
@property(nonatomic, strong)UIImageView *snapshotBlurPresented;
@property(nonatomic, strong)UIView *backdropBlur;
@property(nonatomic, strong)UIView *backdropBlurPresented;
@property(nonatomic, strong)UIImageView *snapshot;
@property(nonatomic, strong)UIView *backdrop;
@end


@implementation AJFathomTransitionController
@synthesize presentDuration;
@synthesize dismissDuration;
@synthesize isPresented;


+(id)fathomTransition
{
    AJFathomTransitionController *fathomTC = [[AJFathomTransitionController alloc] init];
    return fathomTC;
}


-(id)init{
    self = [super init];
    if(self){
        //DEFAULTS
        self.boundsStart = CGRectNull;
        self.boundsEnd = CGRectNull;
        self.presentDuration = 1.0;
        self.dismissDuration = .7;
        self.zoomFactor = .8;
        self.blurRadius = 10;
        self.springWithDampening = .7;
        self.initialSpringVelocity = .5;
        self.backdropColor = nil;
        self.saturationDeltaFactor = .8;
        self.tintColor = [UIColor colorWithWhite:1 alpha:0.8];
        self.maskImage = nil;
        self.animationInOptions = UIViewAnimationOptionCurveEaseOut;
        self.animationOutOptions = UIViewAnimationOptionCurveEaseIn;
    }
    return self;
}


-(CGPoint)centerOfRect:(CGRect)rect
{
    CGFloat x = rect.origin.x + (rect.size.width / 2.0f);
    CGFloat y = rect.origin.y + (rect.size.height / 2.0f);
    return CGPointMake(x, y);
}


#pragma mark - UIViewControllerAnimatedTransitioning

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.isPresented ? self.presentDuration : self.dismissDuration;
}


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if(self.isPresented)
    {
        [self executePresentationAnimation:transitionContext];
    }
    else
    {
        [self executeDismissalAnimation:transitionContext];
    }
}


-(void)executePresentationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView* fromView = [transitionContext containerView];
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if (CGRectIsNull(self.boundsStart))
    {
        CGPoint centerOfFromView = [self centerOfRect:fromView.frame];
        self.boundsStart = CGRectMake(centerOfFromView.x,centerOfFromView.y,0,0);
    }

    if (CGRectIsNull(self.boundsEnd))
        self.boundsEnd = toViewController.view.frame;

    UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, NO, fromView.window.screen.scale);
    [fromView drawViewHierarchyInRect:fromView.frame afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredImage = [snapshotImage applyBlurWithRadius:self.blurRadius tintColor:self.tintColor saturationDeltaFactor:self.saturationDeltaFactor maskImage:self.maskImage];
    UIGraphicsEndImageContext();

    self.snapshot = [[UIImageView alloc] initWithImage:snapshotImage];
    self.snapshotBlur = [[UIImageView alloc] initWithImage:blurredImage];
    self.snapshotBlurPresented = [[UIImageView alloc] initWithImage:blurredImage];

    if (!self.backdropColor)
        self.backdropColor = [self.snapshot.image colorAtPixel:CGPointMake(1, 1)];

    self.backdrop = [UIView new];
    self.backdrop.frame = fromView.frame;
    self.backdrop.backgroundColor = self.backdropColor;

    self.backdropBlur = [UIView new];
    self.backdropBlur.frame = fromView.frame;
    UIColor *extendedBlurColor = [self.snapshotBlur.image colorAtPixel:CGPointMake(1, 1)];
    self.backdropBlur.backgroundColor = extendedBlurColor;
    self.backdropBlurPresented = [UIView new];
    self.backdropBlurPresented.frame = fromView.frame;
    self.backdropBlurPresented.backgroundColor = extendedBlurColor;

    self.backdropBlur.alpha = 0;
    self.snapshotBlur.alpha = 0;
    self.backdropBlurPresented.alpha = 0;

    [fromView addSubview:self.backdrop];
    [fromView addSubview:self.snapshot];
    [fromView addSubview:self.backdropBlur];
    [self.backdropBlur addSubview:self.snapshotBlur];
    [self.backdropBlurPresented addSubview:self.snapshotBlurPresented];
    [fromView addSubview:toViewController.view];
    [toViewController.view insertSubview:self.backdropBlurPresented atIndex:0];

    toViewController.view.center = [self centerOfRect:self.boundsStart];
    toViewController.view.transform = CGAffineTransformMakeScale(self.boundsStart.size.width / self.boundsEnd.size.width, self.boundsStart.size.height / self.boundsEnd.size.height);
    self.snapshotBlurPresented.transform = CGAffineTransformMakeScale(self.zoomFactor,self.zoomFactor);

    AJFathomTransitionController * __weak weakSelf = self;

    [UIView animateWithDuration:self.presentDuration delay:0 usingSpringWithDamping:self.springWithDampening initialSpringVelocity:self.initialSpringVelocity options:self.animationInOptions animations:^
     {
        weakSelf.snapshot.transform = CGAffineTransformMakeScale(weakSelf.zoomFactor,weakSelf.zoomFactor);
        weakSelf.snapshotBlur.transform = CGAffineTransformMakeScale(weakSelf.zoomFactor,weakSelf.zoomFactor);
        weakSelf.snapshotBlur.alpha = 1;
        weakSelf.backdropBlur.alpha = 1;
     } completion:nil];

    [UIView animateWithDuration:self.presentDuration delay:0 usingSpringWithDamping:self.springWithDampening initialSpringVelocity:self.initialSpringVelocity options:self.animationInOptions animations:^
     {
         toViewController.view.center = fromView.center;
         toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
     } completion:^(BOOL finished)
     {
         weakSelf.snapshotBlurPresented.alpha = 1;
         weakSelf.backdropBlurPresented.alpha = 1;
         [transitionContext completeTransition:YES];
     }];
}


-(void)executeDismissalAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    self.snapshotBlurPresented.alpha = 0;
    self.backdropBlurPresented.alpha = 0;

    AJFathomTransitionController * __weak weakSelf = self;

    [UIView animateWithDuration:(self.dismissDuration * .5) delay:0 usingSpringWithDamping:1 initialSpringVelocity:self.initialSpringVelocity options:self.animationOutOptions animations:^
     {
         fromViewController.view.center = [weakSelf centerOfRect:weakSelf.boundsStart];
         fromViewController.view.transform = CGAffineTransformScale(fromViewController.view.transform, weakSelf.boundsStart.size.width / weakSelf.boundsEnd.size.width, weakSelf.boundsStart.size.height / weakSelf.boundsEnd.size.height);
     } completion:^(BOOL finished) {
     }];

    [UIView animateWithDuration:(self.dismissDuration * .25) delay:(self.dismissDuration * .25) usingSpringWithDamping:1 initialSpringVelocity:self.initialSpringVelocity options:self.animationOutOptions animations:^
     {
         fromViewController.view.alpha = 0;
     } completion:^(BOOL finished) {
     }];

    [UIView animateWithDuration:self.dismissDuration delay:0 usingSpringWithDamping:self.springWithDampening initialSpringVelocity:self.initialSpringVelocity options:self.animationOutOptions animations:^
     {
         weakSelf.backdropBlur.alpha = 0;
         weakSelf.snapshotBlur.alpha = 0;
         weakSelf.snapshot.transform = CGAffineTransformMakeScale(1,1);
         weakSelf.snapshotBlur.transform = CGAffineTransformMakeScale(1,1);
     } completion:^(BOOL finished)
     {
         [weakSelf.snapshotBlur removeFromSuperview];
         [weakSelf.backdrop removeFromSuperview];
         [weakSelf.snapshot removeFromSuperview];
         [weakSelf.backdropBlur removeFromSuperview];
         [weakSelf.snapshotBlurPresented removeFromSuperview];
         [weakSelf.backdropBlurPresented removeFromSuperview];
         weakSelf.backdropBlur = nil;
         weakSelf.snapshot = nil;
         weakSelf.snapshotBlur = nil;
         weakSelf.backdrop = nil;
         weakSelf.snapshotBlurPresented = nil;
         weakSelf.backdropBlurPresented = nil;
         [transitionContext completeTransition:YES];
    }];
}


#pragma mark - UIViewControllerTransitioningDelegate


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresented = YES;
    return self;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresented = NO;
    return self;
}


@end