//
//  PolygonShape.m
//  HelloPoly
//
//  Created by comp41550 on 15/01/2013.
//  Copyright (c) 2013 comp41550. All rights reserved.
//

#import "PolygonShape.h"

@implementation PolygonShape
@synthesize numberOfSides = _numberOfSides;

- (id)init
{
    if (self = [super init])
    {
        self.numberOfSides = 3;
    }
    return self;
}

- (NSString *)name {
    NSArray *names = [NSArray
                      arrayWithObjects:@"Triangle",
                      @"Square",
                      @"Pentagon",
                      @"Hexagon",
                      @"Heptagon",
                      @"Octagon",
                      @"Nonagon",
                      @"Decagon",
                      @"Hendecagon",
                      @"Dodecagon",
                      nil];
    return [names objectAtIndex:self.numberOfSides - 3];
}

- (void)setNumberOfSides:(int)numberOfSides
{
    if ((numberOfSides < 3) || (numberOfSides > 12)) return;
    _numberOfSides = numberOfSides;
}

@end
