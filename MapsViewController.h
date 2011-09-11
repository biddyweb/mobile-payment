//
//  MapsViewController.h
//  mobile-payment
//
//  Created by Torben Toepper on 11.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AddressAnnotation.h"

@interface MapsViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *map;
    NSDictionary *row;
    AddressAnnotation *addAnnotation;
}

@property(nonatomic, retain) IBOutlet MKMapView *map;
@property(nonatomic, retain) NSDictionary *row;
@property(nonatomic, retain) AddressAnnotation *addAnnotation;

-(CLLocationCoordinate2D)addressLocation;

@end
