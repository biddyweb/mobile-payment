//
//  CustomerViewController.m
//  mobil-payment
//
//  Created by Torben Toepper on 24.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "CustomerViewController.h"
#import "QRCodeReader.h"
#import "PayPal.h"
#import "PropertiesViewController.h"
#import "ASIFormDataRequest.h"
#import "Config.h"


@implementation CustomerViewController

@synthesize resultsToDisplay, bookController, tokenFetchAttempted, scanButton;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"TITLE", @"Kunde")];
    [scanButton setBackgroundColor:[UIColor clearColor]];
    CALayer *downButtonLayer = [scanButton layer];
    [downButtonLayer setBorderWidth:0.0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSLog(@"Current Locale: %@", [[NSLocale currentLocale] localeIdentifier]);
    NSLog(@"Current language: %@", currentLanguage);
    NSLog(@"Welcome Text: %@", NSLocalizedString(@"WelcomeKey", @""));
    
    if (!tokenFetchAttempted) {
		tokenFetchAttempted = TRUE;
		//Fetch the device reference token immediately before displaying the page containing the Pay with PayPal button.
		//You might display a UIActivityIndicatorView here to let the user know something is going on.
        //PayPal *paypal = [PayPal getInstance];
        //paypal.lang = @"DE";
		//[paypal fetchDeviceReferenceTokenWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX withDelegate:nil];
        //[[PayPal getInstance] fetchDeviceReferenceTokenWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX withDelegate:self];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)showBooking:(NSString *)qrCode {
    NSArray *urlComponents = [qrCode componentsSeparatedByString:@"/"];
    
    if([urlComponents count] >= 8) {
        NSString *customerId = [urlComponents objectAtIndex:[Config qrCodeCustomerPosition]];
        NSString *transactionId = [urlComponents objectAtIndex:[Config qrCodeTransactionPosition]];
        
        UIActivityIndicatorView  *av = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        av.frame=CGRectMake(145, 160, 25, 25);
        av.tag  = 1;
        
        self.bookController.returnUrlValue = [NSString stringWithFormat:@"%@", [Config transactionConfirmationUrl:customerId transaction:transactionId asJSON:true]];
        
        [self.navigationController pushViewController:self.bookController animated:YES];
        
        [self.bookController.view addSubview:av];
        [av startAnimating];
        
        [self.bookController loadTransaction:customerId transactionId:transactionId];
        [self.bookController addPayPalButton];
        
        [av removeFromSuperview];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QR-Code" 
                                                        message:[NSString stringWithFormat:@"QR-Code konnte nicht verarbeitet werden: %@", qrCode]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)scanPressed:(id)sender {
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    [qrcodeReader release];
    widController.readers = readers;
    [readers release];
    NSBundle *mainBundle = [NSBundle mainBundle];
    widController.soundToPlay =
    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];
    [self presentModalViewController:widController animated:YES];
    [widController release];
}

- (IBAction)bookPressed:(id)sender {
    NSString *qrCode = @"http://localhost:3000/customers/1/transactions/27/pay";
    [self showBooking:qrCode];
}

- (IBAction)transactionsPressed:(id)sender {
    TransactionsViewController *transactionsController = [[TransactionsViewController alloc] initWithNibName:@"TransactionsViewController" bundle:nil];
    [self.navigationController pushViewController:transactionsController animated:YES];
}

#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    self.resultsToDisplay = result;
    [self showBooking:resultsToDisplay];
    [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)receivedDeviceReferenceToken:(NSString *)token {
    //
}
- (void)couldNotFetchDeviceReferenceToken {
    //
}

- (void)dealloc {
    [bookController release];
    [super dealloc];
}


@end



