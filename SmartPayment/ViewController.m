//
//  ViewController.m
//  SmartPayment
//
//  Created by Vinod Vishwanath on 18/07/15.
//  Copyright (c) 2015 Vinod Vishwanath. All rights reserved.
//

#import "ViewController.h"
#import "VVCardNumberTextField.h"

@interface ViewController ()

@property IBOutlet VVCardNumberTextField *cardNumberField;
@property IBOutlet VVValidatedTextField *email;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.email setInputType:VVInputTypeEmail];
    [self.email addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChange:(id)sender
{
    if([self.email isValid])
    {
        UIAlertView *av = [[UIAlertView alloc]
                           initWithTitle:@"Valid"
                           message:@"Valid"
                           delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
        
        [av show];
    }
}

@end
