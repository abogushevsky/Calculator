//
//  CalculatorBrain.m
//  Calculator
//
//  Created by NamelessMobile on 03.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

-(NSMutableArray *)programStack
{
    if(!_programStack)
    {
        _programStack = [[NSMutableArray alloc] init];
    }
    
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

-(void) clear
{
    [self.programStack removeAllObjects];
}

-(void) pushOperand: (double) operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

-(void) pushVariable: (NSString *) variable
{
    [self.programStack addObject:variable];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
                usingVariableValues: (NSDictionary *)variableValues
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        
        id variableValue = [variableValues valueForKey:operation];
        if(variableValue != nil && [variableValue isKindOfClass:[NSNumber class]])
        {
            result = [variableValue doubleValue];
        }
        if([operation isEqualToString:@"+"])
        {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] +
                     [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        }
        else if([@"*" isEqualToString:operation])
        {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] *
                     [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        }
        else if([operation isEqualToString:@"-"])
        {
            double subtrahend = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] - subtrahend;
        }
        else if([operation isEqualToString:@"/"])
        {
            double divisor = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if(divisor) result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] / divisor;
        }
        else if([operation isEqualToString:@"sin"])
        {
            result = sin([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        }
        else if([operation isEqualToString:@"cos"])
        {
            result = cos([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        }
        else if([operation isEqualToString:@"sqrt"])
        {
            result = sqrt([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        }
        else if([operation isEqualToString:@"pi"])
        {
            result = 3.14;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack usingVariableValues:nil];
}

+(double)runProgram:(id)program
                usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
}

@end
