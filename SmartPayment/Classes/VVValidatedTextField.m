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
    [self postSetupActions];
}

-(BOOL)isValid
{
    return [self validateForText:self.text];
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
    NSString *originalText = [self text];
    NSString *newText = [originalText stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger limit     = [self limitOnCharacters];
    NSString *subRegex  = [self regexOfAllowedCharacters];
    
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", subRegex];
    
    BOOL ac =  ([_pred evaluateWithObject:newText] && [newText length] <= limit);
    
    return ac;
}

#pragma mark - UITextField delegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = [self allowChangeOfCharactersInRange:range replacementString:string];
    
    if(shouldChange)
        [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return shouldChange;
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

#pragma mark - Validation Rules

-(BOOL)validateForText:(NSString*)text
{
    NSString *regex = [self regexOfValidInput];
    
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [_pred evaluateWithObject:text];
    
    return isValid;
}

-(NSUInteger)limitOnCharacters
{
    NSUInteger limit = 0;
    
    switch (self.inputType) {
        case VVInputTypeEmail:
            limit = 100;
            break;
        
        case VVInputTypeMobileNumber:
            limit = 10;
            break;
            
        case VVInputTypePassword:
            limit = 20;
            break;
            
        default:
            break;
    }
    
    return limit;
}

-(NSString*)regexOfAllowedCharacters
{
    NSString *subRegex = @"";
    
    switch (self.inputType) {
        case VVInputTypeEmail:
            subRegex = @"[a-zA-Z0-9_@.-]*";
            break;
            
        case VVInputTypeMobileNumber:
            subRegex = @"[0-9]*";
            break;
            
        case VVInputTypePassword:
            subRegex = @"[^\\s]*";
            break;
            
        default:
            break;
    }
 
    return subRegex;
}

-(NSString*)regexOfValidInput
{
    NSString *subRegex = @"";
    
    switch (self.inputType) {
        case VVInputTypeEmail:
            subRegex = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
            break;
            
        case VVInputTypeMobileNumber:
            subRegex = @"^[0-9]{10}$";
            break;
            
        case VVInputTypePassword:
            subRegex = @"^(?=.*?([A-Za-z]))(?=.*?[0-9])(?=.*?[\\{\\}\\[\\]\\(\\)#?!@$%^&*-+=|.:;,><?~_!]).{6,16}$";
            break;
            
        default:
            break;
    }
    
    return subRegex;
}

@end
