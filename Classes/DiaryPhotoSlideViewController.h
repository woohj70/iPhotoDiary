//
//  DiaryPgotoSlideViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 23..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "DiaryData.h"
#import "DiaryMapAnnotation.h"


@interface DiaryPhotoSlideViewController : UIViewController {
	DiaryData *diaryData;
	NSArray *imageArray;
	NSMutableArray *tempImageArray;
	NSSet *imageSet;
	
	IBOutlet UIScrollView *scrollView1;	// holds five small images to scroll horizontally
	NSManagedObjectContext *managedObjectContext;
	
	MKMapView *mapView;
	UIButton *mapViewButton;
	BOOL isMapView;
	DiaryMapAnnotation *annotation;
	
	UIButton *mapButton;
	UIButton *satButton;
	UIButton *hybButton;
    
    UIImageView *bottomView;
}

@property(nonatomic, retain) DiaryData *diaryData;
@property(nonatomic, retain) NSSet *imageSet;
@property(nonatomic, retain) NSArray *imageArray;

@property(nonatomic, retain) UIView *scrollView1;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UIButton *mapViewButton;

@property(nonatomic, retain) IBOutlet UIButton *mapButton;
@property(nonatomic, retain) IBOutlet UIButton *satButton;
@property(nonatomic, retain) IBOutlet UIButton *hybButton;

@property(nonatomic, retain) IBOutlet UIImageView *bottomView;

- (IBAction)mapViewButtonClicked;

- (IBAction)changeToMap;
- (IBAction)changeToSatlite;
- (IBAction)changeToHybrid;

@end
