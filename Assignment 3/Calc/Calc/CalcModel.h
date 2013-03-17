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
- (double)performOperation:(NSString *)operation;

@end
