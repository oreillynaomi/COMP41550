//
//  PolygonView.m
//  HelloPoly
//
//  Created by Naomi O' Reilly on 20/01/2013.
//  Copyright (c) 2013 Naomi O' Reilly. All rights reserved.
//

#import "PolygonView.h"
#import "ViewController.h"
#import "PolygonShape.h"

@implementation PolygonView
@synthesize numberOfSidesLabel = _numberOfSidesLabel;
@synthesize points = _points;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"numSides"]){
        _numberOfSides = [[NSUserDefaults standardUserDefaults] integerForKey:@"numSides"];
    }
    else {
        _numberOfSides = [self.numberOfSidesLabel.text integerValue];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    _points = [[self class] pointsForPolygonInRect:self.bounds numberOfSides:_numberOfSides];
    CGContextBeginPath(context);
    
    CGPoint currentPoint = [[_points objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
    for (int i = 1; i < _points.count; i++) {
        currentPoint = [[_points objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    CGContextClosePath(context);
    [[UIColor purpleColor] setFill];
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(context,kCGPathFillStroke);
}

- (void)updatePoints {
    _points = [[self class] pointsForPolygonInRect:self.bounds numberOfSides:_numberOfSides];
    [self setNeedsDisplayInRect:self.bounds];
}

+ (NSArray *)pointsForPolygonInRect:(CGRect)rect numberOfSides:(int)numberOfSides {
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    float radius = 0.9 * center.x; NSMutableArray *result = [NSMutableArray array];
    float angle = (2.0 * M_PI) / numberOfSides;
    float exteriorAngle = M_PI - angle;
    float rotationDelta = angle - (0.5 * exteriorAngle);
    
    for (int currentAngle = 0; currentAngle < numberOfSides; currentAngle++) {
        float newAngle = (angle * currentAngle) - rotationDelta;
        float curX = cos(newAngle) * radius;
        float curY = sin(newAngle) * radius;
        [result addObject:[NSValue valueWithCGPoint:CGPointMake(center.x+curX,center.y+curY)]];
    }
    return result;
}

@end
