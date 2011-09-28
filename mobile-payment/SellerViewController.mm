//
//  SellerViewController.m
//  mobil-payment
//
//  Created by Torben Toepper on 24.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "SellerViewController.h"
#import "QRCodeReader.h"
#import "PropertiesViewController.h"
#import "ASIFormDataRequest.h"
#import "Config.h"

@implementation SellerViewController

@synthesize generateQrController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"MERCHANT.TITLE", @"Merchant")];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


- (void)dealloc {
    [generateQrController release];
    [super dealloc];
}


@end



