//
//  TransactionDetailViewController.m
//  mobile-payment
//
//  Created by Torben Toepper on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TransactionDetailViewController.h"
#import "TransactionsViewController.h"
#import "CostomerWebsiteViewController.h"
#import "MapsViewController.h"

@implementation TransactionDetailViewController

@synthesize transaction;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //
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
    
    self.title = @"Details";

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    if([indexPath row] == 0) {
        cell.textLabel.text = @"Verkäufer:";
        cell.detailTextLabel.text = [self textForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if([indexPath row] == 1) {
        cell.textLabel.text = @"Betrag:";
        cell.detailTextLabel.text = [self textForRowAtIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else if([indexPath row] == 2) {
        cell.textLabel.text = @"Transaktionsnr.:";
        cell.detailTextLabel.text = [self textForRowAtIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else if([indexPath row] == 3) {
        cell.textLabel.text = @"Adresse:";
        cell.detailTextLabel.text = [self textForRowAtIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [[self textForRowAtIndexPath:indexPath] sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 20;
}

-(NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0:
                    return transaction.customer.name;
                    
                case 1:
                    return [NSString stringWithFormat:@"%@ %@", transaction.amount, transaction.currency_key];
                
                case 2:
                    return transaction.transaction_id;
                
                case 3:
                    return [NSString stringWithFormat:@"%@\n%@ %@", transaction.customer.street, transaction.customer.zip, transaction.customer.location];
            }
    }
    
    return @"";
}

- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section {
    NSDate *date = transaction.paid_at;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"dd.MM.yyyy HH:mm:ss"];
    
	return [dateFormat stringFromDate:date];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        CostomerWebsiteViewController *customerViewController = [[CostomerWebsiteViewController alloc] initWithNibName:@"CostomerWebsiteViewController" bundle:nil url:transaction.customer.website_url];
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:customerViewController animated:YES];
        [customerViewController release];
    } else if([indexPath row] == 3) {
        MapsViewController *mapsViewController = [[MapsViewController alloc] initWithNibName:@"MapsViewController" bundle:nil ];
        
        mapsViewController.customer = transaction.customer;
        [self.navigationController pushViewController:mapsViewController animated:YES];
        [mapsViewController release];
    }
}

@end
