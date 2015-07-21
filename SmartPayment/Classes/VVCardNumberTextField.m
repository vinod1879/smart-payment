//
//  VVCardNumberTextField.m
//  SmartPayment
//
//  Created by Vinod Vishwanath on 18/07/15.
//  Copyright (c) 2015 Vinod Vishwanath. All rights reserved.
//

#import "VVCardNumberTextField.h"

@interface VVCardNumberTextField ()<UITextFieldDelegate>

@property (nonatomic, weak) id<UITextFieldDelegate> replacementDelegate;

@end

@implementation VVCardNumberTextField


#pragma mark - Initializations and Setup

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
    self.keyboardType   =   UIKeyboardTypeNumberPad;
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

-(NSString*)cardNumber
{
    NSString *number = [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                        
    return number;
}

#pragma mark - UITextField delegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString    *textAfterReplacing     = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger   cursorPosition          = range.location + string.length;
    
    NSString *digitsOnlyString = [self removeNonDigits:textAfterReplacing andPreserveCursorPosition:&cursorPosition];
    
    if(digitsOnlyString.length > [self characterLimit])
        return NO;
    
    NSString *spacedOutString = [self insertSpacesEveryFourDigitsIntoString:digitsOnlyString andPreserveCursorPosition:&cursorPosition];
    
    self.text = spacedOutString;
    UITextPosition *targetPosition = [self positionFromPosition:[self beginningOfDocument]
                                                         offset:cursorPosition];
    
    [self setSelectedTextRange:[self textRangeFromPosition:targetPosition toPosition:targetPosition]];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
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

#pragma mark - Validation methods


-(VVCardIssuer)cardIssuer
{
    NSPredicate *predicate;
    
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[4][0-9 ]*"];
    if([predicate evaluateWithObject:self.cardNumber])
        return VVCardIssuerVisa;
    
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^5[1-5][0-9 ]*"];
    if([predicate evaluateWithObject:self.cardNumber])
        return VVCardIssuerMasterCard;
    
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^3[47][0-9 ]*"];
    if([predicate evaluateWithObject:self.cardNumber])
        return VVCardIssuerAmex;
    
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^3(?:0[0-5]|[68][0-9])[0-9 ]*"];
    if([predicate evaluateWithObject:self.cardNumber])
        return VVCardIssuerDinersClub;
    
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^6(?:011|5[0-9]{2})[0-9 ]*"];
    if([predicate evaluateWithObject:self.cardNumber])
        return VVCardIssuerDiscover;
    
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?:2131|1800|35\\d{3})[0-9 ]*"];
    if([predicate evaluateWithObject:self.cardNumber])
        return VVCardIssuerJCB;
    
    return VVCardIssuerUnknown;
}

-(NSUInteger)characterLimit
{
    switch (self.cardIssuer) {
        case VVCardIssuerAmex:
            return 15;

        case VVCardIssuerDinersClub:
            return 16;
            
        case VVCardIssuerDiscover:
            return 16;
            
        case VVCardIssuerJCB:
            return 16;
            
        case VVCardIssuerMasterCard:
            return 16;
            
        case VVCardIssuerVisa:
            return 16;

        default:
            break;
    }

    return 20;
}

-(BOOL)isValid
{
    NSString *regex = @"^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|6(?:011|5[0-9]{2})[0-9]{12}|(?:2131|1800|35\\d{3})\\d{11})$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:[self cardNumber]];
}

#pragma mark - Utility Methods

- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSInteger *)cursorPosition {
    NSUInteger targetCursorPositionInOriginalReplacementString = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < targetCursorPositionInOriginalReplacementString) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

/*
 Inserts spaces into the string to format it as a credit card number,
 incrementing `cursorPosition` as appropriate  */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSInteger *)cursorPosition {

    BOOL isAMEX = ([self cardIssuer] == VVCardIssuerAmex);
    
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        
        if ((isAMEX && (i==4 || i==10 || i==0)) || (!isAMEX && i%4==0))
        {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}

@end
