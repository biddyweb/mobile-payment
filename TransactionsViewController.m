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
    cell.textLabel.text = [[table objectAtIndex:[indexPath section]] objectForKey:@"customer"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [[table objectAtIndex:[indexPath section]] objectForKey:@"amount"], [[table objectAtIndex:[indexPath section]] objectForKey:@"currency_key"]];
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
    NSString *dateString = [[table objectAtIndex:section] objectForKey:@"paid_at"];
    NSDate *date = [TransactionsViewController dateFromInternetDateTimeString:dateString];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"dd.MM.yyyy HH:mm:ss"];
    
	return [dateFormat stringFromDate:date];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionDetailViewController *detailViewController = [[TransactionDetailViewController alloc] initWithNibName:@"TransactionDetailViewController" bundle:nil];
    
    detailViewController.row = [table objectAtIndex:[indexPath section]];
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
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

+ (NSDate *)dateFromInternetDateTimeString:(NSString *)dateString {
    
    // Setup Date & Formatter
    NSDate *date = nil;
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:en_US_POSIX];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [en_US_POSIX release];
    }
    
    /*
     *  RFC3339
     */
    
    NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
    RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
    
    // Remove colon in timezone as iOS 4+ NSDateFormatter breaks
    // See https://devforums.apple.com/thread/45837
    if (RFC3339String.length > 20) {
        RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":" 
                                                                 withString:@"" 
                                                                    options:0
                                                                      range:NSMakeRange(20, RFC3339String.length-20)];
    }
    
    if (!date) { // 1996-12-19T16:39:57-0800
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"]; 
        date = [formatter dateFromString:RFC3339String];
    }
    if (!date) { // 1937-01-01T12:00:27.87+0020
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"]; 
        date = [formatter dateFromString:RFC3339String];
    }
    if (!date) { // 1937-01-01T12:00:27
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]; 
        date = [formatter dateFromString:RFC3339String];
    }
    if (date) return date;
    
    /*
     *  RFC822
     */
    
    NSString *RFC822String = [[NSString stringWithString:dateString] uppercaseString];
    if (!date) { // Sun, 19 May 02 15:21:36 GMT
        [formatter setDateFormat:@"EEE, d MMM yy HH:mm:ss zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) { // Sun, 19 May 2002 15:21:36 GMT
        [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // Sun, 19 May 2002 15:21 GMT
        [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // 19 May 2002 15:21:36 GMT
        [formatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // 19 May 2002 15:21 GMT
        [formatter setDateFormat:@"d MMM yyyy HH:mm zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // 19 May 2002 15:21:36
        [formatter setDateFormat:@"d MMM yyyy HH:mm:ss"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // 19 May 2002 15:21
        [formatter setDateFormat:@"d MMM yyyy HH:mm"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (date) return date;
    
    // Failed
    return nil;
    
}

@end
