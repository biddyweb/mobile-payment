//
//  GenerateQRViewController.m
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "GenerateQRViewController.h"
#import "QRCodeViewController.h"
#import "Properties.h"
#import "PropertiesViewController.h"

@implementation GenerateQRViewController

@synthesize amount;


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
    
    Properties *props = [[Properties alloc] init];
    if([props get:@"storename"] == nil || [props get:@"paypalUsername"] == nil || [props get:@"paypalPassword"] == nil || [props get:@"paypalSignature"] == nil) {
        PropertiesViewController *widController = [[PropertiesViewController alloc] initWithNibName:@"PropertiesViewController" bundle:nil];
        [self presentModalViewController:widController animated:YES];
    }
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

- (IBAction)generatePressed:(id)sender {
    Properties *props = [[Properties alloc] init];

    QRCodeViewController *widController = [[QRCodeViewController alloc] initWithNibNameAndAmount:@"QRCodeViewController" bundle:nil amount:amount.text currency:[props get:@"currency"]];
    [self presentModalViewController:widController animated:YES];
    [widController generateQR];
    //[widController loadQR];
    [props release];
}

- (void)dealloc {
    [amount release];
    [super dealloc];
}


@end
