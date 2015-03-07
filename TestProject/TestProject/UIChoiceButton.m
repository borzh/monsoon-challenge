//
//  UIChoiceButton.m
//  TestProject
//
//  Created by Boris Godin on 06.03.15.
//  Copyright (c) 2015 MonsoonCo. All rights reserved.
//

#import "UIChoiceButton.h"


@interface UIChoiceButtonArcsView: UIView
@property (nonatomic, assign) NSUInteger arcsCount;
@property (nonatomic, assign) CGFloat spaceAngle;
@end


@implementation UIChoiceButtonArcsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _arcsCount = 2;
        _spaceAngle = 5.0f;
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _arcsCount = 2;
        _spaceAngle = 5.0f;
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGFloat lineWidth = 1.0f;
    CGRect borderRect = CGRectInset(rect, 5.0f, 5.0f);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.25f);

    // Draw transparent circle.
    CGContextFillEllipseInRect(context, borderRect);

    CGPoint center = CGPointMake(rect.origin.x + (rect.size.width/2), rect.origin.y + (rect.size.height/2));
    CGFloat radius = MAX(rect.size.width, rect.size.height)/2 - 2.0f;

    CGFloat radSpaceAngle = _spaceAngle * M_PI / 180.0f; // To radians.

    CGFloat angleStep = 360.0f / _arcsCount;
    angleStep = angleStep * M_PI / 180.0f;

    // Red color arc.
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 1.0f, 0.4f, 0.45f, 0.8f); // FF6772
    CGContextAddArc(context, center.x, center.y, radius, radSpaceAngle, (_arcsCount > 1) ? angleStep - radSpaceAngle : angleStep, 0);
    CGContextDrawPath(context, kCGPathStroke);

    // Dark red color arc.
    CGContextSetRGBStrokeColor(context, 0.4f, 0.02f, 0.17f, 0.8f); // 66062C
    for (int i=1; i < self.arcsCount; ++i) {
        //NSLog(@"%f %f", i*angleStep + radSpaceAngle, (i+1)*angleStep - radSpaceAngle);
        CGContextBeginPath(context);
        CGContextAddArc(context, center.x, center.y, radius, i*angleStep + radSpaceAngle, (i+1)*angleStep - radSpaceAngle, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
    //NSLog(@"\n");
}

@end



@interface UIChoiceButton ()
@property (nonatomic, weak) UIChoiceButtonArcsView *arcs;
@end


@implementation UIChoiceButton

- (void)initialize
{
    UIChoiceButtonArcsView *arcs = [[UIChoiceButtonArcsView alloc] init];
    arcs.userInteractionEnabled = NO;
    arcs.frame = self.bounds;
    [self addSubview:arcs];

    _arcs = arcs;

    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)touchUpInside:(id)sender
{
    NSUInteger total = [_choices count];
    if (total) { // Avoid division by 0.
        NSUInteger newChoice = (_currentChoice+1) % total;
        [self setCurrentChoice:newChoice];
    }
}

- (void)setFrame:(CGRect)frame
{
    _arcs.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    [super setFrame:frame];
}

- (void)setChoices:(NSArray *)choices
{
    _choices = choices;
    _currentChoice = 0;

    _arcs.arcsCount = [choices count];
    [self setTitle:[_choices objectAtIndex:_currentChoice] forState:UIControlStateNormal];
    _arcs.transform = CGAffineTransformMakeRotation(M_PI_2);
    [_arcs setNeedsDisplay];
}

- (void)setCurrentChoice:(NSUInteger)currentChoice
{
    NSUInteger total = [_choices count];
    if (currentChoice < total) {
        _currentChoice = currentChoice;
        _arcs.arcsCount = total;
        [self setTitle:[_choices objectAtIndex:currentChoice] forState:UIControlStateNormal];

        __weak typeof(self) weakSelf = self;

        // Next code has errors when rotating by 180, sometimes rotates clockwise sometimes counterclockwise.
        /*
        [UIView animateWithDuration:0.25f animations:^{
            if ([weakSelf.choices count]) { //
                weakSelf.arcs.transform = CGAffineTransformMakeRotation(M_PI_2 + 2.0f * M_PI * weakSelf.currentChoice / [weakSelf.choices count]);
            }
        }];
         */

        CGFloat angle = 2.0f * M_PI / [_choices count];

        [CATransaction begin];
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.byValue = [NSNumber numberWithFloat:angle];
        rotationAnimation.duration = 0.25f;
        rotationAnimation.removedOnCompletion = YES;
        rotationAnimation.fillMode = kCAFillModeForwards;

        [CATransaction setCompletionBlock:^{
            [weakSelf.arcs.layer removeAllAnimations];
            weakSelf.arcs.transform = CGAffineTransformMakeRotation(M_PI_2 + 2.0f * M_PI * weakSelf.currentChoice / [_choices count]);
        }];

        [self.arcs.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [CATransaction commit];


    }
}

@end
