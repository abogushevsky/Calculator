//
//  CalculatorBrain.h
//  Calculator
//
//  Created by NamelessMobile on 03.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void) pushOperand: (double) operand;
-(double) performOperation: (NSString *)operation;
-(void) clear;;

@property (nonatomic, readonly) id program;

+(double)runProgram:(id)program;
+(NSString *)descriptionOfProgram:(id)program;

@end