//
//  FindViewController.m
//  mobile-payment
//
//  Created by Torben Toepper on 26.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FindViewController.h"

@implementation FindViewController

@synthesize webView, locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [locationManager startUpdatingLocation];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D coords = newLocation.coordinate;
    
    if (coords.longitude != longitude || coords.latitude != latitude) {
        //- (void)loadRequest:(NSURLRequest *)request
        NSString *url = [NSString stringWithFormat:@"http://192.168.9.109:3000/customers?latitude=%f&longitude=%f", coords.latitude, coords.longitude];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        NSLog(@"%@", url);
        [locationManager stopUpdatingLocation];
        
        longitude = coords.longitude;
        latitude  = coords.latitude;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

-(void)dealloc {
    [locationManager release];
    [webView release];
    [super dealloc];
}

@end
