//
//  EmptyViewController.m
//  TestProject
//
//  Created by Boris Godin on 06.03.15.
//  Copyright (c) 2015 MonsoonCo. All rights reserved.
//

#import "EmptyViewController.h"

@implementation EmptyViewController

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
