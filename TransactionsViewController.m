//
//  TransactionsViewController.m
//  mobile-payment
//
//  Created by Torben Toepper on 04.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TransactionsViewController.h"
#import "ASIFormDataRequest.h"
#import "Config.h"
#import "SBJsonParser.h"
#import "TransactionDetailViewController.h"
#import "Transaction.h"

@implementation TransactionsViewController

@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil table:(NSMutableArray *)_table
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        table = _table;
    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil transactionIds:(NSArray *)transactionIds hardwareId:(NSString *)hardwareId {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSURL *url = [Config transactionsUrlWith:hardwareId andIds:transactionIds];
        
        NSLog(@"%@", url);
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request startSynchronous];
        
        NSError *error = [request error];
        if (!error) {
            NSString *response = [request responseString];
            NSError *json_error;
            SBJsonParser *json = [[SBJsonParser new] autorelease];
            NSArray *values = [json objectWithString:response error:&json_error];
            
            table = [[NSMutableArray alloc] init];
            
            for (int i=0,n=[values count]; i<n; i++) {
                for (int i=0,n=[values count]; i<n; i++) {
                    Transaction *transaction = [[Transaction alloc] initWithDictinoary:[values objectAtIndex:i]];
                    
                    [table addObject:transaction];
                }
            }
        }
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
    
    self.title = @"Transaktionen";
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    /*
    UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
    NSURL *urlAddress = [Config transactionsUrlWith:deviceUDID];
    NSLog([NSString stringWithFormat:@"%@", urlAddress]);
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlAddress];
    */
    
    //Load the request in the UIWebView.
    //[webView loadRequest:requestObj];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [table count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Transaction *transaction = [table objectAtIndex:[indexPath section]];
    cell.textLabel.text = transaction.customer.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", transaction.amount, transaction.currency_key];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section {
    Transaction *transaction = [table objectAtIndex:section];
    NSDate *date = transaction.paid_at == NULL ? transaction.created_at : transaction.paid_at;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"dd.MM.yyyy HH:mm:ss"];
    
	return [dateFormat stringFromDate:date];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionDetailViewController *detailViewController = [[TransactionDetailViewController alloc] initWithNibName:@"TransactionDetailViewController" bundle:nil];
    
    NSLog(@"%@", [table objectAtIndex:[indexPath section]]);
    detailViewController.transaction = [table objectAtIndex:[indexPath section]];
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( [[[inRequest URL] scheme] isEqualToString:@"close"] ) {
        [self dismissModalViewControllerAnimated:YES];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)closePressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
*/

-(void)dealloc {
    [table release];
    
    [super dealloc];
}

+(NSMutableArray *)getTransactions {
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *deviceUDID = [myDevice uniqueIdentifier];
    return [TransactionsViewController _getTransactions:[Config transactionsUrlWith:deviceUDID]];
}

+(NSMutableArray *)getTransactions:(Customer *)customer {
    return [TransactionsViewController _getTransactions:[Config transactionsUrl:customer.customer_id]];
}

+(NSMutableArray *)getOpenTransactions:(Customer *)customer {
    return [TransactionsViewController _getTransactions:[Config openTransactionsUrl:customer.customer_id]];
}

+(NSMutableArray *)_getTransactions:(NSURL *)url {
    NSMutableArray *table;

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
                Transaction *transaction = [[Transaction alloc] initWithDictinoary:[values objectAtIndex:i]];
                
                [table addObject:transaction];
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

@end
