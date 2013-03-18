//
//  ViewController.h
//  Calc
//
//  Created by Naomi O' Reilly on 16/02/2013.
//  Copyright (c) 2013 Naomi O' Reilly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcModel.h"

@interface ViewController : UIViewController
@property (nonatomic,weak) IBOutlet UILabel *calcDisplay;
@property (nonatomic,strong) IBOutlet CalcModel *calcModel;
@property (nonatomic) BOOL isInTheMiddleOfTypingSomething;
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction) setOrAccessUserDefaults:(UIButton *) sender;
@end