//
//  CalculatorViewController.m
//  Calculator
//
//  Created by NamelessMobile on 30.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariablesValue;
-(void) addHistoryValue: (NSString *) value;

@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariablesValue = _testVariablesValue;

-(CalculatorBrain *) brain
{
    if(!_brain)
    {
        _brain = [[CalculatorBrain alloc] init];
    }
    
    return _brain;
}

-(NSDictionary *) testVariablesValue
{
    if(!_testVariablesValue)
    {
        _testVariablesValue = [[NSDictionary alloc] init];
    }
    
    return _testVariablesValue;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    
    if(self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else 
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)variablePressed:(UIButton *)sender
{
    NSString *variable = sender.currentTitle;
    
    self.display.text = variable;
    self.userIsInTheMiddleOfEnteringANumber = YES;
}

- (IBAction)undoPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        if(self.display.text.length == 0){
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
    else {
        [self.brain undo];
    }
    
    [self updateUI];
}

- (IBAction)dotPressed:(UIButton *)sender
{
    if(self.display.text.length > 0)
    {
        if([self.display.text rangeOfString:@"."].location == NSNotFound)
        {
            self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
}

- (IBAction)clearPressed 
{
    [self.brain clear];
    self.historyDisplay.text = @"";
    self.display.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if(self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    [self.brain pushOperation:operation];
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariablesValue];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    [self addHistoryValue: operation];
}

- (IBAction)enterPressed 
{
    if([self.display.text isEqualToString:@"x"] ||
       [self.display.text isEqualToString:@"y"] ||
       [self.display.text isEqualToString:@"z"])
    {
        [self.brain pushVariable:self.display.text];
    }
    else
    {
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    
    [self addHistoryValue: self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

-(void)addHistoryValue: (NSString *) value
{
    [self updateUI];
}

-(void) updateVariablesLabel
{
    NSString *result = @"";
    for (NSString *key in self.testVariablesValue.allKeys) {
        result = [NSString stringWithFormat: @"%@ %@ = %@", result, key, [self.testVariablesValue valueForKey:key]];
    }
    
    self.displayVariables.text = result;
}

-(void) updateUI
{
    [self updateVariablesLabel];
    self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [super viewDidUnload];
}
@end
