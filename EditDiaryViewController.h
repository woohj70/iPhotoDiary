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
#import "DiaryImage.h"
#import "DiaryPhotoSlideViewController.h"
#import "DiaryMapAnnotation.h"

#import "TBXML.h"


@class CalendarViewController;

@protocol EditDiaryViewControllerDelegate;

@interface EditDiaryViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, 
					UINavigationControllerDelegate, UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate,
					CLLocationManagerDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, MKReverseGeocoderDelegate> {
	CalendarViewController *calendarViewController;
                        UIImageView *thumbnailView;
	UIButton *cameralButton;
	UIButton *imageViewButton;
//	UIBarButtonItem *closeViewButton;
//	UIBarButtonItem *saveButton;
	
	UITextField *titleField;
	UITextView *contentView;
	UIImageView *photoZone;
                        UIButton *doneButton;
                        
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
						
	CLLocationCoordinate2D shareLoc;
			
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectContext *imageContext;
						
	ChildData *childData;
	DiaryData *diaryData;
						
	NSMutableArray *imageArray;
                        NSMutableArray *imageContextArray;
						
	NSDateFormatter *dateFormatter;
						
	double latitude;
	double longitude;
						
	DiaryMapAnnotation *annotation;
	DiaryPhotoSlideViewController *photoSlideController;
	id<EditDiaryViewControllerDelegate> delegate;
                        
                        MKReverseGeocoder *reversGeo;
                        NSString *reverseAddr;
                        NSString *country;
                        NSString *administrativeArea;
                        NSString *subAdministrativeArea;
                        NSString *locality;
                        NSString *subLocality;
                        NSString *thoroughfare;
                        NSString *subThoroughfare;
                        NSString *postalCode;
                        UILabel *locField;
                        
                        NSString *wIconName;
                        
                        UIImageView *weatherIcon;
                        NSString *tempHL;
                        NSString *currTemp;
                        NSString *city;
                        NSString *currCondition;                        
                        NSString *lowTemp;
                        NSString *highTemp;
                        UIButton *refreshWeather;
                        UILabel *weatherDesc;
                        UILabel *dateTime;
                        
                        NSDictionary *enCityNameDic;
                        
//                        BOOL isFindLocation;
                        BOOL isFirstWeatherGet;
                        BOOL isGetWeatherEnd;
                        int repeatCnt;
                        int iconRepeatCnt;
                        int currCondCnt;
                        
                        UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) IBOutlet UIImageView *thumbnailView;
@property (nonatomic, retain) IBOutlet UIImageView *photoZone;
@property (nonatomic, retain) CalendarViewController *calendarViewController;

//@property (nonatomic, retain) UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *cameralButton;
@property (nonatomic, retain) IBOutlet UIButton *imageViewButton;
//@property (nonatomic, retain) UIBarButtonItem *closeViewButton;

@property (nonatomic, retain) IBOutlet UITextField *titleField;
@property (nonatomic, retain) IBOutlet UITextView *contentView;
@property (nonatomic, retain) UIButton *doneButton;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIControl *contentsView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;


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
@property (nonatomic, retain) NSMutableArray *imageContextArray;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@property (nonatomic, retain) UITextView *activeView;
@property (nonatomic, retain) UITextField *activeField;
@property (nonatomic, retain) DiaryPhotoSlideViewController *photoSlideController;
@property (nonatomic, retain) NSManagedObjectContext *imageContext;
@property (nonatomic, assign) id<EditDiaryViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *wIconName;

@property (nonatomic, copy) NSString *reverseAddr;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *administrativeArea;
@property (nonatomic, copy) NSString *subAdministrativeArea;
@property (nonatomic, copy) NSString *locality;
@property (nonatomic, copy) NSString *subLocality;
@property (nonatomic, copy) NSString *thoroughfare;
@property (nonatomic, copy) NSString *subThoroughfare;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, retain) IBOutlet UILabel *locField;

@property (nonatomic, retain) IBOutlet UIImageView *weatherIcon;
@property (nonatomic, copy) NSString *tempHL;
@property (nonatomic, copy) NSString *currTemp;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *currCondition;
@property (nonatomic, copy) NSString *lowTemp;
@property (nonatomic, copy) NSString *highTemp;
@property (nonatomic, retain) IBOutlet UIButton *refreshWeather;
@property (nonatomic, retain) IBOutlet UILabel *weatherDesc;
@property (nonatomic, retain) IBOutlet UILabel *dateTime;

@property (nonatomic, retain) MKReverseGeocoder *reversGeo;
@property (nonatomic, retain) NSDictionary *enCityNameDic;

- (void)imageViewTapped;
- (void)showAlertView:(NSString *)message;
- (void)findLocation;
- (void)mapViewUpdateLat:(float)lat andLon:(float)lon;
- (IBAction) refreshWeatherClicked;

//- (IBAction)saveButtonClicked;
- (IBAction)cameralButtonClicked;
- (IBAction)viewImageList;
//- (IBAction)closeViewButtonClicked;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTab:(id)sender;

- (void)dismissKeyboard:(UIButton *)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@protocol EditDiaryViewControllerDelegate
- (void)reloadTableView:(NSString *)conditionStr;
@end