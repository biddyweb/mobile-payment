//
//  PropertiesViewController.m
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "PropertiesViewController.h"
#import "CatalogViewController.h"

@implementation PropertiesViewController

@synthesize props, table, inputFields, keyboardToolbar, toolbarActionButton, localTableView, cancel, done, navigation, inputFieldsAsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self prepare];
    }
    return self;
}

-(void)prepare {
    inputFields = [[NSMutableDictionary alloc] init];
    inputFieldsAsArray = [[NSMutableArray alloc] init];
    props = [[Properties alloc] init];
    
    table = [[NSMutableArray alloc] init];
    [table addObject:
                    [NSArray arrayWithObjects:
                     [NSDictionary dictionaryWithObjectsAndKeys:[props get:@"storename"], @"value", @"Name", @"key", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[props get:@"currency"], @"value", @"currency", @"key", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[props get:@"website_url"], @"value", @"website_url", @"key", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[props get:@"street"], @"value", @"street", @"key", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[props get:@"zip"], @"value", @"zip", @"key", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[props get:@"location"], @"value", @"location", @"key", nil],
                     nil
                     ]
     ]; //Section 1
    
    [table addObject: [NSArray arrayWithObjects: 
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Username", @"key", [props get:@"paypalUsername"], @"value", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Password", @"key", [props get:@"paypalPassword"], @"value", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Signature", @"key", [props get:@"paypalSignature"], @"value", nil],
                       nil
                       ]
     ]; // Section 2
             
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
    
    [localTableView setDelegate:self];
    [localTableView setDataSource:self];
    
    for (int i=0,n=[table count]; i<n; i++) {
        for (int ii=0,nn=[[table objectAtIndex:i] count]; ii<nn; ii++) {
            NSString *text = [[[table objectAtIndex:i] objectAtIndex:ii] objectForKey:@"value"];
            UITextField *input = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ii inSection:i];
            
            [input setText:text];
            
            [inputFields setObject:input forKey:indexPath];
            //if(![[[[table objectAtIndex:i] objectAtIndex:ii] objectForKey:@"key"] isEqualToString:@"currency"]) {
                [inputFieldsAsArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:indexPath, @"indexPath", input, @"input", nil]];
            //}
        }
    }
    
    navigation.topItem.title = @"Eigenschaften";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [table count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[table objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tablePadding = 40;
	int tableWidth = [tableView frame].size.width;
	if (tableWidth > 480) { // iPad
		tablePadding = 110;
	}

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *arr = [table objectAtIndex:[indexPath section]];;
    NSDictionary *dict = [arr objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [dict objectForKey:@"key"];
    //cell.detailTextLabel.text = @"a";
    
    if ([[dict objectForKey:@"key"] isEqualToString:@"currency"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITextField *input = [inputFields objectForKey:indexPath];
    
    if ([cell contentView] != nil) {
        for(int i=0,n=[[[cell contentView] subviews] count];i<n;i++) {
            id d = [[[cell contentView] subviews] objectAtIndex:i];
            if([d isKindOfClass:[UITextField class]]) {
                [d removeFromSuperview];
            }
        }
    }
    

    [input setDelegate:self];
    [input setBorderStyle:UITextBorderStyleNone];
    
    input.secureTextEntry = [self isFieldProtected:[dict objectForKey:@"key"]];
    
    if ([[dict objectForKey:@"key"] isEqualToString:@"currency"]) {
        input.enabled = false;
    }
    if ([[dict objectForKey:@"key"] isEqualToString:@"website_url"]) {
        input.keyboardType = UIKeyboardTypeURL;
        input.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
    [input setFrame:CGRectMake(60+tablePadding,12,tableWidth-tablePadding-100,25)];
    input.placeholder = [dict objectForKey:@"key"];

    
    [[cell contentView] addSubview:input];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    return cell;
}

-(BOOL)isFieldProtected:(NSString *)key {
    return ([key isEqualToString:@"Password"] || [key isEqualToString:@"Signature"]);
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

- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return @"Allgemeine Info";
		case 1:
			return @"Paypal";
	}
	return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0 || [indexPath section] == 1) {
        NSArray *arr = [table objectAtIndex:[indexPath section]];
        NSDictionary *dict = [arr objectAtIndex:[indexPath row]];
        NSArray *views = [[[tableView cellForRowAtIndexPath:indexPath] contentView] subviews];
        
        if([[dict objectForKey:@"key"] isEqualToString:@"currency"]) {
            for (int i=0,n=[views count]; i<n; i++) {
                if([[views objectAtIndex:i] isKindOfClass:[UITextField class]]) {
                    NSArray *currencies = [[NSArray alloc] initWithObjects:@"EUR", @"CHF", nil];
                    UITextField *field = [views objectAtIndex:i];
                    
                    CatalogViewController *catalogViewController = [[CatalogViewController alloc] initWithNibName:@"CatalogViewController" bundle:nil catalog:currencies inputField:field title:@"Währung"];
                    
                    [self presentModalViewController:catalogViewController animated:YES];
                    [catalogViewController release];
                    [currencies release];
                }
            }
        }
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint point = [textField.superview convertPoint:textField.frame.origin toView:localTableView];
    CGPoint contentOffset = localTableView.contentOffset;
    NSLog(@"%f", localTableView.contentOffset);
    NSLog(@"%f", navigation.frame.size.height);
    contentOffset.y += (point.y - navigation.frame.size.height); // Adjust this value as you need
    [localTableView setContentOffset:contentOffset animated:YES];
    
    [textField setInputAccessoryView:keyboardToolbar];
    for (int i=0; i<[inputFieldsAsArray count]; i++) {
        if ([[inputFieldsAsArray objectAtIndex:i] objectForKey:@"input"] == textField) {
            if (i==[inputFieldsAsArray count]-1) {
                toolbarActionButton.title = @"Done";
                [toolbarActionButton setStyle:UIBarButtonItemStyleDone];    
            }
            
            /*
            NSIndexPath *indexPath = [[inputFieldsAsArray objectAtIndex:i] objectForKey:@"indexPath"];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            */
        }
    }
    
    //[self animateTextField: textField up: YES];
}

/*
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up {
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    //[self.view scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
    //self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
 */

-(BOOL)check {
    for(int i=0,n=[inputFieldsAsArray count];i<n;i++) {
        UITextField *textfield = [[inputFieldsAsArray objectAtIndex:i] objectForKey:@"input"];
        if ([textfield.text length] <= 0) {
            return false;
        }
    }

    return true;
}

-(IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)submit:(id)sender {
    if([self check]) {
        UITextField *storename = [[inputFieldsAsArray objectAtIndex:0] objectForKey:@"input"];
        UITextField *currency = [[inputFieldsAsArray objectAtIndex:1] objectForKey:@"input"];
        UITextField *website_url = [[inputFieldsAsArray objectAtIndex:2] objectForKey:@"input"];
        UITextField *street = [[inputFieldsAsArray objectAtIndex:3] objectForKey:@"input"];
        UITextField *zip = [[inputFieldsAsArray objectAtIndex:4] objectForKey:@"input"];
        UITextField *location = [[inputFieldsAsArray objectAtIndex:5] objectForKey:@"input"];
        UITextField *paypalUsername = [[inputFieldsAsArray objectAtIndex:6] objectForKey:@"input"];
        UITextField *paypalPassword = [[inputFieldsAsArray objectAtIndex:7] objectForKey:@"input"];
        UITextField *paypalSignature = [[inputFieldsAsArray objectAtIndex:8] objectForKey:@"input"];

        NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    storename.text,
                                    @"storename",
                                    currency.text,
                                    @"currency",
                                    website_url.text,
                                    @"website_url",
                                    street.text,
                                    @"street",
                                    zip.text,
                                    @"zip",
                                    location.text,
                                    @"location",
                                    paypalUsername.text,
                                    @"paypalUsername",
                                    paypalPassword.text,
                                    @"paypalPassword",
                                    paypalSignature.text,
                                    @"paypalSignature",
                                    
                                    nil];
        if ([props storeInDB:properties]) {
            NSEnumerator *enumerator = [properties keyEnumerator];
            id key;
            
            while ((key = [enumerator nextObject])) {
                //NSLog(@"%@ : %@", key, [dict objectForKey:key]);
                [props store:key value:[properties objectForKey:key]];
            }
            
            [self dismissModalViewControllerAnimated:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Speicher Fehler" 
                                                        message:@"Bitte alle Felder ausfüllen"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release]; 
    }
}

- (IBAction)closeKeyboard:(id)sender {
    for(NSDictionary *t in inputFieldsAsArray){
        UITextField *field = [t objectForKey:@"input"];
        if ([field isEditing]) {
            [field resignFirstResponder];
            break;
        }
    }
}

- (IBAction) nextField:(id)sender {
    for (int i=0; i<[inputFieldsAsArray count]; i++) {
        if ([[[inputFieldsAsArray objectAtIndex:i] objectForKey:@"input"] isEditing] && i!=[inputFieldsAsArray count]-1) {
            [[[inputFieldsAsArray objectAtIndex:i+1] objectForKey:@"input"] becomeFirstResponder];
            if (i+1 == [inputFieldsAsArray count]-1) {
                [toolbarActionButton setTitle:@"Done"];
                [toolbarActionButton setStyle:UIBarButtonItemStyleDone];
            }else {
                [toolbarActionButton setTitle:@"Close"];  
                [toolbarActionButton setStyle:UIBarButtonItemStyleBordered];
            }
            
            NSIndexPath *indexPath = [[inputFieldsAsArray objectAtIndex:i+1] objectForKey:@"indexPath"];
            [localTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            
            break;
        }
    }
}

- (IBAction) prevField:(id)sender {
    for (int i=0; i<[inputFieldsAsArray count]; i++) {
        if ([[[inputFieldsAsArray objectAtIndex:i] objectForKey:@"input"] isEditing] && i!=0) {
            [[[inputFieldsAsArray objectAtIndex:i-1] objectForKey:@"input"] becomeFirstResponder];
            [toolbarActionButton setTitle:@"Close"];
            
            NSIndexPath *indexPath = [[inputFieldsAsArray objectAtIndex:i-1] objectForKey:@"indexPath"];
            [localTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [toolbarActionButton setStyle:UIBarButtonItemStyleBordered];
            
            break;
        }
    }
}

- (void)dealloc {
    [table release];
    [props release];
    [inputFields release];
    [inputFieldsAsArray release];
    [super dealloc];
}

@end
