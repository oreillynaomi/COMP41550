//
//  ViewController.m
//  Calc
//
//  Created by Naomi O' Reilly on 16/02/2013.
//  Copyright (c) 2013 Naomi O' Reilly. All rights reserved.
//

#import "ViewController.h"
#import "Math.h"

@implementation ViewController
@synthesize calcModel = _calcModel;
@synthesize calcDisplay = _calcDisplay;
@synthesize isInTheMiddleOfTypingSomething = _isInTheMiddleOfTypingSomething;

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.titleLabel.text;
    if(self.isInTheMiddleOfTypingSomething)
        if([@"." isEqualToString:digit]) {
            if([_calcDisplay.text rangeOfString:@"."].location != NSNotFound){
                return;
            } else {
                self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
            }
        } else {
            self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
        }
    else {
        [self.calcDisplay setText:digit];
        self.isInTheMiddleOfTypingSomething = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.isInTheMiddleOfTypingSomething) {
        [self.calcModel setLiteralAsOperand:[self.calcDisplay text]];
        //self.calcModel.operand = [self.calcDisplay.text doubleValue];
        self.isInTheMiddleOfTypingSomething = NO;
    }
    NSString *operation = [[sender titleLabel] text];
    double result = [[self calcModel] performOperation:operation];
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", result]];
}

- (IBAction)callOperation:(UIButton *)sender {
    [ self.calcModel setVariableAsOperand:[[sender titleLabel] text] ];
}

- (IBAction)testEvaluate:(UIButton *)sender {
    NSMutableDictionary *vars = [[NSMutableDictionary alloc] init];
    [vars setObject:@"10" forKey:@"a"];
    [vars setObject:@"20" forKey:@"b"];
    [vars setObject:@"30" forKey:@"x"];
    double result = [CalcModel evaluateExpression:[self.calcModel expression] usingVariableValues:vars];
    
    self.calcDisplay.text = [NSString stringWithFormat:@"%f", result];
}


- (IBAction) setOrAccessUserDefaults:(UIButton *) sender {
    NSString *operation = [[sender titleLabel] text];
    if([@"STO" isEqualToString:operation]){
        [[NSUserDefaults standardUserDefaults] setDouble:_calcDisplay.text.doubleValue forKey:@"savedDisplayValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if([@"RCL" isEqualToString:operation]) {
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"savedDisplayValue"]){
            self.calcDisplay.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedDisplayValue"];
        } else {
            return;
        }
    } else if([@"M+" isEqualToString:operation]) {
        double subtotal = _calcDisplay.text.doubleValue + [[NSUserDefaults standardUserDefaults] doubleForKey:@"savedDisplayValue"];
        [[NSUserDefaults standardUserDefaults] setDouble:subtotal forKey:@"savedDisplayValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end