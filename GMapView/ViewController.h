//
//  ViewController.h
//  GMapView
//
//  Created by Vinod on 25/11/15.
//  Copyright © 2015 Vinod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

@interface ViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@end

