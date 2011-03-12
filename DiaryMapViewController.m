//
//  DiaryMapViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 22..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "DiaryMapViewController.h"
#import "EXFLogging.h"


@implementation DiaryMapViewController

@synthesize mapView;
@synthesize mapButton;
@synthesize satButton;
@synthesize hybButton;
@synthesize anno;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithLatitude:(double)lat andLongitude:(double)lon andAnnotation:annotation{
	if (self = [super initWithNibName:@"DiaryMapViewController" bundle:nil]) {
		Debug(@"Coordinate : lat = %f, lon = %f", lat, lon);
		shareLoc.latitude = lat;
		shareLoc.longitude = lon;
		anno = annotation;
	}
	
	return self;
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
	label.text = @"\n지도 보기";
	self.navigationItem.titleView = label;
	
	[mapView setShowsUserLocation:YES];
	[self mapViewUpdateLat:shareLoc.latitude andLon:shareLoc.longitude];
}

- (void)mapViewUpdateLat:(float)lat andLon:(float)lon {
	MKCoordinateRegion region;
	MKCoordinateSpan span;   // 보여줄 지도가 처리하는 넓이를 정의합니다.  문서 읽어 보시길..
	span.latitudeDelta=0.0005;  // 숫자가 작으면 좁은 영역, 즉 우리동네 자세히~보임
	span.longitudeDelta=0.0005;
	
	CLLocationCoordinate2D mapLoc = mapView.userLocation.coordinate;
	
	//그래도 블로깅하려고,  우리나라 위도,경도 찾아서 넣었습니다.
	mapLoc.latitude = lat;
	mapLoc.longitude = lon;
	
	region.span=span;   //위에서  정한 크기 설정하고
	region.center=shareLoc;  // 위치 설정하고
	
	[mapView setRegion:region    animated: TRUE];  // 지도 뷰에 지역을 설정하고
	[mapView regionThatFits:region];
	[mapView setCenterCoordinate:shareLoc animated: YES];
	[mapView addAnnotation:anno];
}

- (IBAction)changeToMap {
	[mapView setMapType:MKMapTypeStandard];
}

- (IBAction)changeToSatlite {
	[mapView setMapType:MKMapTypeSatellite];
}

- (IBAction)changeToHybrid {
	[mapView setMapType:MKMapTypeHybrid];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [super dealloc];
	[mapButton release];
	[satButton release];
	[hybButton release];
	[mapView release];
}


@end
