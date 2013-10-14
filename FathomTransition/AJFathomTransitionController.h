//
//  AJFathomTransitionController.h
//  iStock
//
//  Created by Andrew James on 10/3/13.
//  Copyright (c) 2013 Getty Images. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJFathomTransitionController : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

+(id)fathomTransition;

// Sets the number of seconds to animate the 'presentation'
@property (nonatomic)CGFloat presentDuration;

// Sets the number of seconds to animate the 'dismissal'
@property (nonatomic)CGFloat dismissDuration;

// Used to determine whether to show the presentation animation or the dismissal animation.
@property (nonatomic)BOOL isPresented;

// The frame in the 'presenting' view that the 'presented' view will zoom out of
@property (nonatomic)CGRect boundsStart;

// The frame in the 'presented' view that will be moved from the boundsStart to the final position
@property (nonatomic)CGRect boundsEnd;

// The scale used to 'zoom back' the 'presenting' view (Range:0-1; 0=max zoom; 1=no zoom)
@property (nonatomic)CGFloat zoomFactor;

// The amout of blur on the 'presenting' view ( 0 - 1 )
@property (nonatomic)CGFloat blurRadius;

// The amount of desaturation to apply to the blur (Range:0-1; 0=no color; 1=full color)
@property (nonatomic)CGFloat saturationDeltaFactor;

// The amount of 'friction' to apply to the spring effect (Range:0-1; 0=max spring dampening; 1=no spring/fully dampened)
@property (nonatomic)CGFloat springWithDampening;

// The amount of force to apply the spring (Range:0+; 0=no springiness; 5=very springy; 5+=crazy springy)
@property (nonatomic)CGFloat initialSpringVelocity;

// The options for the 'presenting' animation (Default: UIViewAnimationOptionCurveEaseOut)
@property (nonatomic)UIViewAnimationOptions animationInOptions;

// The options for the 'dismissing' animation (Default: UIViewAnimationOptionCurveEaseIn)
@property (nonatomic)UIViewAnimationOptions animationOutOptions;

// The color to use to fill in the area behind the presenting view (default: best guess)
@property (nonatomic, strong)UIColor *backdropColor;

// The color used to tint the
@property (nonatomic, strong)UIColor *tintColor;

// An image used to mask the blur (but not the tint)
@property (nonatomic, strong)UIImage *maskImage;
@end