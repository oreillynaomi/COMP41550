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
@synthesize expression = _expression;

- (id)init
{
    self = [super init];
    if (self)
    {
        _expression = [[NSMutableArray alloc] init];
    }
    return self;
}

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
    [_expression addObject:[NSString stringWithFormat:@"operation %@", operation]];
    
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

- (void)setLiteralAsOperand:(NSString *)variableName{
    [_expression addObject:[NSString stringWithFormat:@"operand_literal %@", variableName]];
    self.operand = variableName.doubleValue;
}


- (void)setVariableAsOperand:(NSString *)variableName{
    [_expression addObject:[NSString stringWithFormat:@"operand_variable %@", variableName]];
}
    
+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables {
    
    double result = 0;
    NSString *operation;
    CalcModel *model = [[CalcModel alloc] init];
    
    for (NSString* str in anExpression)
    {
        if([str hasPrefix:@"operation"])
        {
            operation = [str substringFromIndex:10];
            result = [model performOperation:operation];
        }
        else if([str hasPrefix:@"operand_literal"])
        {
            NSString *op_str = [str substringFromIndex:16];
            [model setLiteralAsOperand:op_str];
        }
        else if([str hasPrefix:@"operand_variable"])
        {
            NSString *op_str = [variables objectForKey:[str substringFromIndex:17]];
            [model setLiteralAsOperand:op_str];
        }
    }
    
    return result;
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
