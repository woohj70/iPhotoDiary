//
//  EditDiaryViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 1..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "EditDiaryViewController.h"
#import "CalendarViewController.h"
#import "EXFLogging.h"
#import "EXFUtils.h"

@implementation EditDiaryViewController

@synthesize testLabel;
@synthesize photoZone;
@synthesize photoFrame;
@synthesize calendarViewController;
//@synthesize saveButton;
@synthesize titleField;
@synthesize contentView;
//@synthesize closeViewButton;
@synthesize cameralButton;
@synthesize imageViewButton;
@synthesize scrollView, contentsView;
@synthesize activityIndicator;
//@synthesize imageData;

@synthesize locManager, geoTaggedImage, mapView;

@synthesize fetchedResultsController, managedObjectContext, childData, diaryData, imageArray;
@synthesize dateFormatter;

@synthesize activeView;
@synthesize activeField;
@synthesize photoSlideController;

@synthesize imageContext;
@synthesize delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
//		self.title = @"일기 쓰기";
		
		
		keyboardShown = NO;
		isSetCoord = NO;
		isCameraShot = YES;		
		modifyMode = NO;
		[self registerForKeyboardNotifications];
	}
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		keyboardShown = NO;
		isSetCoord = NO;
		isCameraShot = NO;
		modifyMode = YES;
		[self registerForKeyboardNotifications];
		self.managedObjectContext = managedObjectContext;
    }
    return self;
}


- (void)setViewInScrollView {
	
	//	 innerViewController = [[EditDiaryViewController alloc] initWithNibName:@"EditDiaryViewController" bundle:nil];
	
    [scrollView addSubview:contentsView];
    [scrollView setContentSize:[contentsView frame].size];
//	scrollView.scrollEnabled = YES;
	/*
	 [scrollView setBackgroundColor:[UIColor blackColor]];
	 [scrollView setCanCancelContentTouches:NO];
	 scrollView.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
	 scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	 UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diary_background.png"]];
	 [scrollView addSubview:imageView];
	 [scrollView setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
	 [scrollView setScrollEnabled:YES];
	 [imageView release];
	 */
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	CGRect labelFrame = CGRectMake(0.0, 0.0, 170.0, 40.0); 
	UILabel *label = [[[UILabel alloc] initWithFrame:labelFrame] autorelease]; 
	label.font = [UIFont boldSystemFontOfSize:18]; 
	label.numberOfLines = 2; 
	label.backgroundColor = [UIColor clearColor]; 
	label.textAlignment = UITextAlignmentRight; 
	label.textColor = [UIColor blackColor]; 
	label.shadowColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(0.0, -1.0); 
	label.lineBreakMode = UILineBreakModeCharacterWrap;
	label.text = @"\n일기 쓰기";
	self.navigationItem.titleView = label;
	//	scrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setDelegate:self];
	//    [scrollView setBouncesZoom:YES];
	//    [[self view] addSubview:scrollView];
	

	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"저 장" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *closeViewButton = [[UIBarButtonItem alloc] initWithTitle:@"취 소" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = closeViewButton;
	[closeViewButton release];
    
    [self setViewInScrollView];
	
	[self.view addSubview:activityIndicator];
	
	isLocation = NO;
	
//	mapView.frame = CGRectMake(160, 41, 145, 192);
		
	if (!locManager.locationServicesEnabled) {
//		[self showAlertView:@"위치 검색 서비스를 사용할 수 없습니다.\n실내에 계실 경우 실외로 나가셔서 다시 시도해보시기 바랍니다."];
	} else {
		
	}

	Debug("Selected Child Name = %@", [AppMainViewController selectedChildName]);
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	imageArray = [[NSMutableArray alloc] initWithCapacity:8];
	
	if (diaryData != nil) {
		[self setDiaryDataFields];
	} else {
		[mapView setShowsUserLocation:YES];
		[self fetchRequestResult:[AppMainViewController selectedChildName]];
	}
	
	[mapView setShowsUserLocation:YES];
	locManager = [[CLLocationManager alloc] init];
	[locManager setDelegate:self];
	[locManager setDesiredAccuracy:kCLLocationAccuracyBest];
	
	[self findLocation];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	Debug(@"imageArray count = %d", [imageArray count]);
	if (diaryData != nil) {
		cameralButton.hidden = YES;
		imageViewButton.hidden = NO;
		imageViewButton.frame = CGRectMake(9, 203, 135, 26);
	}else if ([imageArray count] > 0 || isSetCoord) {
		imageViewButton.hidden = NO;
		cameralButton.hidden = NO;
		cameralButton.frame = CGRectMake(9, 203, 63, 26);
	} else {
		imageViewButton.hidden = YES;
		cameralButton.hidden = NO;
		cameralButton.frame = CGRectMake(9, 203, 135, 26);
	}
}
/*
- (id)init {
	if (self = [super init]) {
		self.title = @"일기 쓰기";
	}
	
	return self;
}
*/

/*
- (void)loadView {
	[super loadView];
	
	
}
*/

- (void)setDiaryDataFields {
	self.titleField.text = diaryData.tag;
	self.photoZone.image = diaryData.thumbnailImage;
	self.contentView.text = diaryData.content;
	
	NSManagedObjectContext *imageContext = [diaryData.image anyObject];
	latitude = [[imageContext valueForKey:@"latitude"] doubleValue];
	longitude = [[imageContext valueForKey:@"longitude"] doubleValue];
	Debug(@"setDiaryDataFields : lat = %f. lon = %f", shareLoc.latitude, shareLoc.longitude);
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.cancelButtonIndex) {
		Debug(@"cancel butoon clicked");
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark Fetched results controller

- (void)fetchRequestResult:(NSString *)cName {
	Debug(@"section count = %d", [[fetchedResultsController sections] count]);
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
	Debug(@"row count = %d", [sectionInfo numberOfObjects]);
	
		NSPredicate *predicate = nil;
	
		if (cName != nil && [cName length]) {
			predicate = [NSPredicate predicateWithFormat:@"childname == %@", cName];
		}
	
		[fetchedResultsController.fetchRequest setPredicate:predicate];
	
	managedObjectContext = [fetchedResultsController managedObjectContext];
	
//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchedResultsController.fetchRequest setEntity:[NSEntityDescription entityForName:@"ChildData" inManagedObjectContext:managedObjectContext]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"birthday" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchedResultsController.fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error;
	NSArray *childDatas = [managedObjectContext executeFetchRequest:fetchedResultsController.fetchRequest error:&error];
	
//	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	Debug(@"self.childDatas count = %d, cName = %@", [childDatas count], cName);
	
	if ([childDatas count] > 0) {
		for (NSInteger i = 0; i < [childDatas count]; i++) {
			childData = [childDatas objectAtIndex:i];
			Debug(@"childData.name = %@, childData.nickname = %@", childData.childname, childData.nickname);
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"미등록 알림" 
							  message:@"등록된 아기가 없습니다.\n아기를 먼저 등록해주세요."
							  delegate:self 
							  cancelButtonTitle:@"확 인" 
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		//	AddChildViewController *nextViewController = [[AddChildViewController alloc] initWithStyle:UITableViewStyleGrouped withDelegate:self withManagedObjectContext:self.managedObjectContext];
	}
	
	
}

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    Debug(@"fetchedResultsController");
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChildData" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *birthdayDescriptor = [[NSSortDescriptor alloc] initWithKey:@"birthday" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:birthdayDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[birthdayDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}


#pragma mark -
#pragma mark Image Process
- (IBAction)viewImageList {
	photoSlideController = [[DiaryPhotoSlideViewController alloc] init];
	photoSlideController.diaryData = self.diaryData;
	photoSlideController.imageArray = self.imageArray;
	photoSlideController.managedObjectContext = self.managedObjectContext;
	[self.navigationController pushViewController:photoSlideController animated:YES];
//	[photoSlideController release];
}

- (void)imageViewTapped {
	UIActionSheet *photoSelector = [[UIActionSheet alloc]
										 initWithTitle:@"사진 선택" 
										 delegate:self 
										 cancelButtonTitle:@"취 소" 
										 destructiveButtonTitle:nil 
										 otherButtonTitles:@"사진 새로 찍기", @"찍은 사진 가져오기", nil];
	[photoSelector showInView:self.view];
//	[photoSelector release];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {		
	NSString *msg = nil;
		
	if (buttonIndex != [actionSheet cancelButtonIndex]) {
		
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.view.userInteractionEnabled = YES;

		if (buttonIndex == 0) {
			//msg = @"'사진 새로 찍기'가 선택되었습니다.";
			isCameraShot = YES;	
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		} else if (buttonIndex == 1) {
			//msg = @"'찍은 사진 가져오기'가 선택되었습니다.";
			isCameraShot = NO;
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		
		[self presentModalViewController:picker animated:YES];
		[picker release];

	}

	[actionSheet release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	Debug(@"didFinishPickingMediaWithInfo");
	//EXIF 정보를 추출하여 처리하는 로직 추가
/*
	NSData * uiJpeg = UIImageJPEGRepresentation (image, 1.0 );
	
	EXFJpeg* jpegScanner = [[EXFJpeg alloc] init];
	[jpegScanner scanImageData: uiJpeg];
	
	EXFMetaData *exifData = jpegScanner.exifMetaData;
	EXFJFIF *jfif = jpegScanner.jfif;
	
	[jpegScanner release];
*/
//	if (isCameraShot) {
	
	
		
//	}
	Debug(@"end Finding");
	
	NSArray* keys = [info allKeys];
//	for (int i=0;i<[keys count];i++) {
//		NSLog(@"%@ : %@",[keys objectAtIndex:i],[info objectForKey:[keys objectAtIndex:i]]);
//	}
	
	if ( [info objectForKey:@"UIImagePickerControllerEditedImage"] ) {
		photoZone.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
		geoTaggedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	} else {
		photoZone.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		geoTaggedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	}
	
//	[imageArray addObject:(UIImage *)geoTaggedImage];

	//Image 관련 데이터 저장 /////////////////////////////////////////////
	imageContext = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryImage" inManagedObjectContext:managedObjectContext];
	
	// Set the image for the image managed object.
	[imageContext setValue:geoTaggedImage forKey:@"image"];
	
	while (!isLocation) {
		Debug(@"start Finding");
		[self findLocation];	
	}
	
//	if (isLocation) {
		
//	}
	
	///////////////////////////////////////////////////////////////////
	
	[locManager stopUpdatingLocation];
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)findLocation {
	Debug(@"findLocation==============================================");
	if (isLocation) {
		Debug(@"findLocation : isLocation YES==============================================");
		[cameralButton setTitle:@"사진" forState:UIControlStateNormal];
	} else {
		Debug(@"findLocation : isLocation NO==============================================");
		wasFound = NO;
		
		[activityIndicator startAnimating];
		[cameralButton setTitle:@"위치 정보 검색 중..." forState:UIControlStateNormal];
		[locManager startUpdatingLocation];
	}
	
	isLocation = !isLocation;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	Debug(@"didUpdateToLocation==============================================");
	
	if (wasFound) {
		Debug(@"didUpdateToLocation : wasFound YES==============================================");
		return;
	}

	CLLocationCoordinate2D loc = [newLocation coordinate];

	if (isCameraShot) {
		Debug(@"diaryData is nil==============================================");
		shareLoc.latitude = loc.latitude;
		shareLoc.longitude = loc.longitude;
		
		latitude = loc.latitude;
		longitude = loc.longitude;
		
		if (loc.latitude != -180.00000000 && loc.longitude != -180.00000000) {
			wasFound = YES;
			Debug(@"didUpdateToLocation : loc.lat = %f, loc.lon = %f==============================================", loc.latitude, loc.longitude);
			Debug(@"didUpdateToLocation : latitude = %f, longitude = %f==============================================", latitude, longitude);
			
			if (isSetCoord) {
				Debug(@"setValue latitude = %f, longitude = %f", latitude, longitude);
				
				[imageContext setValue:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
				[imageContext setValue:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
				[imageArray addObject:(NSManagedObjectContext *)imageContext];
			}
			
			[self mapViewUpdateLat:loc.latitude andLon:loc.longitude];
		}
	} else {
		Debug(@"diaryData is not nil==============================================");
		
		NSArray *imageContextArray = [diaryData.image allObjects];
		BOOL setCoord = NO;
		for (NSInteger i = 0; i < [imageContextArray count]; i++) {
			NSManagedObjectContext *imageContext = (NSManagedObjectContext *)[imageContextArray objectAtIndex:i];
			
			if ([[imageContext valueForKey:@"latitude"] doubleValue] != -180.00000000 && [[imageContext valueForKey:@"longitude"] doubleValue] != -180.00000000) {
				shareLoc.latitude = [[imageContext valueForKey:@"latitude"] doubleValue];
				shareLoc.longitude = [[imageContext valueForKey:@"longitude"] doubleValue];
				
				latitude = [[imageContext valueForKey:@"latitude"] doubleValue];
				longitude = [[imageContext valueForKey:@"longitude"] doubleValue];
				
				[self mapViewUpdateLat:latitude andLon:longitude];
				setCoord = YES;
				break;
			}
		}
		
		if (!setCoord) {
			[self mapViewUpdateLat:loc.latitude andLon:loc.longitude];
		}
		isLocation = YES;
		wasFound = YES;
//		Debug(@"setDiaryDataFields : lat = %f. lon = %f", shareLoc.latitude, shareLoc.longitude);
//		Debug("[[imageContext valueForKey:latitude] doubleValue] = %f, [[imageContext valueForKey:@longitude] doubleValue] = %f", [[imageContext valueForKey:@"latitude"] doubleValue], [[imageContext valueForKey:@"longitude"] doubleValue]);
//		Debug("shareLoc.latitude = %f, shareLoc.longitude = %f", shareLoc.latitude, shareLoc.longitude);
		
		
	}
	[locManager stopUpdatingLocation];

	
	[activityIndicator stopAnimating];
	[cameralButton setTitle:@"사진" forState:UIControlStateNormal];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[activityIndicator stopAnimating];
	
	Debug(@"Error = %@, %d", error, [error code]);
	switch([error code])
	{
		case kCLErrorNetwork: // general, network-related error
		{
			[self showAlertView:@"네트워크 연결이나 비행기 모드가 정상적으로 설정되어있는지 확인해주세요"];
		}
			break;
		case kCLErrorDenied:{
			[self showAlertView:@"현재 사용자 위치 정보를 사용하도록 허용되어있지 않습니다.\n'설정' 애플리케이션에서 확인해주세요."];
		}
			break;
		default:
		{
			[self showAlertView:@"알 수 없는 네트워크 오류가 발생했습니다."];
		}
			break;
	}
	
	isLocation = NO;
}

- (void)mapViewUpdateLat:(float)lat andLon:(float)lon {
	Debug(@"mapViewUpdateLat start %f, %f", lat, lon);
	MKCoordinateRegion region;
	MKCoordinateSpan span;   // 보여줄 지도가 처리하는 넓이를 정의합니다.  문서 읽어 보시길..
	span.latitudeDelta=0.0005;  // 숫자가 작으면 좁은 영역, 즉 우리동네 자세히~보임
	span.longitudeDelta=0.0005;
	
	CLLocationCoordinate2D mapLoc = mapView.userLocation.coordinate;
	shareLoc = mapView.userLocation.coordinate;
	//그래도 블로깅하려고,  우리나라 위도,경도 찾아서 넣었습니다.
	if (lat == 0 || lat == -180.00000000) {
		mapLoc.latitude = 37.566508;
	} else {
		mapLoc.latitude = lat;
	}

	if (lon == 0 || lon == -180.00000000) {
		mapLoc.longitude = 126.97807;
	} else {
		mapLoc.longitude = lon;
	}
	
	
	region.span=span;   //위에서  정한 크기 설정하고
	region.center=mapLoc;  // 위치 설정하고
	
	[mapView setRegion:region    animated: TRUE];  // 지도 뷰에 지역을 설정하고
	[mapView regionThatFits:region];
	
	if (!isCameraShot) {
		if (annotation != nil) {
			[mapView removeAnnotation:annotation];
		}
		
		annotation = [DiaryMapAnnotation initWithCoordinate:mapLoc andTitle:[diaryData valueForKey:@"tag"]];
		annotation.title = [diaryData valueForKey:@"tag"];
		annotation.subtitle = [diaryData valueForKey:@"conditionDate"];
		[mapView addAnnotation:annotation];
		
		[annotation release];
	} else {
//		annotation = [DiaryMapAnnotation initWithCoordinate:mapLoc andTitle:self.titleField.text];
	}

//	if (latitude != -180.00000000 && longitude != -180.00000000) {
		isLocation = NO;
//	}
	Debug(@"mapViewUpdateLat end");
}

- (IBAction)viewLargeMap {
	Debug(@"viewLargeMap : lat = %f. lon = %f", latitude,longitude);
	
	DiaryMapViewController *mapViewController = [[DiaryMapViewController alloc] initWithLatitude:latitude andLongitude:longitude andAnnotation:annotation];
	[self.navigationController pushViewController:mapViewController animated:YES];
}

/*
-(NSData*) geotagImage:(UIImage*)image withLocation:(CLLocation*)imageLocation {
    NSData* jpegData =  UIImageJPEGRepresentation(image, 0.8);
    EXFJpeg* jpegScanner = [[EXFJpeg alloc] init];
    [jpegScanner scanImageData: jpegData];
    EXFMetaData* exifMetaData = jpegScanner.exifMetaData;
	
    // end of helper methods 
    // adding GPS data to the Exif object 
    NSMutableArray* locArray = [self createLocArray:imageLocation.coordinate.latitude]; 
    EXFGPSLoc* gpsLoc = [[EXFGPSLoc alloc] init]; 
    [self populateGPS: gpsLoc :locArray]; 
	
    [exifMetaData addTagValue:gpsLoc forKey:[NSNumber numberWithInt:EXIF_GPSLatitude] ]; 
    [gpsLoc release]; 
    [locArray release]; 
	
    locArray = [self createLocArray:imageLocation.coordinate.longitude]; 
    gpsLoc = [[EXFGPSLoc alloc] init]; 
    [self populateGPS: gpsLoc :locArray]; 
	
    [exifMetaData addTagValue:gpsLoc forKey:[NSNumber numberWithInt:EXIF_GPSLongitude] ]; 
    [gpsLoc release]; 
    [locArray release];
	
    NSString* ref;
    if (imageLocation.coordinate.latitude <0.0)
        ref = @"S"; 
    else
        ref =@"N"; 	
    [exifMetaData addTagValue: ref forKey:[NSNumber numberWithInt:EXIF_GPSLatitudeRef] ]; 
    
	if (imageLocation.coordinate.longitude <0.0)
        ref = @"W"; 
    else
        ref =@"E"; 
	[exifMetaData addTagValue: ref forKey:[NSNumber numberWithInt:EXIF_GPSLongitudeRef] ]; 
   
	NSMutableData* taggedJpegData = [[NSMutableData alloc] init];
    [jpegScanner populateImageData:taggedJpegData];
    [jpegScanner release];
    return [taggedJpegData autorelease];
}


-(NSMutableArray*) createLocArray:(double) val{
	val = fabs(val);
	NSMutableArray* array = [[NSMutableArray alloc] init];
	double deg = (int)val;
	[array addObject:[NSNumber numberWithDouble:deg]];
	val = val - deg;
	val = val*60;
	double minutes = (int) val;
	[array addObject:[NSNumber numberWithDouble:minutes]];
	val = val - minutes;
	val = val *60;
	double seconds = val;
	[array addObject:[NSNumber numberWithDouble:seconds]];
	return array;
} 

-(void) populateGPS: (EXFGPSLoc*)gpsLoc :(NSArray*) locArray{
	long numDenumArray[2];
	long* arrPtr = numDenumArray;
	[EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:0]];
	EXFraction* fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
	gpsLoc.degrees = fract;
	[fract release];
	[EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:1]];
	fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
	gpsLoc.minutes = fract;
	[fract release];
	[EXFUtils convertRationalToFraction:&arrPtr :[locArray objectAtIndex:2]];
	fract = [[EXFraction alloc] initWith:numDenumArray[0] :numDenumArray[1]];
	gpsLoc.seconds = fract;
	[fract release];
}
*/

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	isLocation = YES;
	isSetCoord = NO;
	[picker dismissModalViewControllerAnimated:YES];
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UITouch *touch = [touches anyObject];
		CGPoint currentPos = [touch locationInView:self.view];
		if (CGRectContainsPoint([photoFrame frame], currentPos)) {	
			Debug(@"touchesBegan");
			[self imageViewTapped];
		}
	}
}
*/

/*
- (IBAction)saveButtonClicked {
	[self showAlertView:@"Save Button Clicked"];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)closeViewButtonClicked {
	[self showAlertView:@"closeViewButton Button Clicked"];
	[self dismissModalViewControllerAnimated:YES];
}
*/

- (IBAction)cameralButtonClicked {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		isLocation = NO;
		isSetCoord = YES;
		[self imageViewTapped]; 
	}
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)backgroundTab:(id)sender {
	[titleField resignFirstResponder];
	[contentView resignFirstResponder];
}

- (void)showAlertView:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"알   림" 
						  message:message
						  delegate:nil 
						  cancelButtonTitle:@"Yep, I Did." 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



#pragma mark -
#pragma mark Keyboard Notification
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	/*
    if (keyboardShown)
        return;
	
    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
	
    // Resize the scroll view (which is the root view of the window)
    CGRect viewFrame = [scrollView frame];
    viewFrame.size.height -= keyboardSize.height;
    scrollView.frame = viewFrame;
	
    // Scroll the active text field into view.
    CGRect textFieldRect = [contentView frame];
    [scrollView scrollRectToVisible:textFieldRect animated:YES];
	
    keyboardShown = YES;
	 */
	
	if (keyboardShown)
        return;
	
	if (activeView == nil) {
		return;
	}
	
	
	
	Debug(@"keyboardWasShown");
	scrollView.scrollEnabled = YES;
	
    NSDictionary* info = [aNotification userInfo];
	
	
    CGSize kbSize = [[info objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size;
	
	UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 242, 48.0, 25.0)];

	[doneButton setBackgroundImage:[UIImage imageNamed:@"btnDismissKeyboard.png"] forState:UIControlStateNormal];	
	[doneButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchDown];
	doneButton.titleLabel.font = [UIFont systemFontOfSize: 16];
	[self.view addSubview:doneButton];
	[doneButton release];

    [scrollView setContentOffset:CGPointMake(0.0, kbSize.height) animated:YES];
	
    keyboardShown = YES;
}

- (void)dismissKeyboard:(UIButton *)sender {
	Debug(@"dismissKeyboard");
	[contentView resignFirstResponder];
	[sender removeFromSuperview];
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
	scrollView.scrollEnabled = NO;
//    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
//    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
//    CGSize keyboardSize = [aValue CGRectValue].size;
	
    // Reset the height of the scroll view to its original value
	[scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
	
    keyboardShown = NO;
}

#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter {	
 	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateFormat:@"yyyy'년' mm'월'"];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}

	
	return dateFormatter;
}

#pragma mark -
#pragma mark Save & Cancel

- (void) save {
	Debug("Save 0000");
	NSManagedObjectContext *context = self.managedObjectContext;
	Debug("Save 0000 - 1");
	
	BOOL editmode = YES;
	
	
	NSString *newDateString = nil;
	/*
	 If there isn't an ingredient object, create and configure one.
	 */
    if (!diaryData) {
		editmode = NO;
		Debug("Save 1111");
        diaryData = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryData" inManagedObjectContext:context];
		Debug("Save 2222");
        [childData addDiaryObject:diaryData];
		Debug("Save 3333");
//		ingredient.displayOrder = [NSNumber numberWithInteger:[recipe.ingredients count]];
    }
	
	/*
	@dynamic writedate;
	@dynamic content;
	@dynamic tag;
	@dynamic thumbnailImage;
	@dynamic image;
	@dynamic child;
	*/
	
//	imageSet = [[NSMutableSet alloc] initWithArray:imageArray];
	
	diaryData.tag = self.titleField.text;
	diaryData.content = self.contentView.text;
	
	if (!editmode) {
		diaryData.writedate = [NSDate date];
		
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm"];
		
		//	NSDate *formatterDate = [inputFormatter dateFromString:@"1999-07-11 at 10:30"];
		
		NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
		[outputFormatter setDateFormat:@"yyyy'년' MM'월'"];
		
		newDateString = [outputFormatter stringFromDate:[NSDate date]];
		Debug("Save 3333 - newDateString = %@", newDateString);
		
		[inputFormatter release];
		[outputFormatter release];
		diaryData.sectionDate = newDateString;
		
		unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
		NSCalendar *cal = [NSCalendar currentCalendar];
		NSDateComponents *dateComponent = [cal components:unitFlags fromDate:[NSDate date]];
		
		[diaryData setValue:[NSString stringWithFormat:@"%d. %d. %d.", dateComponent.year, dateComponent.month, dateComponent.day] forKey:@"conditionDate"];
	}
	
	

	diaryData.child = childData;
	Debug("Save 3333 - 1");

	//Image 관련 데이터 저장 /////////////////////////////////////////////
	if (!modifyMode) {
		NSSet *oldImage = diaryData.image;
		Debug(@"EditDiaryViewController.save - 기존 이미지 가져오기.");
		if (oldImage != nil) {
			[managedObjectContext deleteObject:oldImage];
		}
		
		NSSet *imageSet = [[NSSet alloc] initWithArray:imageArray];
		[diaryData addImage:imageSet];
		
		[imageSet release];
		
		
	}	
	
/*	
	// Create a thumbnail version of the image for the recipe object.

	CGSize size = originalImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 150.0 / size.width;
	} else {
		ratio = 150.0 / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	Debug(@"thumbnail rect = %f, %f", ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[originalImage drawInRect:rect];
	childData.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
	Debug(@"AddChildViewController.save - thumbnail 저장.");
	UIGraphicsEndImageContext();
*/
	///////////////////////////////////////////////////////////////////
	
	
	Debug("Save 3333 - 2");
	diaryData.thumbnailImage = photoZone.image;
	Debug("Save 4444 : imageArray.count = %d", [imageArray count]);
	NSError *error = nil;
	if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	Debug("Save DiaryData");
	
	if (!editmode) {
		NSManagedObjectContext *context2 = childData.managedObjectContext;
	
		if (![context2 save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
		 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
		Debug("Save ChildData");
	}
	
	if (modifyMode) {
		newDateString = [diaryData valueForKey:@"sectionDate"];
		[delegate reloadTableView:newDateString];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) cancel {
//	NSString *newDateString = nil;
//	if (modifyMode) {
//		newDateString = [diaryData valueForKey:@"sectionDate"];
//		[delegate reloadTableView:newDateString];
//	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView 
{
	Debug(@"textViewDidBeginEditing");
    activeView = contentView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	Debug(@"textViewDidEndEditing");
    activeView = nil;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	Debug(@"textFieldDidBeginEditing");
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	Debug(@"textViewDidEndEditing");
    activeField = nil;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.testLabel = nil;
	self.photoZone  = nil;
	self.photoFrame  = nil;
	self.calendarViewController  = nil;
	//	[saveButton release];
	//	[closeViewButton release];
	self.cameralButton  = nil;
	self.titleField   = nil;
	self.contentView   = nil;
	self.scrollView   = nil;
	self.activeView   = nil;
	self.activeField   = nil;
	self.contentsView   = nil;
	//	[imageData release];
	self.activityIndicator   = nil;
	
	self.mapView   = nil;
	self.geoTaggedImage   = nil;
	self.locManager   = nil;
	
	self.imageArray   = nil;
	self.childData   = nil;
	self.diaryData   = nil;
	
	self.fetchedResultsController   = nil;
	self.managedObjectContext   = nil;
	self.imageViewButton   = nil;
	self.dateFormatter   = nil;
	
	self.photoSlideController   = nil;
	self.imageContext = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[testLabel release];
	[photoZone release];
	[photoFrame release];
	[calendarViewController release];
//	[saveButton release];
//	[closeViewButton release];
	[cameralButton release];
	[titleField release];
	[contentView release];
	[scrollView release];
	[activeView release];
	[activeField release];
	[contentsView release];
//	[imageData release];
	[activityIndicator release];
	
	[mapView release];
	[geoTaggedImage release];
	[locManager release];
	
	[imageArray release];
	[childData release];
	[diaryData release];
	
	[fetchedResultsController release];
	[managedObjectContext release];
	[imageViewButton release];
	[dateFormatter release];
	
	[photoSlideController release];
	[imageContext release];
	[delegate release];

	[super dealloc];
}


@end
