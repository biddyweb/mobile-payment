//
//  QRCodeViewController.m
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "QRCodeViewController.h"
#import "Config.h"
#import "Properties.h"
#import "SBJsonParser.h"

@implementation QRCodeViewController

@synthesize amount, currency, webView, qrImageView;

- (id)initWithNibNameAndAmount:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil amount:(NSString *)_amount currency:(NSString *)_currency {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    amount = _amount;
    currency = _currency;
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

    UIImage *loader1  = [UIImage imageNamed:@"loader1.png"];
    UIImage *loader2  = [UIImage imageNamed:@"loader2.png"];
    UIImage *loader3  = [UIImage imageNamed:@"loader3.png"];
    UIImage *loader4  = [UIImage imageNamed:@"loader4.png"];
    UIImage *loader5  = [UIImage imageNamed:@"loader5.png"];
    UIImage *loader6  = [UIImage imageNamed:@"loader6.png"];
    UIImage *loader7  = [UIImage imageNamed:@"loader7.png"];
    UIImage *loader8  = [UIImage imageNamed:@"loader8.png"];
    UIImage *loader9  = [UIImage imageNamed:@"loader9.png"];
    UIImage *loader10 = [UIImage imageNamed:@"loader10.png"];
    UIImage *loader11 = [UIImage imageNamed:@"loader11.png"];
    UIImage *loader12 = [UIImage imageNamed:@"loader12.png"];
    
    qrImageView.animationImages = [[NSArray alloc] initWithObjects:loader1, loader2, loader3, loader4, loader5, loader6, loader7, loader8, loader9, loader10, loader11, loader12, nil];
    qrImageView.animationRepeatCount = 50;
    [qrImageView startAnimating];
}

-(void)loadQR:(NSString *)transaction_id {
    Properties *props = [[[Properties alloc] init] autorelease];
    NSString *customerId = [props get:@"customer_id"];

    NSURL *urlAddress = [Config transactionUrl:customerId transaction:transaction_id asJSON:false];
    NSLog(@"Hier bitte sehr: %@", urlAddress);
    NSData *data = [NSData dataWithContentsOfURL:urlAddress];
    UIImage *img = [[[UIImage alloc] initWithData:data] autorelease];
    
    [qrImageView stopAnimating];
    qrImageView.contentMode = UIViewContentModeScaleAspectFit;
    [qrImageView setImage:img];
}

- (void)generateQR {
    Properties *props = [[[Properties alloc] init] autorelease];
    NSString *customerId = [props get:@"customer_id"];
    NSURL *url = [Config transactionsUrl:customerId];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:amount forKey:@"transaction[amount]"];
    [request setPostValue:currency forKey:@"transaction[currency]"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    XLog(@"ERFOLG!");
    Properties *props = [[[Properties alloc] init] autorelease];
    NSString *customerId = [props get:@"customer_id"];
    NSURL *urlAddress = [NSURL URLWithString:@"about:blank"];
    
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
            urlAddress = [Config transactionUrl:customerId transaction:[values objectForKey:@"id"] asJSON:false];
            NSData *data = [NSData dataWithContentsOfURL:urlAddress];
            UIImage *img = [[[UIImage alloc] initWithData:data] autorelease];
            
            [qrImageView stopAnimating];
            qrImageView.contentMode = UIViewContentModeScaleAspectFit;
            [qrImageView setImage:img];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    XLog(@"FEHLER!!");
    NSError *error = [request error];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" 
                                                    message:[NSString stringWithFormat:@"Web parsing failed: %@", [error localizedDescription]]
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
