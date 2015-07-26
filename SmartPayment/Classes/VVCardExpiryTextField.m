//
//  VVCardExpiryTextField.m
//  SmartPayment
//
//  Created by Vinod Vishwanath on 22/07/15.
//  Copyright (c) 2015 Vinod Vishwanath. All rights reserved.
//

#import "VVCardExpiryTextField.h"

@implementation VVCardExpiryTextField

-(void)postSetupActions
{
    self.keyboardType = UIKeyboardTypeNumberPad;
}

-(BOOL)allowChangeOfCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString    *textAfterReplacing     = [self.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *digitsOnlyString = [self removeNonDigits:textAfterReplacing];
    
    if(digitsOnlyString.length > [self characterLimit])
        return NO;
    
    BOOL includeSlash = !([self.text containsString:@"/"] && ![textAfterReplacing containsString:@"/"]);
    
    [self findMonthAndYearFromInput:digitsOnlyString];
    
    NSString *spacedOutString = [self expiryDateWithSlash:(BOOL)includeSlash];
    
    self.text = spacedOutString;
    
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
}

-(NSUInteger)characterLimit
{
    NSString *text = self.text;
    NSUInteger limit = 4;
    
    if(text.length > 0)
    {
        unichar firstChar = [text characterAtIndex:0];
        
        if(firstChar == '0' || firstChar == '1')
        {
            limit = 4;
        }
        else
        {
            limit = 3;
        }
    }
    
    return limit;
}

-(NSString *)removeNonDigits:(NSString *)string {

    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
    }
    
    return digitsOnlyString;
}

-(void)findMonthAndYearFromInput:(NSString*)input
{
    if(input.length == 0) {
        
        self.month = nil;
        self.year = nil;
    } else if(input.length == 1) {
        
        self.month = input;
        self.year = nil;
    } else if(input.length == 4) {
        
        self.month = [input substringToIndex:2];
        self.year = [input substringFromIndex:2];
        
    } else {
        
        unichar firstChar = [input characterAtIndex:0];
        if(firstChar == '1' || firstChar == '0')
        {
            self.month = [input substringToIndex:2];
            self.year = [input substringFromIndex:2];
        }
        else
        {
            self.month = [input substringToIndex:1];
            self.year = [input substringFromIndex:1];
        }
    }
}

-(NSString*)expiryDateWithSlash:(BOOL)slash
{
    if([self isValidMonth])
    {
        return [NSString stringWithFormat:@"%@%@%@", self.month, slash?@"/":@"", self.year?:@""];
    }
    else
    {
        return self.month;
    }
    
    return nil;
}

-(BOOL)isValidMonth
{
    NSInteger m = [self.month integerValue];
    if((m > 1 && m <=12) || (m==1 && self.month.length == 2))
        return YES;
    
    return NO;
}

@end
