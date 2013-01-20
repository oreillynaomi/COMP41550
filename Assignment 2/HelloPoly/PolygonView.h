//
//  PolygonView.h
//  HelloPoly
//
//  Created by Naomi O' Reilly on 20/01/2013.
//  Copyright (c) 2013 Naomi O' Reilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonShape.h"

@interface PolygonView : UIView
@property (assign,nonatomic) int numberOfSides;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSidesLabel;
@property (weak, nonatomic) NSArray *points;
- (void)updatePoints;
@end
