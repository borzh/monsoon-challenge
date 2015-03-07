//
//  ViewController.m
//  TestProject
//
//  Created by Boris Godin on 05.03.15.
//  Copyright (c) 2015 MonsoonCo. All rights reserved.
//

#import "ViewController.h"
#import "UIChoiceButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIChoiceButton *button1;
@property (weak, nonatomic) IBOutlet UIChoiceButton *button2;
@property (weak, nonatomic) IBOutlet UIChoiceButton *button3;
@property (weak, nonatomic) IBOutlet UIChoiceButton *button4;
@property (weak, nonatomic) IBOutlet UIChoiceButton *button5;
@property (weak, nonatomic) IBOutlet UIChoiceButton *button6;

@property (strong, nonatomic) NSMutableArray *texts; // Array of arrays of text.
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray *texts = [[NSMutableArray alloc] initWithCapacity:6];
    [texts addObject:[NSArray arrayWithObjects:@"ONE OF A KIND", @"SMALL BATCH", @"LARGE BATCH", @"MASS MARKET", nil]];
    [texts addObject:[NSArray arrayWithObjects:@"SAVORY", @"SWEET", @"UMAMI", nil]];
    [texts addObject:[NSArray arrayWithObjects:@"SPICY", @"MILD", nil]];
    [texts addObject:[NSArray arrayWithObjects:@"CRUNCHY", @"MUSHY", @"SMOOTH", nil]];
    [texts addObject:[NSArray arrayWithObjects:@"A LITTLE", @"A LOT", nil]];
    [texts addObject:[NSArray arrayWithObjects:@"BREAKFAST", @"BRUNCH", @"LUNCH", @"SNACK", @"DINNER", nil]];
    self.texts = texts;

    [self setButtons];
}

- (void)setButtons
{
    self.button1.choices = [self.texts objectAtIndex:0];
    self.button2.choices = [self.texts objectAtIndex:1];
    self.button3.choices = [self.texts objectAtIndex:2];
    self.button4.choices = [self.texts objectAtIndex:3];
    self.button5.choices = [self.texts objectAtIndex:4];
    self.button6.choices = [self.texts objectAtIndex:5];
}

- (IBAction)shuffleButtons:(id)sender
{
    NSUInteger totalCount = [_texts count];
    for (NSUInteger i = 0; i < totalCount; ++i) {
        // Select a random element between i and end of array to swap with.
        NSUInteger count = totalCount - i;
        NSUInteger n = (arc4random() % count) + i;
        [_texts exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

    [self setButtons];
}
@end
