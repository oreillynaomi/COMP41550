//
//  ViewController.m
//  HelloPoly
//
//  Created by Naomi O' Reilly on 19/01/2013.
//  Copyright (c) 2013 Naomi O' Reilly. All rights reserved.
//

#import "ViewController.h"
#import "PolygonView.h"

@implementation ViewController
@synthesize numberOfSidesLabel = _numberOfSidesLabel;
@synthesize model = _model;

- (IBAction)decrease:(UIButton *)sender {
    if ([self.numberOfSidesLabel.text integerValue] > 3 ) {
        self.numberOfSidesLabel.text = [NSString stringWithFormat:@"%d", [self.numberOfSidesLabel.text integerValue] - 1];
        self.model.numberOfSides = [self.numberOfSidesLabel.text integerValue];
        self.polygonName.text = self.model.name;
        [self updateView ];
        [[NSUserDefaults standardUserDefaults]  setInteger:self.model.numberOfSides  forKey:@"numSides"];
        [[NSUserDefaults standardUserDefaults ] synchronize];
    }
}

- (IBAction)increase:(UIButton *)sender {
    if ([self.numberOfSidesLabel.text integerValue] < 12 ) {
        self.numberOfSidesLabel.text = [NSString stringWithFormat:@"%d", [self.numberOfSidesLabel.text integerValue] + 1];
        self.model.numberOfSides = [self.numberOfSidesLabel.text integerValue];
        self.polygonName.text = self.model.name;
        [self updateView];
        
        [[NSUserDefaults standardUserDefaults]  setInteger:self.model.numberOfSides  forKey:@"numSides"];
        [[NSUserDefaults standardUserDefaults ] synchronize];
    }
}

- (void)updateView{
    [self.PolygonView updatePoints];
}

- (void)viewDidLoad {
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"numSides"]){
        self.model.numberOfSides = [[NSUserDefaults standardUserDefaults] integerForKey:@"numSides"];
        self.numberOfSidesLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"numSides"];
        self.polygonName.text = self.model.name;
    }
    else {
        self.model.numberOfSides = [self.numberOfSidesLabel.text integerValue];
        self.polygonName.text = self.model.name;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"numSides"];
    }
}

- (void)viewDidUnload {
    [self setNumberOfSidesLabel:nil];
    [self setModel:nil];
    [super viewDidUnload];
}

@end