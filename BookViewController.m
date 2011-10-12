//
//  BookViewController.m
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "BookViewController.h"
#import "Config.h"
#import "PayPal.h"
#import "WebViewController.h"
#import "SetExpressCheckoutRequestDetails.h"
#import "ASIHTTPRequest.h"


#define CANCEL_URL @"http://CancelURL"

@implementation BookViewController

@synthesize orderAmount, taxAmount, returnUrlValue, partner, price, priceValue, currencyValue;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    priceValue = @"0.00";
    /*
    NSString *jsonString = @"{\"Herausgeber\": \"Xema\",    \"Nummer\": \"1234-5678-9012-3456\",    \"Deckung\": 2e+6,    \"Währung\": \"EUR\",    \"Inhaber\": {    \"Name\": \"Mustermann\",    \"Vorname\": \"Max\",\"männlich\": true,\"Depot\": {},\"Hobbys\": [ \"Reiten\", \"Golfen\", \"Lesen\" ],\"Alter\": 42,\"Kinder\": [],\"Partner\": null}}";
    
    SBJsonParser *parser = [SBJsonParser new];
    id object = [parser objectWithString:jsonString];
    if (!object) {
        NSLog(@"Error trace: %@", parser.error);
    }
    
    NSDictionary *dictionary = [jsonString JSONValue];
	NSLog(@"Dictionary value for \"Nummer\" is \"%@\"", [dictionary objectForKey:@"Nummer"]);
     */

    self.title = @"Review your order";
	
	//compute total and build description
}

-(void)addPayPalButton {
    taxAmount = orderAmount * .06;
	UIButton *button = [[PayPal getInstance] getPayButtonWithTarget:self andAction:@selector(payWithPayPal) andButtonType:BUTTON_278x43];
    
    CGRect theRect = button.frame;
	
	if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]) {
		if ([[UIDevice currentDevice] userInterfaceIdiom] == 1) {
			theRect = CGRectMake(self.view.frame.size.width / 2 - button.frame.size.width / 2 , 442, button.frame.size.width, button.frame.size.height);
		}
		else {
			theRect = CGRectMake(20, 302, button.frame.size.width, button.frame.size.height);
		}
	}
	else {
		theRect = CGRectMake(20, 302, button.frame.size.width, button.frame.size.height);
	}
	
	for (UIView *v in button.subviews) {
		if ([v isKindOfClass:[UIButton class]]) {
			theRect.origin.y -= (button.frame.size.height - v.frame.size.height);
			break;
		}
	}
	
	button.frame = theRect;
	[self.view addSubview:button];
}

-(void)payWithPayPal {
    //NSLog([NSString stringWithFormat:@"%@", [priceValue floatValue]]);
    float _priceValue = [priceValue floatValue];
    //float _priceValue = 5.99;
    
    NSMutableString *buf = [NSMutableString string];
	[buf appendFormat:@"%u ", 1];
    orderAmount = _priceValue;
    [buf appendString:@"Medium"];
	[buf appendString:@" Pizza"];
    
	//In this example, we do the Express Checkout calls completely on the device.  This is not recommended because
	//it requires the merchant API credentials to be stored in the app on the device, and this is a security risk.
	[ECNetworkHandler sharedInstance].username = @"seller_1314869754_biz_api1.htmlcast.de";
	[ECNetworkHandler sharedInstance].password = @"1314869789";
	[ECNetworkHandler sharedInstance].signature = @"AZeCF3YbjeCgxEJYCY7OM9Aw--0mA849DazQ8OHpnC409LaSyHyZ5LHs";
	[ECNetworkHandler sharedInstance].userAction = ECUSERACTION_COMMIT; //user completes payment on paypal site
    [ECNetworkHandler sharedInstance].currencyCode = currencyValue;
	
	SetExpressCheckoutRequestDetails *sreq = [[[SetExpressCheckoutRequestDetails alloc] init] autorelease];
	PaymentDetails *paymentDetails = [[[PaymentDetails alloc] init] autorelease];
	[sreq addPaymentDetails:paymentDetails];
    

    sreq.NoShipping = DO_NOT_DISPLAY_SHIPPING;
	sreq.ReturnURL = returnUrlValue;
	sreq.CancelURL = CANCEL_URL;

    taxAmount = 0;
	paymentDetails.OrderTotal = orderAmount;
	paymentDetails.ItemTotal = _priceValue;
	paymentDetails.TaxTotal = taxAmount;
	paymentDetails.ShippingTotal = 0;
	paymentDetails.OrderDescription = @"Your Order";
	paymentDetails.NoteText = @"2nd Text";
	
	NSMutableString *itemName = [NSMutableString string];
	[itemName appendString:@" Pizza"];
	
	NSMutableString *description = nil;
    description = [NSMutableString stringWithString:itemName];
	

    PaymentDetailsItem *paymentDetailsItem = [[[PaymentDetailsItem alloc] init] autorelease];
    paymentDetailsItem.Name = itemName;
    paymentDetailsItem.Amount = _priceValue;
    paymentDetailsItem.Description = description;
    [paymentDetails addPaymentDetailsItem:paymentDetailsItem];
	
	//Call setExpressCheckout.  The response will be handled below in the expressCheckoutResponseReceived: method.
	[[ECNetworkHandler sharedInstance] setExpressCheckoutWithRequest:sreq withDelegate:self];
}


-(void)loadTransaction:(NSString *)customerId transactionId:(NSString *)transactionId {
    NSURL *url = [Config transactionUrl:customerId transaction:transactionId asJSON:true];
    
    NSLog(@"%@", url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *json_error;
        SBJsonParser *json = [[SBJsonParser new] autorelease];
        NSDictionary *values = [json objectWithString:response error:&json_error];
        
        if(values == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" 
                                                            message:[NSString stringWithFormat:@"JSON parsing failed: %@", [json_error localizedDescription]]
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            if([values objectForKey:@"id"] != nil) {
                //priceValue    = [[NSString alloc] initWithString:[values objectForKey:@"amount"]];
                priceValue    = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@", [values objectForKey:@"amount"]]];
                currencyValue = [[NSString alloc] initWithString:[values objectForKey:@"currency"]];
                partner.text  = [[values objectForKey:@"customer"] objectForKey:@"name"];
                price.text    = [NSString stringWithFormat:@"%@ %@", priceValue, [values objectForKey:@"currency_key"]];
            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" 
                                                        message:[NSString stringWithFormat:@"Web parsing failed: %@", [error localizedDescription]]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)payPressed:(id)sender {
    
    /*
    TestViewController *widController = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    [self presentModalViewController:widController animated:YES];
    */
}

#pragma mark -
#pragma mark ExpressCheckoutResponseHandler methods

//In this example, we do the Express Checkout calls completely on the device.  This is not recommended because
//it requires the merchant API credentials to be stored in the app on the device, and this is a security risk.
- (void)expressCheckoutResponseReceived:(NSObject *)response {
	if ([response isKindOfClass:[NSError class]]) {
		//If we get back an error, display an alert.
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment failed" 
														message:[(NSError *)response localizedDescription]
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else if ([response isKindOfClass:[NSString class]]) { //got back token
		//The response from setExpressCheckout is an Express Checkout token.  The ECNetworkHandler class stores
		//this token for us, so we do not have to pass it back in.  Redirect to PayPal's login page.
        //NSLog(@"%@", response);
		[self.navigationController pushViewController:[[[WebViewController alloc] initWithURL:[ECNetworkHandler sharedInstance].redirectURL
																					returnURL:returnUrlValue
																					cancelURL:CANCEL_URL] autorelease]
											 animated:TRUE];
	}
}

- (void)dealloc {
    [priceValue release];
    [super dealloc];
}

@end
