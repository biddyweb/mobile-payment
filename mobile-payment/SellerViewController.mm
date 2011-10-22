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
#import "SBJsonParser.h"
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

-(NSMutableArray *)getTransactions {
    NSMutableArray *table;
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *deviceUDID = [myDevice uniqueIdentifier];
    NSURL *url = [Config transactionsUrlWith:deviceUDID];
    
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *json_error;
        SBJsonParser *json = [[SBJsonParser new] autorelease];
        NSArray *values = [json objectWithString:response error:&json_error];
        
        if(values == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" 
                                                            message:[NSString stringWithFormat:@"JSON parsing failed: %@", [json_error localizedDescription]]
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            table = [[NSMutableArray alloc] init];
            
            for (int i=0,n=[values count]; i<n; i++) {
                [table addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  [[values objectAtIndex:i] objectForKey:@"amount"], @"amount", 
                  [[values objectAtIndex:i] objectForKey:@"paid_at"], @"paid_at",
                  [[values objectAtIndex:i] objectForKey:@"transaction_id"], @"transaction_id",
                  [[[values objectAtIndex:i] objectForKey:@"customer"] objectForKey:@"name"], @"customer",
                  [[values objectAtIndex:i] objectForKey:@"currency_key"], @"currency_key",
                  [[[values objectAtIndex:i] objectForKey:@"customer"] objectForKey:@"website_url"], @"website_url",
                  [[[values objectAtIndex:i] objectForKey:@"customer"] objectForKey:@"street"], @"street",
                  [[[values objectAtIndex:i] objectForKey:@"customer"] objectForKey:@"zip"], @"zip",
                  [[[values objectAtIndex:i] objectForKey:@"customer"] objectForKey:@"location"], @"location",
                  nil]
                 ];
            }
            
            return table;
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" 
                                                        message:[NSString stringWithFormat:@"Web parsing failed: %@", [error localizedDescription]]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    return nil;
}

- (IBAction)transactionsPressed:(id)sender {
    NSMutableArray *table = [SellerTransactionsViewController getTransactions];
    SellerTransactionsViewController *sellerTransactionsController = [[SellerTransactionsViewController alloc] initWithNibName:@"SellerTransactionsViewController" bundle:nil table:table];
    [self.navigationController pushViewController:sellerTransactionsController animated:YES];
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



