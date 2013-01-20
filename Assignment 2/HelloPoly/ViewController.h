//
//  ViewController.h
//  HelloPoly
//
//  Created by Naomi O' Reilly on 19/01/2013.
//  Copyright (c) 2013 Naomi O' Reilly. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PolygonShape.h"
#import "PolygonView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *numberOfSidesLabel;
@property (strong, nonatomic) IBOutlet PolygonShape *model;
@property (strong, nonatomic) IBOutlet PolygonView *PolygonView;
@property (weak, nonatomic) IBOutlet UILabel *polygonName;

- (IBAction)decrease:(id)sender;
- (IBAction)increase:(id)sender;

@end