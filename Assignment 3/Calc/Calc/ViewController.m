//
//  ViewController.m
//  Calc
//
//  Created by Naomi O' Reilly on 16/02/2013.
//  Copyright (c) 2013 Naomi O' Reilly. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize calcModel = _calcModel;
@synthesize calcDisplay = _calcDisplay;
@synthesize isInTheMiddleOfTypingSomething = _isInTheMiddleOfTypingSomething;

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.titleLabel.text;
    if(self.isInTheMiddleOfTypingSomething)
        self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
    else {
        [self.calcDisplay setText:digit];
        self.isInTheMiddleOfTypingSomething = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.isInTheMiddleOfTypingSomething) {
        self.calcModel.operand = [self.calcDisplay.text doubleValue];
        self.isInTheMiddleOfTypingSomething = NO;
    }
    NSString *operation = [[sender titleLabel] text];
    double result = [[self calcModel] performOperation:operation];
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", result]];
}

@end