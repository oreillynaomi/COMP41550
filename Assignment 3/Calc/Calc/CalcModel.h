//
//  CalcModel.h
//  Calc
//
//  Created by Naomi O' Reilly on 16/02/2013.
//  Copyright (c) 2013 Naomi O' Reilly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcModel : NSObject

@property (nonatomic) double operand;
@property (nonatomic) double waitingOperand;
@property (nonatomic,strong) NSString *waitingOperation;
@property (readonly,strong) id expression;

- (double)performOperation:(NSString *)operation;
- (void)setLiteralAsOperand:(NSString *)variableName;
- (void)setVariableAsOperand:(NSString *)variableName;
+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables;
+ (NSSet *)variablesInExpression:(id)anExpression;
- (NSString *)descriptionOfExpression:(id)anExpression;
+ (id)propertyListForExpression:(id)anExpression;
- (id)expressionForPropertyList:(id)propertyList;
@end

