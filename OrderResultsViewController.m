//
//  OrderResultsViewController.m
//  mobil-payment
//
//  Created by Torben Toepper on 01.09.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "OrderResultsViewController.h"


@implementation OrderResultsViewController
@synthesize transactionID;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.navigationItem.hidesBackButton = TRUE;
	self.title = @"Order completed";
	txnID.text = [NSString stringWithFormat:@"Transaction ID: %@", transactionID];

    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)homeButtonPressed {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
