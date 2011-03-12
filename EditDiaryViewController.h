//
//  EditDiaryViewController.h
//  iPhotoDiafile://localhost/Project/iPhotoDiary/EditDiaryViewController.xibry
//
//  Created by HYOUNG JUN WOO on 10. 5. 1..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>
#import <ImageIO/ImageIO.h>

#import "iPhotoDiaryAppDelegate.h"
#import "DiaryMapViewController.h"
#import "AppMainViewController.h"
#import "EXF.h"

#import "ChildData.h"
#import "DiaryData.h"
#import "DiaryPhotoSlideViewController.h"
#import "DiaryMapAnnotation.h"


@class CalendarViewController;

@protocol EditDiaryViewControllerDelegate;

@interface EditDiaryViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, 
					UINavigationControllerDelegate, UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate,
					CLLocationManagerDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate> {
	CalendarViewController *calendarViewController;
	
	UILabel *testLabel;
	UIButton *cameralButton;
	UIButton *imageViewButton;
//	UIBarButtonItem *closeViewButton;
//	UIBarButtonItem *saveButton;
	
	UITextField *titleField;
	UITextView *contentView;
	UIImageView *photoZone;
	UIImageView *photoFrame;

	UIScrollView *scrollView;
	UIControl *contentsView;
	UITextView *activeView;
	UITextField *activeField;
	
	BOOL keyboardShown;
	BOOL isCameraShot;
	BOOL isSetCoord;
//	EXFJpeg *imageData;
						
	CLLocationManager *locManager;
	BOOL wasFound;
	BOOL isLocation;
	BOOL modifyMode;
						
	UIActivityIndicatorView *activityIndicator;
	UIImage *geoTaggedImage;
	MKMapView *mapView;
						
	CLLocationCoordinate2D shareLoc;
			
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectContext *imageContext;
						
	ChildData *childData;
	DiaryData *diaryData;
						
	NSMutableArray *imageArray;
						
	NSDateFormatter *dateFormatter;
						
	double latitude;
	double longitude;
						
	DiaryMapAnnotation *annotation;
	DiaryPhotoSlideViewController *photoSlideController;
	id<EditDiaryViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIImageView *photoZone;
@property (nonatomic, retain) IBOutlet UIImageView *photoFrame;
@property (nonatomic, retain) CalendarViewController *calendarViewController;

//@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *cameralButton;
@property (nonatomic, retain) IBOutlet UIButton *imageViewButton;
//@property (nonatomic, retain) UIBarButtonItem *closeViewButton;

@property (nonatomic, retain) IBOutlet UITextField *titleField;
@property (nonatomic, retain) IBOutlet UITextView *contentView;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIControl *contentsView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UILabel *testLabel;
//@property (nonatomic, retain) EXFJpeg *imageData;

//Location
@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain) UIImage *geoTaggedImage;
@property (nonatomic) CLLocationCoordinate2D shareLoc;
@property (nonatomic, retain) DiaryMapAnnotation *annotation;

//CoreData
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) ChildData *childData;
@property (nonatomic, retain) DiaryData *diaryData;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@property (nonatomic, retain) UITextView *activeView;
@property (nonatomic, retain) UITextField *activeField;
@property (nonatomic, retain) DiaryPhotoSlideViewController *photoSlideController;
@property (nonatomic, retain) NSManagedObjectContext *imageContext;
@property (nonatomic, assign) id<EditDiaryViewControllerDelegate> delegate;

- (void)imageViewTapped;
- (void)showAlertView:(NSString *)message;
- (void)findLocation;
- (void)mapViewUpdateLat:(float)lat andLon:(float)lon;

//- (IBAction)saveButtonClicked;
- (IBAction)cameralButtonClicked;
- (IBAction)viewImageList;
//- (IBAction)closeViewButtonClicked;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTab:(id)sender;

- (IBAction)viewLargeMap;
- (void)dismissKeyboard:(UIButton *)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@protocol EditDiaryViewControllerDelegate
- (void)reloadTableView:(NSString *)conditionStr;
@end