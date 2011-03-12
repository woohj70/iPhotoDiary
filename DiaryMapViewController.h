//
//  DiaryMapViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 22..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DiaryMapAnnotation.h"

@interface DiaryMapViewController : UIViewController {
	MKMapView *mapView;
	
	UIButton *mapButton;
	UIButton *satButton;
	UIButton *hybButton;
	
	CLLocationCoordinate2D shareLoc;
	DiaryMapAnnotation *anno;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (id)initWithLocation:(CLLocationCoordinate2D)loc;
- (void)mapViewUpdateLat:(float)lat andLon:(float)lon;

- (IBAction)changeToMap;
- (IBAction)changeToSatlite;
- (IBAction)changeToHybrid;

@property(nonatomic, retain) IBOutlet UIButton *mapButton;
@property(nonatomic, retain) IBOutlet UIButton *satButton;
@property(nonatomic, retain) IBOutlet UIButton *hybButton;
@property(nonatomic, retain) DiaryMapAnnotation *anno;

@property(nonatomic) CLLocationCoordinate2D shareLoc;
@end
