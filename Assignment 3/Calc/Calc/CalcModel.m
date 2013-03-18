//
//  CalcModel.m
//  Calc
//
//  Created by Naomi O' Reilly on 16/02/2013.
//  Copyright (c) 2013 Naomi O' Reilly. All rights reserved.
//

#import "CalcModel.h"
#import "Math.h"

@implementation CalcModel

@synthesize operand = _operand;
@synthesize waitingOperand = _waitingOperand;
@synthesize waitingOperation = _waitingOperation;

- (void)performWaitingOperation
{
    if([@"+" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand + self.operand;
    else if([@"-" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand - self.operand;
    else if([@"*" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand * self.operand;
    else if([@"/" isEqualToString:self.waitingOperation])
        if(self.operand) self.operand = self.waitingOperand / self.operand;
}

- (double)performOperation:(NSString *)operation {
    if([operation isEqual:@"sqrt"])
        self.operand = sqrt(self.operand);
    else if([@"+/-" isEqualToString:operation]) {
        self.operand = - self.operand;
    }
    else if([@"1/x" isEqualToString:operation]) {
        if(self.operand == 0) {
            return self.operand;
        } else {
            self.operand = 1 / self.operand;
        }
    }
    else if([@"sin" isEqualToString:operation]) {
        self.operand = sin(self.operand);
    }
    else if([@"cos" isEqualToString:operation]) {
        self.operand = cos(self.operand);
    }
    else if([@"C" isEqualToString:operation]) {
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedDisplayValue"];
    }
    else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    return self.operand;
}

- (void)setVariableAsOperand:(NSString *)variableName {
    
}

+ (double)evaluateExpression:(id)anExpressionusingVariableValues:(NSDictionary *)variables {
    
}

+ (NSSet *)variablesInExpression:(id)anExpression {
    
}

- (NSString *)descriptionOfExpression:(id)anExpression {
    
}

+ (id)propertyListForExpression:(id)anExpression {
    
}

- (id)expressionForPropertyList:(id)propertyList {
    
}

@end
