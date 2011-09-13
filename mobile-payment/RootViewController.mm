//
//  RootViewController.m
//  mobil-payment
//
//  Created by Torben Toepper on 24.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "RootViewController.h"
#import "QRCodeReader.h"
#import "PayPal.h"
#import "PropertiesViewController.h"
#import "ASIFormDataRequest.h"
#import "Config.h"

@interface RootViewController()

@end


@implementation RootViewController

@synthesize resultsView, resultsToDisplay, bookController, generateQrController, tokenFetchAttempted, bookButton;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Mobile Payment"];
    [resultsView setText:resultsToDisplay];
    [bookButton setBackgroundColor:[UIColor clearColor]];
    CALayer * downButtonLayer = [bookButton layer];
    [downButtonLayer setBorderWidth:0.0];
    
    if (!tokenFetchAttempted) {
		tokenFetchAttempted = TRUE;
		//Fetch the device reference token immediately before displaying the page containing the Pay with PayPal button.
		//You might display a UIActivityIndicatorView here to let the user know something is going on.
        PayPal *paypal = [PayPal getInstance];
        //paypal.lang = @"DE";
		[paypal fetchDeviceReferenceTokenWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX withDelegate:nil];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    NSArray *urlComponents = [qrCode componentsSeparatedByString:@"/"];
    
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
}

- (IBAction)transactionsPressed:(id)sender {
    TransactionsViewController *transactionsController = [[TransactionsViewController alloc] initWithNibName:@"TransactionsViewController" bundle:nil];
    [self.navigationController pushViewController:transactionsController animated:YES];
}

- (IBAction)generatePressed:(id)sender {
    [self.navigationController pushViewController:self.generateQrController animated:YES];
}

- (IBAction)myDataPressed:(id)sender {
    PropertiesViewController *widController = [[PropertiesViewController alloc] initWithNibName:@"PropertiesViewController" bundle:nil];
    [self presentModalViewController:widController animated:YES];
}

#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    self.resultsToDisplay = result;
    if (self.isViewLoaded) {
        [resultsView setText:resultsToDisplay];
        [resultsView setNeedsDisplay];
    }
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

- (void)viewDidUnload {
    self.resultsView = nil;
}

- (void)dealloc {
    [generateQrController release];
    [bookController release];
    [resultsView release];
    [super dealloc];
}


@end



