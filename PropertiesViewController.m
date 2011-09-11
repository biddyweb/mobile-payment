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

@synthesize props, table, inputFields, keyboardToolbar, toolbarActionButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self prepare];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self prepare];
    }
    return self;
}

-(void)prepare {
    inputFields = [[NSMutableArray alloc] init];
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
    // Do any additional setup after loading the view from its nib.
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
    return [table count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section >= [table count]) {
        return 1;
    } else {
        return [[table objectAtIndex:section] count];
    }
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
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    
        if ([indexPath section] == 0 || [indexPath section] == 1) {
            NSArray *arr = [table objectAtIndex:[indexPath section]];
            NSDictionary *dict = [arr objectAtIndex:[indexPath row]];
            UITextField *input;
            
            input = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
            [input setDelegate:self];
            [input setBorderStyle:UITextBorderStyleNone];
            input.placeholder = [dict objectForKey:@"key"];
            
            input.secureTextEntry = [self isFieldProtected:[dict objectForKey:@"key"]];
            
            if ([[dict objectForKey:@"key"] isEqualToString:@"currency"]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                input.enabled = false;
            }
            if ([[dict objectForKey:@"key"] isEqualToString:@"website_url"]) {
                input.keyboardType = UIKeyboardTypeURL;
                input.autocorrectionType = UITextAutocorrectionTypeNo;
            }
            
            cell.textLabel.text = [dict objectForKey:@"key"];
            [[cell contentView] addSubview:input];
            
            [input setFrame:CGRectMake(100+tablePadding,12,tableWidth-tablePadding-140,25)];
            [input setText:[dict objectForKey:@"value"]];
            
            [inputFields addObject:[NSDictionary dictionaryWithObjectsAndKeys:indexPath, @"indexPath", input, @"input", nil]];
        } else {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitle:@"Speichern" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
            [[cell contentView] addSubview:button];
            [button setFrame:CGRectMake(10,10,tableWidth-tablePadding,25)];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
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
    [textField setInputAccessoryView:keyboardToolbar];
    for (int i=0; i<[inputFields count]; i++) {
        if ([[inputFields objectAtIndex:i] objectForKey:@"input"] == textField) {
            if (i==[inputFields count]-1) {
                toolbarActionButton.title = @"Done";
                [toolbarActionButton setStyle:UIBarButtonItemStyleDone];    
            }
            
            //NSIndexPath *indexPath = [[inputFields objectAtIndex:i] objectForKey:@"indexPath"];
            //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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
    for(int i=0,n=[inputFields count];i<n;i++) {
        UITextField *textfield = [[inputFields objectAtIndex:i] objectForKey:@"input"];
        if ([textfield.text length] <= 0) {
            return false;
        }
    }

    return true;
}

-(IBAction)submit:(id)sender {
    if([self check]) {
        UITextField *storename = [[inputFields objectAtIndex:0] objectForKey:@"input"];
        UITextField *currency = [[inputFields objectAtIndex:1] objectForKey:@"input"];
        UITextField *website_url = [[inputFields objectAtIndex:2] objectForKey:@"input"];
        UITextField *street = [[inputFields objectAtIndex:3] objectForKey:@"input"];
        UITextField *zip = [[inputFields objectAtIndex:4] objectForKey:@"input"];
        UITextField *location = [[inputFields objectAtIndex:5] objectForKey:@"input"];
        UITextField *paypalUsername = [[inputFields objectAtIndex:6] objectForKey:@"input"];
        UITextField *paypalPassword = [[inputFields objectAtIndex:7] objectForKey:@"input"];
        UITextField *paypalSignature = [[inputFields objectAtIndex:8] objectForKey:@"input"];

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
    for(NSDictionary *t in inputFields){
        UITextField *field = [t objectForKey:@"input"];
        if ([field isEditing]) {
            [field resignFirstResponder];
            break;
        }
    }
}

- (IBAction) nextField:(id)sender {
    for (int i=0; i<[inputFields count]; i++) {
        if ([[[inputFields objectAtIndex:i] objectForKey:@"input"] isEditing] && i!=[inputFields count]-1) {
            [[[inputFields objectAtIndex:i+1] objectForKey:@"input"] becomeFirstResponder];
            if (i+1 == [inputFields count]-1) {
                [toolbarActionButton setTitle:@"Done"];
                [toolbarActionButton setStyle:UIBarButtonItemStyleDone];
            }else {
                [toolbarActionButton setTitle:@"Close"];  
                [toolbarActionButton setStyle:UIBarButtonItemStyleBordered];
            }
            
            NSIndexPath *indexPath = [[inputFields objectAtIndex:i+1] objectForKey:@"indexPath"];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            
            break;
        }
    }
}

- (IBAction) prevField:(id)sender {
    for (int i=0; i<[inputFields count]; i++) {
        if ([[[inputFields objectAtIndex:i] objectForKey:@"input"] isEditing] && i!=0) {
            [[[inputFields objectAtIndex:i-1] objectForKey:@"input"] becomeFirstResponder];
            [toolbarActionButton setTitle:@"Close"];
            
            NSIndexPath *indexPath = [[inputFields objectAtIndex:i-1] objectForKey:@"indexPath"];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [toolbarActionButton setStyle:UIBarButtonItemStyleBordered];
            
            break;
        }
    }
}

- (void)dealloc {
    [table release];
    [props release];
    [inputFields release];
    [super dealloc];
}

@end
