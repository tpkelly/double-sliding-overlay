//
//  ViewController.m
//  DoubleSlidingOverlay
//
//  Created by Thomas Kelly on 20/06/2013.
//
//  Copyright 2013 Scott Logic
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#import "ViewController.h"
#import <ShinobiEssentials/ShinobiEssentials.h>

@implementation ViewController
{
    SEssentialsSlidingOverlay *leftOverlay;
    SEssentialsSlidingOverlay *rightOverlay;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Set up right
    rightOverlay = [[SEssentialsSlidingOverlay alloc] initWithFrame:self.view.frame andToolbar:NO];
    rightOverlay.underlayLocation = SEssentialsSlidingOverlayLocationRight;
    [self.view addSubview:rightOverlay];
    
    //Set up left
    leftOverlay = [[SEssentialsSlidingOverlay alloc] initWithFrame:self.view.frame];
    [rightOverlay addSubview:leftOverlay];

    //Set up delegates
    rightOverlay.gestureRecognizer.delegate = self;
    leftOverlay.gestureRecognizer.delegate = self;
    
    //Set up toolbar button
    UIButton *button = [self createCloneButton];
    button.center = CGPointMake(self.view.bounds.size.width - 40, 25);
    [button addTarget:rightOverlay action:@selector(toggleUnderlayAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [leftOverlay.toolbar addSubview:button];
}

-(UIButton*)createCloneButton
{
    //Setup
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = leftOverlay.toolbar.button.bounds;

    //Styling
    button.backgroundColor = leftOverlay.style.buttonTintColor;
    [button setImage:leftOverlay.style.buttonImage forState:UIControlStateNormal];
    [button setImage:leftOverlay.style.buttonPressedImage forState:UIControlStateHighlighted];
    
    //Masking
    UIImageView *maskView = [[UIImageView alloc] initWithImage:leftOverlay.style.buttonMask];
    maskView.frame = leftOverlay.toolbar.button.layer.bounds;
    button.layer.mask = maskView.layer;
    
    return button;
}

#pragma mark - Gesture Delegate methods
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch
{
    //Only open the underlay if the other underlay is hidden
    return [[self otherView:gesture] underlayHidden];
}

-(SEssentialsSlidingOverlay*)otherView:(UIGestureRecognizer*)gesture
{
    return (gesture.view == rightOverlay) ? leftOverlay : rightOverlay;
}

@end
