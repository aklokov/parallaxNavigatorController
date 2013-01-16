//
//  ParallaxUINavigationController.m
//
//  Created by Alexey Klokov on 1/15/13.
//  Copyright (c) 2013. All rights reserved.
//

#import "ParallaxUINavigationController.h"
#import <QuartzCore/QuartzCore.h>
#define STEP 50

@interface ParallaxUINavigationController ()
{
    NSUInteger slidesCount;
    NSUInteger currentSlide;
}
-(void) backgroundInit;
@end

@implementation ParallaxUINavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backgroundInit];
}


-(void) backgroundInit
{
    if (self) {
        if ([UIApplication sharedApplication].windows.count > 0){
            UIWindow *mywindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
            if (mywindow) {
                slidesCount = 0; // init
                currentSlide = 0;
                UIView* backgroundView = [[UIView alloc] initWithFrame:mywindow.bounds];
                backgroundView.tag = 1110;
                NSString *background = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ParallaxBackground"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:background]];
                if (CGRectGetWidth(imageView.bounds) > CGRectGetWidth(backgroundView.bounds)) {
                    slidesCount = (CGRectGetWidth(imageView.bounds) - CGRectGetWidth(backgroundView.bounds)) / STEP;
                }
                imageView.tag = 2220;
                [backgroundView addSubview:imageView];
                backgroundView.backgroundColor = [UIColor redColor];
                [mywindow addSubview:backgroundView];
                [mywindow sendSubviewToBack:backgroundView];
            }
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated) {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.8;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.view.layer removeAllAnimations];
        
        [self.view.layer addAnimation:transition forKey:nil];
    }


    [super pushViewController:viewController animated:NO];

    if (currentSlide < slidesCount) {
        currentSlide++;
        UIWindow *mywindow = [UIApplication sharedApplication].keyWindow;
        UIView* backgroundView = [mywindow viewWithTag:1110];
    	
        UIImageView *imageView = (UIImageView *)[backgroundView viewWithTag:2220];
        [UIView animateWithDuration:0.8 animations:^{
            imageView.frame = CGRectOffset(imageView.frame, -STEP, 0);
        }];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{

    if (animated) {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.8;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.view.layer removeAllAnimations];
        [self.view.layer addAnimation:transition forKey:nil];
    }
    
    UIViewController *vc = [super popViewControllerAnimated:NO];
    
    if (currentSlide > 0) {
        currentSlide--;
        UIWindow *mywindow = [UIApplication sharedApplication].keyWindow;
        UIView* backgroundView = [mywindow viewWithTag:1110];
        
        UIImageView *imageView = (UIImageView *)[backgroundView viewWithTag:2220];
        [UIView animateWithDuration:0.8 animations:^{
            imageView.frame = CGRectOffset(imageView.frame, STEP, 0);
        }];
    }

    return vc;
}
@end
