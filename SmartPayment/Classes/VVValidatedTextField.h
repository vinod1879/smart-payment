//
//  VVValidatedTextField.h
//  SmartPayment
//
//  Created by Vinod Vishwanath on 26/07/15.
//  Copyright (c) 2015 Vinod Vishwanath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVValidatedTextField : UITextField


/**
 The implementation of method returns 'NO' always.
 It is meant for subclasses to override and provide
 their own implementation.
 */
-(BOOL)allowChangeOfCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/**
 Called after `init` and `setup`. 
 Overriding subclasses can add any customizations here.
 */
-(void)postSetupActions;

@end
