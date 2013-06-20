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
    SEssentialsSlidingOverlay *innerlay;
    SEssentialsSlidingOverlay *overlay;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Set up right
    overlay = [[SEssentialsSlidingOverlay alloc] initWithFrame:self.view.frame andToolbar:NO];
    overlay.underlayLocation = SEssentialsSlidingOverlayLocationRight;
    [self.view addSubview:overlay];
    
    //Set up left
    innerlay = [[SEssentialsSlidingOverlay alloc] initWithFrame:self.view.frame];
    [overlay addSubview:innerlay];

    //Set up delegates
    overlay.gestureRecognizer.delegate = self;
    innerlay.gestureRecognizer.delegate = self;
    
    //Set up toolbar button
    UIButton *button = [self createCloneButton];
    button.center = CGPointMake(self.view.bounds.size.width - 40, 25);
    [button addTarget:overlay action:@selector(toggleUnderlayAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [innerlay.toolbar addSubview:button];
}

-(UIButton*)createCloneButton
{
    //Setup
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = innerlay.toolbar.button.bounds;

    //Styling
    button.backgroundColor = innerlay.style.buttonTintColor;
    [button setImage:innerlay.style.buttonImage forState:UIControlStateNormal];
    [button setImage:innerlay.style.buttonPressedImage forState:UIControlStateHighlighted];
    
    //Masking
    UIImageView *maskView = [[UIImageView alloc] initWithImage:innerlay.style.buttonMask];
    maskView.frame = innerlay.toolbar.button.layer.bounds;
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
    return (gesture.view == overlay) ? innerlay : overlay;
}

@end
