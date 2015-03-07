//
//  UIChoiceButton.h
//  TestProject
//
//  Created by Boris Godin on 06.03.15.
//  Copyright (c) 2015 MonsoonCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIChoiceButton : UIButton

@property (nonatomic, strong) NSArray *choices;
@property (nonatomic, assign) NSUInteger currentChoice;

@end
