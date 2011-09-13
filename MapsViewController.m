//
//  MapsViewController.m
//  mobile-payment
//
//  Created by Torben Toepper on 11.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapsViewController.h"

@implementation MapsViewController

@synthesize map, row, addAnnotation;

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
    
    self.title = @"Karte";
    
    //Hide the keypad
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.05;
    span.longitudeDelta=0.05;
    
    CLLocationCoordinate2D location = [self addressLocation];
    region.span=span;
    region.center=location;
    
    if(addAnnotation != nil) {
        [map removeAnnotation:addAnnotation];
        [addAnnotation release];
        addAnnotation = nil;
    }
    
    addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
    addAnnotation.row = row;
    [map addAnnotation:addAnnotation];
    [map setRegion:region animated:TRUE];
    [map regionThatFits:region];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(CLLocationCoordinate2D)addressLocation {
    NSString *text = [NSString stringWithFormat:@"%@,%@,%@", [row objectForKey:@"street"], [row objectForKey:@"zip"], [row objectForKey:@"location"]];
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                           [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSError* error = nil;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
        //Show error
    }
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
}

@end
