//
//  CalculatorViewController.h
//  Calculator
//
//  Created by NamelessMobile on 30.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *historyDisplay;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)dotPressed:(UIButton *)sender;
- (IBAction)clearPressed;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)variablePressed:(UIButton *)sender;
- (IBAction)undoPressed:(UIButton *)sender;

@end
