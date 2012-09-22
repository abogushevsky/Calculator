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

+(NSSet *)variablesUsedInProgram: (id)program
{
    NSMutableArray *arrayOfVariables = [[NSMutableArray alloc] init];
    
    if([program isKindOfClass:[NSArray class]])
    {
        for (id element in program)
        {
            if([element isKindOfClass:[NSString class]])
            {
                if(![self isOperation:element])
                {
                    [arrayOfVariables addObject:element];
                }
            }
        }
    }
    
    if([arrayOfVariables count] == 0)
    {
        return nil;
    }
    
    return [[NSSet alloc] initWithArray:arrayOfVariables];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    NSString *result = @"";
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        while (YES)
        {
            NSString *operandDescription = [self popOperandDescriptionOffTheStack:stack];
            
            if(operandDescription == nil)
            {
                break;
            }
            
            if(result.length > 0)
            {
                result = [result stringByAppendingFormat:@", %@", operandDescription];
            }
            else
            {
                result = operandDescription;
            }
        }
    }
    
    return result;
}

+(NSString *)popOperandDescriptionOffTheStack:(NSMutableArray *)programStack
{
    NSString *result = nil;
    id topOfStack = [programStack lastObject];
    if(topOfStack) [programStack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack description];
    }
    else if([self isTwoOperandOperation:topOfStack] && programStack.count >= 2)
    {
        NSString *firstOperand = [self popOperandDescriptionOffTheStack:programStack];
        NSString *secondOperand = [self popOperandDescriptionOffTheStack:programStack];
        
        if(firstOperand && secondOperand)
        {
            result = [[NSString alloc] initWithFormat:@"(%@ %@ %@)", firstOperand, topOfStack, secondOperand];
        }
    }
    else if([self isSingleOperandOperation:topOfStack] && programStack.count >= 1)
    {
        NSString *firstOperand = [self popOperandDescriptionOffTheStack:programStack];
        
        if(firstOperand)
        {
            result = [[NSString alloc] initWithFormat:@"%@(%@)", topOfStack, firstOperand];
        }
    }
    else if([self isNoOperandOperation:topOfStack])
    {
        result = topOfStack;
    }
    
    return result;
}

+(BOOL)isOperation: (NSString *)operation
{
    return [self isTwoOperandOperation:operation] ||
           [self isSingleOperandOperation:operation] ||
           [self isNoOperandOperation:operation];
}

+(BOOL)isTwoOperandOperation: (NSString *)operation
{
    return ([operation isEqualToString:@"+"] ||
            [operation isEqualToString:@"-"] ||
            [operation isEqualToString:@"*"] ||
            [operation isEqualToString:@"/"]);
}

+(BOOL)isSingleOperandOperation: (NSString *)operation
{
    return ([operation isEqualToString:@"sin"] ||
            [operation isEqualToString:@"cos"] ||
            [operation isEqualToString:@"sqrt"]);
}

+(BOOL)isNoOperandOperation: (NSString *)operation
{
    return [operation isEqualToString:@"pi"];
}

@end
