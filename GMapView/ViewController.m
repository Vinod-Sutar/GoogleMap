//
//  ViewController.m
//  GMapView
//
//  Created by Vinod on 25/11/15.
//  Copyright © 2015 Vinod. All rights reserved.
//

#import "ViewController.h"
@import GoogleMaps;

@interface ViewController ()

@end

@implementation ViewController
{
    GMSMapView *mapView_;
    NSMutableArray * objGMSMarkerArray;
    int count;
    NSTimer * objTimer;
    GMSMarker *marker ;
    GMSPlacePicker * _placePicker;
    GMSPlacesClient * _placesClient;
}

- (void)viewDidLoad {
    count = 0;
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:18.652963
                                                            longitude:73.768442
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    mapView_.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    objGMSMarkerArray = [NSMutableArray new];
    
    for (int i=0; i<0; i++)
    {
    }
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(18.652963 , 73.768442);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.title = [NSString stringWithFormat:@"Marker"];
    marker.snippet = [NSString stringWithFormat:@"Snippet comes here\nI dont know what to write here"];
    marker.map = mapView_;
    
    //[self setTimer];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        marker.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    }
}

-(void) setTimer
{
    objTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                target:self
                                              selector:@selector(targetMethod:)
                                              userInfo:nil
                                               repeats:YES];
}

-(void) targetMethod : (id) sender
{
    NSLog(@"Call");
    count++;
    id object = [objGMSMarkerArray objectAtIndex:(count % 10)];
    if([object isKindOfClass:[GMSMarker class]])
    {
        GMSMarker * objGMSMarker = (GMSMarker*)object;
        objGMSMarker.zIndex = count;
        mapView_.selectedMarker = objGMSMarker;
    }
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSLog(@"info window tapped!");
}


- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
}


- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
    NSLog(@"coordinate : %f ::: %f", coordinate.latitude, coordinate.longitude);
    
    CLLocationCoordinate2D center = coordinate;
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001);
    
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        marker.position = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude);
        
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place attributions %@", place.attributions.string);
        } else {
            NSLog(@"No place selected");
        }
    }];
}

@end
