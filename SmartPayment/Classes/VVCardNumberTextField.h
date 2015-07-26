//
//  VVCardNumberTextField.h
//  SmartPayment
//
//  Created by Vinod Vishwanath on 18/07/15.
//  Copyright (c) 2015 Vinod Vishwanath. All rights reserved.
//

#import "VVValidatedTextField.h"

typedef NS_ENUM(NSUInteger, VVCardIssuer) {
    
    VVCardIssuerUnknown,
    VVCardIssuerVisa,
    VVCardIssuerMasterCard,
    VVCardIssuerAmex,
    VVCardIssuerDinersClub,
    VVCardIssuerDiscover,
    VVCardIssuerJCB
};

@interface VVCardNumberTextField : VVValidatedTextField

@property(nonatomic) VVCardIssuer   cardIssuer;
@property(nonatomic) BOOL           isValid;

/**
 Returns the card number by removing all spaces in the textfield
 */
-(NSString*)cardNumber;

@end
