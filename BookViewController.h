//
//  BookViewController.h
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "PayPal.h"
#import "ECNetworkHandler.h"
#import "PaymentDetails.h"

@interface BookViewController : UIViewController <ExpressCheckoutResponseHandler> {
    IBOutlet UILabel *partner;
    IBOutlet UILabel *price;
    
    float orderAmount;
	float taxAmount;
	
	//passed in from OrderViewController
	NSArray *toppingsArray;
	
    NSString *returnUrlValue;
    NSString *priceValue;
    NSString *currencyValue;
}

@property (nonatomic, retain) NSString *returnUrlValue;
@property (nonatomic, retain) NSString *priceValue;
@property (nonatomic, retain) NSString *currencyValue;

@property (nonatomic, retain) IBOutlet UILabel *partner;
@property (nonatomic, retain) IBOutlet UILabel *price;

@property (nonatomic, assign) float orderAmount;
@property (nonatomic, assign) float taxAmount;

//- (IBAction)Cancel;
//- (IBAction)textFieldDoneEditing:(id)sender;
- (void)payWithPayPal;
- (void)loadTransaction:(NSString *)customerId transactionId:(NSString *)transactionId;
- (void)addPayPalButton;
- (IBAction)payPressed:(id)sender;

@end