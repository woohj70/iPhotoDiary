//
//  DiaryPgotoSlideViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 23..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "DiaryPhotoSlideViewController.h"
#import "EXFLogging.h"


@implementation DiaryPhotoSlideViewController

@synthesize diaryData;
@synthesize imageSet;
@synthesize imageArray;
@synthesize scrollView1;
@synthesize mapView;
@synthesize mapViewButton;

@synthesize mapButton;
@synthesize satButton;
@synthesize hybButton;

@synthesize managedObjectContext;

const CGFloat kScrollObjHeight	= 411.0;
const CGFloat kScrollObjWidth	= 320.0;
//const NSUInteger kNumImages		= 8;

- (void)layoutScrollImages:(NSUInteger)kNumImages 
{
	UIImageView *view = nil;
	NSArray *subviews = [scrollView1 subviews];

	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
		
			curXLoc += (kScrollObjWidth);
		}
	}

	// set the content size so it can be scrollable
	[scrollView1 setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [scrollView1 bounds].size.height)];
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	isMapView = YES;
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
	label.text = @"\n사진 보기";
	self.navigationItem.titleView = label;
	
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	
	// 1. setup the scrollview for multiple images and add it to the view controller
	//
	// note: the following can be done in Interface Builder, but we show this in code for clarity
	[scrollView1 setBackgroundColor:[UIColor blackColor]];
	[scrollView1 setCanCancelContentTouches:NO];
	scrollView1.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView1.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView1.scrollEnabled = YES;
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	scrollView1.pagingEnabled = YES;
	
	// load all the images from our bundle and add them to the scroll view
	NSUInteger kNumImages		= 0;
	
	if ([imageArray count] > 0) {
		kNumImages = [imageArray count];
//		tempImageArray = [[NSArray alloc] initWithArray:imageArray];
	} else {
		if (diaryData != nil) {
			imageSet = diaryData.image;
			Debug(@"[imageSet count] = %d", [imageSet count]);
			if ([imageSet count] > 0) {
				kNumImages = [imageSet count];
				imageArray = [[NSArray alloc] initWithArray:[imageSet allObjects]];
				
//				for (NSUInteger i = 1; i <= kNumImages; i++) {
//					NSManagedObjectContext *imageContext = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryImage" inManagedObjectContext:managedObjectContext];
//					[tempImageArray addObject:[imageContext valueForKey:@"image"]];
//				}
			}
		}
	}

	
	for (NSUInteger i = 1; i <= kNumImages; i++)
	{
		UIImage *image = [[imageArray objectAtIndex:i-1] valueForKey:@"image"];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.backgroundColor = [UIColor blackColor];
		
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
		rect.size.height = image.size.height;
		rect.size.width = image.size.width;
		imageView.frame = rect;
		scrollView1.frame = CGRectMake(0, 0, 320, 460);
		imageView.tag = i;	// tag our images for later use when we place them in serial fashion
		[scrollView1 addSubview:imageView];
		[imageView release];
	}
//	[tempImageArray release];
	[self layoutScrollImages:kNumImages];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)mapViewButtonClicked {
	
	NSArray *subviews = scrollView1.subviews;
	UIImageView *view = nil;
	CGFloat curXLoc = 0;
	NSInteger i = 0;
	NSInteger imageCount = [imageArray count];
	for (view in subviews)
	{
		Debug(@"scrollView1.contentOffset : x = %f, y = %f", scrollView1.contentOffset.x, scrollView1.contentOffset.y);
		Debug(@"curXLoc = %f", curXLoc);
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0) {
			if (scrollView1.contentOffset.x == curXLoc) {		
				if (isMapView) {
					view.frame = CGRectMake(curXLoc, 0, 135, 135);
					scrollView1.frame = CGRectMake(0, 0, 135, 135);
					scrollView1.backgroundColor = [UIColor clearColor];
					scrollView1.scrollEnabled = NO;

					[mapView resignFirstResponder];
					[self mapViewUpdateLat:[[imageArray objectAtIndex:i] valueForKey:@"latitude"] andLon:[[imageArray objectAtIndex:i] valueForKey:@"longitude"]];
				} else {
					UIImage *image = [[imageArray objectAtIndex:0] valueForKey:@"image"];
					scrollView1.frame = CGRectMake(0, 0, 320, 460);
					view.frame = CGRectMake(curXLoc, 0, image.size.width, image.size.height);
					scrollView1.backgroundColor = [UIColor blackColor];
					scrollView1.scrollEnabled = YES;
//					[image release];
				}
				break;
			} 
			i++;
		}
		
		curXLoc += (kScrollObjWidth);
	}
	
	if (isMapView) {
		[mapView setMapType:MKMapTypeStandard];
		mapButton.hidden = NO;
		satButton.hidden = NO;
		hybButton.hidden = NO;
		[mapViewButton setTitle:@"사진보기" forState:UIControlStateNormal];
	} else {
		mapButton.hidden = YES;
		satButton.hidden = YES;
		hybButton.hidden = YES;
		[mapViewButton setTitle:@"지도보기" forState:UIControlStateNormal];
	}
	
	isMapView = !isMapView;
}

- (void)mapViewUpdateLat:(NSString *)lat andLon:(NSString *)lon {
	Debug(@"mapViewUpdateLat start : lat = %@, lon = %@", lat, lon);
	MKCoordinateRegion region;
	MKCoordinateSpan span;   // 보여줄 지도가 처리하는 넓이를 정의합니다.  문서 읽어 보시길..
	span.latitudeDelta=0.0005;  // 숫자가 작으면 좁은 영역, 즉 우리동네 자세히~보임
	span.longitudeDelta=0.0005;
	
	CLLocationCoordinate2D mapLoc = mapView.userLocation.coordinate;
//	shareLoc = mapView.userLocation.coordinate;
	//그래도 블로깅하려고,  우리나라 위도,경도 찾아서 넣었습니다.
	
	Debug(@"mapViewUpdateLat start : lat = %f, lon = %f", [lat floatValue], [lon floatValue]);
	
	if ([lat floatValue] == 0 || [lat floatValue] == -180.00000000) {
		mapLoc.latitude = 37.566508;
	} else {
		mapLoc.latitude = [lat floatValue];
	}
	
	if ([lon floatValue] == 0 || [lon floatValue] == -180.00000000) {
		mapLoc.longitude = 126.97807;
	} else {
		mapLoc.longitude = [lon floatValue];
	}
	
	
	
	region.span=span;   //위에서  정한 크기 설정하고
	region.center=mapLoc;  // 위치 설정하고
	
	[mapView setRegion:region    animated: TRUE];  // 지도 뷰에 지역을 설정하고
	[mapView regionThatFits:region];
	
	if (annotation != nil) {
		[mapView removeAnnotation:annotation];
	}
//	if (diaryData != nil) {
		annotation = [DiaryMapAnnotation initWithCoordinate:mapLoc andTitle:[diaryData valueForKey:@"tag"]];
		annotation.title = [diaryData valueForKey:@"tag"];
		annotation.subtitle = [diaryData valueForKey:@"conditionDate"];
		[mapView addAnnotation:annotation];
		
		[annotation release];
//	} else {
		//		annotation = [DiaryMapAnnotation initWithCoordinate:mapLoc andTitle:self.titleField.text];
//	}
	
	
//	isLocation = NO;
	Debug(@"mapViewUpdateLat end");
}

#pragma mark -
#pragma mark Change Map type

- (IBAction)changeToMap {
	[mapView setMapType:MKMapTypeStandard];
}

- (IBAction)changeToSatlite {
	[mapView setMapType:MKMapTypeSatellite];
}

- (IBAction)changeToHybrid {
	[mapView setMapType:MKMapTypeHybrid];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	Debug("DiaryPhotoSlideViewController : dealloc");
	[diaryData release];
	[imageSet release];
	[scrollView1 release];
	[tempImageArray release];
	[imageArray release];
	[managedObjectContext release];
	[mapView release];
	[mapViewButton release];
	
	[mapButton release];
	[satButton release];
	[hybButton release];
	 
    [super dealloc];
}


@end
