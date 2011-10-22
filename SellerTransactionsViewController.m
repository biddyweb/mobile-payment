//
//  SellerTransactionsViewController.m
//  mobile-payment
//
//  Created by Torben Toepper on 22.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SellerTransactionsViewController.h"
#import "Properties.h"

@implementation SellerTransactionsViewController

@synthesize segmentedControl, customer;

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
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    Properties *props = [[Properties alloc] init];
    NSLog(@"Number: %@", [props get:@"customer_id"]);
    customer = [Customer find:[f numberFromString:[props get:@"customer_id"]]];
                
    [f release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma IBActions

-(IBAction)segmentChanged:(id)sender {
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            table = [TransactionsViewController getTransactions:customer];
            break;
        case 1:
            table = [TransactionsViewController getOpenTransactions:customer];
            break;
        case UISegmentedControlNoSegment:
            // do something
            break;
        default:
            NSLog(@"No option for: %d", [segmentedControl selectedSegmentIndex]);
    }
    
    for (int i=0,n=[self.view.subviews count]; i<n; i++) {
        id view = [self.view.subviews objectAtIndex:i];
        if ([view isKindOfClass:[UITableView class]]) {
            [view reloadData];
        }
    }
}

@end
