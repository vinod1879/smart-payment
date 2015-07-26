//
//  VVValidatedTextField.m
//  SmartPayment
//
//  Created by Vinod Vishwanath on 26/07/15.
//  Copyright (c) 2015 Vinod Vishwanath. All rights reserved.
//

#import "VVValidatedTextField.h"

@interface VVValidatedTextField ()<UITextFieldDelegate>

@property (nonatomic, weak) id<UITextFieldDelegate> replacementDelegate;

@end

/**
 Implementation of VVValidtedTextField
 */

@implementation VVValidatedTextField

#pragma mark - Setup

-(id)init
{
    self = [super init];
    
    [self setup];
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setup];
    
    return self;
}

-(void)awakeFromNib
{
    [self setup];
}

-(void)setup
{
    self.delegate       =   self;
}

/**
 We override the `setDelegate` method to prevent objects other than `self` from being
 delegates of the current instance.
 When an instance of another class is set as delegate, it is instead assigned to
 `replacementDelegate`, and delegate methods are passed to the replacement delegate
 for all methods except `textField:shouldChangeCharactersInRange:replacementString`.
 */
-(void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    if(delegate == self)
    {
        [super setDelegate:delegate];
    }
    else
    {
        self.replacementDelegate = delegate;
    }
}

#pragma mark - Overrides provided for subclasses

-(void)postSetupActions
{
    
}


-(BOOL)allowChangeOfCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

#pragma mark - UITextField delegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self allowChangeOfCharactersInRange:range replacementString:string];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.replacementDelegate &&
       [self.replacementDelegate respondsToSelector:@selector(textFieldShouldReturn:)])
    {
        return [self.replacementDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(self.replacementDelegate &&
       [self.replacementDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
    {
        return [self.replacementDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(self.replacementDelegate &&
       [self.replacementDelegate respondsToSelector:@selector(textFieldShouldClear:)])
    {
        return [self.replacementDelegate textFieldShouldClear:textField];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.replacementDelegate &&
       [self.replacementDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
    {
        return [self.replacementDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.replacementDelegate &&
       [self.replacementDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
    {
        [self.replacementDelegate textFieldDidBeginEditing:textField];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.replacementDelegate &&
       [self.replacementDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
    {
        [self.replacementDelegate textFieldDidEndEditing:textField];
    }
}

@end
