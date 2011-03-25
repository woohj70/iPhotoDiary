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

@synthesize photoZone, thumbnailView;
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

@synthesize locManager, geoTaggedImage;

@synthesize fetchedResultsController, managedObjectContext, childData, diaryData, imageArray;
@synthesize dateFormatter;
@synthesize doneButton;
@synthesize activeView;
@synthesize activeField;
@synthesize photoSlideController;

@synthesize imageContext, imageContextArray;
@synthesize delegate;

@synthesize wIconName;
@synthesize locField;
@synthesize reverseAddr, country, administrativeArea, subAdministrativeArea, locality, subLocality, thoroughfare, subThoroughfare, postalCode;
@synthesize weatherIcon, tempHL, currTemp, city, lowTemp, highTemp, refreshWeather, currCondition, weatherDesc, dateTime;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
//		self.title = @"일기 쓰기";
		enCityNameDic = [[NSDictionary alloc] initWithObjectsAndKeys://강원도
						 @"Gangneung Si",	@"강릉시",
						 @"Goseong-gun",	@"고성군",
						 @"Donghae Si",	@"동해시",
						 @"Samcheok Si",	@"삼척시",
						 @"Sokcho Si",	@"속초시",
						 @"Yanggu-gun",	@"양구군",
						 @"Yangyang-gun",		@"양양군",
						 @"Yeongwol-gun",	@"영월군",
						 @"Wonju Si",	@"원주시",
						 @"Inje-gun",	@"인제군",
						 @"Jeongseon-gun",	@"정선군",
						 @"Cheorwon-gun",	@"철원군",
						 @"Chuncheon Si",	@"춘천시",
						 @"Taebaek Si",	@"태백시",
						 @"Pyeongchang-gun",	@"평창군",
						 @"Hongcheon-gun",	@"홍천군",
						 @"Hwacheon-gun",	@"화천군",
						 @"Hoengseong-gun",	@"횡성군",
						 
						 //경기도
						 @"Gapyeong-gun",	@"가평군",
						 @"Goyang Si",	@"고양시",
						 @"Gwacheon Si",	@"과천시",
						 @"Gwangmyeong Si",	@"광명시",
						 @"Gwangju Si",	@"광주시",
						 @"Guri Si",		@"구리시",
						 @"Gunpo Si",	@"군포시",
						 @"Gimpo Si",	@"김포시",
						 @"Namyangju Si",	@"남양주시",
						 @"Dongducheon Si",	@"동두천시",
						 @"Bucheon Si",	@"부천시",
						 @"Seongnam Si",	@"성남시",
						 @"Suwon Si",	@"수원시",
						 @"Siheung Si",	@"시흥시",
						 @"Ansan Si",	@"안산시",
						 @"Anseong Si",	@"안성시",
						 @"Anyang Si",	@"안양시",
						 @"Yangju Si",	@"양주시",
						 @"Yangpyeong-gun",	@"양평군",
						 @"Yeoju-gun",	@"여주군",
						 @"Yeoncheon-gun",	@"연천군",
						 @"Osan Si",	@"오산시",
						 @"Yongin Si",	@"용인시",
						 @"Uiwang Si",	@"의왕시",
						 @"Uijeongbu Si",	@"의정부시",
						 @"Icheon Si",	@"이천시",
						 @"Paju Si",		@"파주시",
						 @"Pyeongtaek Si",	@"평택시",
						 @"Pocheon Si",	@"포천시",
						 @"Hanam Si",	@"하남시",
						 @"Hwaseong Si",	@"화성시",
						 
						 //경남
						 @"Geoje Si",	@"거제시",
						 @"Geochang-gun",	@"거창군",
						 @"Goseong-gun",	@"고성군",
						 @"Gimhae Si",	@"김해시",
						 @"Namhae-gun",	@"남해군",
						 @"Miryang Si",	@"밀양시",
						 @"Sacheon Si",	@"사천시",
						 @"Sancheong-gun",	@"산청군",
						 @"Yangsan Si",	@"양산시",
						 @"Uiryeong-gun",	@"의령군",
						 @"Jinju Si",	@"진주시",
						 @"Changnyeong-gun",	@"창녕군",
						 @"Changwon Si",	@"창원시",
						 @"Tongyeong Si",	@"통영시",
						 @"Hadong-gun",	@"하동군",
						 @"Haman-gun",	@"함안군",
						 @"Hamyang-gun",	@"함양군",
						 @"Hapcheon-gun", @"합천군",
						 
						 //경북
						 @"Gyeongsan Si",	@"경산시",
						 @"Gyeongju Si",	@"경주시",
						 @"Goryeong-gun",	@"고령군",
						 @"Gumi Si",	@"구미시",
						 @"Gunwi-gun",	@"군위군",
						 @"Kimcheon Si",	@"김천시",
						 @"Mungyeong Si",	@"문경시",
						 @"Bonghwa-gun",	@"봉화군",
						 @"Sangju Si",	@"상주시",
						 @"Seongju-gun",	@"성주군",
						 @"Andong Si",	@"안동시",
						 @"Yeongdeok-gun",	@"영덕군",
						 @"Yeongyang-gun",	@"영양군",
						 @"Yeongju Si",	@"영주시",
						 @"Yeongcheon Si",	@"영천시",
						 @"Yecheon-gun",	@"예천군",
						 @"Ulleung-gun",	@"울릉군",
						 @"Uljin-gun",	@"울진군",
						 @"Uiseong-gun",	@"의성군",
						 @"Cheongdo-gun",	@"청도군",
						 @"Cheongsong-gun",	@"청송군",
						 @"Chilgok-gun",	@"칠곡군",
						 @"Pohang Si",	@"포항시",
						 
						 @"Gwangju",	@"광주광역시",
						 @"Daegu",		@"대구광역시",
						 @"Daejeon",	@"대전광역시",
						 @"Busan",		@"부산광역시",
						 @"Seoul",		@"서울특별시",
						 @"Ulsan",		@"울산광역시",
						 @"Incheon",	@"인천광역시",
						 
                         // 전남
						 @"Gangjin-gun",	@"강진군",
						 @"Goheung-gun",	@"고흥군",
						 @"Gokseong-gun",	@"곡성군",
						 @"Gwangyang Si",	@"광양시",
						 @"Gurye-gun",	@"구례군",
						 @"Naju Si",	@"나주시",
						 @"Damyang-gun",	@"담양군",
						 @"Mokpo Si",	@"목포시",
						 @"Muan-gun",	@"무안군",
						 @"Boseong-gun",	@"보성군",
						 @"Suncheon Si",	@"순천시",
						 @"Sinan-gun",	@"신안군",
						 @"Yeosu Si",	@"여수시",
						 @"Yeonggwang-gun",	@"영광군",
						 @"Yeongam-gun",	@"영암군",
						 @"Wando-gun",	@"완도군",
						 @"Jangseong-gun",	@"장성군",
						 @"Jangheung-gun",	@"장흥군",
						 @"Jindo-gun",	@"진도군",
						 @"Hampyeong-gun",	@"함평군",
						 @"Haenam-gun",	@"해남군",
						 @"Hwasun-gun",	@"화순군",
						 
						 //전북
						 @"Gochang-gun",	@"고창군",
						 @"Gunsan Si",	@"군산시",
						 @"Gimje Si",	@"김제시",
						 @"Namwon Si",	@"남원시",
						 @"Muju-gun",	@"무주군",
						 @"Buan-gun",	@"부안군",
						 @"Sunchang-gun",	@"순창군",
						 @"Wanju-gun",	@"완주군",
						 @"Iksan Si",	@"익산시",
						 @"Imsil-gun",	@"임실군",
						 @"Jangsu-gun",	@"장수군",
						 @"Jeonju Si",	@"전주시",
						 @"Jeongeup Si",	@"정읍시",
						 @"Jinan-gun",	@"진안군",
						 
						 //제주
						 @"Seogwipo Si",	@"서귀포시",
						 @"Jeju Si",	@"제주시",
						 
						 //충남
						 @"Gyeryong Si",	@"계룡시",
						 @"Gongju Si",	@"공주시",
						 @"Geumsan-gun",	@"금산군",
						 @"Nonsan Si",	@"논산시",
						 @"Dangjin-gun",	@"당진군",
						 @"Boryeong Si",	@"보령시",
						 @"Buyeo-gun",	@"부여군",
						 @"Seosan Si",	@"서산시",
						 @"Seocheon-gun",	@"서천군",
						 @"Asan Si",	@"아산시",
						 @"Yeongi-gun",	@"연기군",
						 @"Yesan-gun",	@"예산군",
						 @"Cheonan Si",	@"천안시",
						 @"Cheongyang-gun",	@"청양군",
						 @"Taean-gun",	@"태안군",
						 @"Hongseong-gun",	@"홍성군",
						 
						 //충북
						 @"Goesan-gun", @"괴산군",
						 @"Danyang-gun",	@"단양군",
						 @"Boeun-gun",	@"보은군",
						 @"Yeongdong-gun",	@"영동군",
						 @"Okcheon-gun",	@"옥천군",
						 @"Eumseong-gun",	@"음성군",
						 @"Jecheon Si",	@"제천시",
						 @"Jeungpyeong-gun",	@"증평군",
						 @"Jincheon-gun",	@"진천군",
						 @"Cheongwon-gun",	@"청원군",
						 @"Cheongju Si",	@"청주시",
						 @"Chungju Si",	@"충주시", nil];
		
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
    
    repeatCnt = 0;
	currCondCnt = 0;
	iconRepeatCnt = 0;
    
    isFirstWeatherGet = NO;
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI / 180 * -8);
	self.thumbnailView.transform = trans;
    
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
//	[activityIndicator startAnimating];
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
	
	self.imageArray = [[NSMutableArray alloc] initWithCapacity:8];
    self.imageContextArray = [[NSMutableArray alloc] init];
	
	if (diaryData != nil) {
		[self setDiaryDataFields];
	} else {
        [activityIndicator startAnimating];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy년 MM월 dd일 EEEE"];
        self.dateTime.text = [formatter stringFromDate:[NSDate date]];
        [formatter release];
		[self fetchRequestResult:[AppMainViewController selectedChildName]];
	}
	
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
//		imageViewButton.frame = CGRectMake(9, 203, 135, 26);
	} else if ([self.imageArray count] > 0 || isSetCoord) {
		imageViewButton.hidden = NO;
		cameralButton.hidden = NO;
//		cameralButton.frame = CGRectMake(9, 203, 63, 26);
	} else {
		imageViewButton.hidden = NO;
		cameralButton.hidden = NO;
//		cameralButton.frame = CGRectMake(9, 203, 135, 26);
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
    self.thumbnailView.image = diaryData.thumbnailImage;
    self.contentView.text = [NSString stringWithFormat:@"%@", diaryData.content];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy년 MM월 dd일 EEEE"];
    self.dateTime.text = [formatter stringFromDate:diaryData.writedate];
    [formatter release];
    
    self.weatherDesc.text =  diaryData.weatherDesc;
    self.weatherIcon.image = [UIImage imageNamed:diaryData.weatherIcon];
    self.locField.text = diaryData.reverseAddr;
//	self.photoZone.image = diaryData.thumbnailImage;
/*	
    CGSize contentSize = [diaryData.content sizeWithFont:self.contentView.font constrainedToSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height) lineBreakMode:YES];
    Debug(@"content height = %f", contentSize.height);
    self.contentView.text = [NSString stringWithFormat:@"%@\n%f", diaryData.content, contentSize.height];
  
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, contentSize.height + 10.0f, 150.0f, 150.0f)];
    imageView.image = diaryData.thumbnailImage;
    [self.contentView addSubview:imageView];
    [imageView release];
*/
 
//    [self.contentView setContentOffset:CGPointMake(0.0f, contentSize.height + 10.0f + 150.f) animated:YES];
    
//	NSManagedObjectContext *imageContext = [diaryData.image anyObject];
	latitude = [[diaryData valueForKey:@"latitude"] doubleValue];
	longitude = [[diaryData valueForKey:@"longitude"] doubleValue];
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
		self.thumbnailView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
		geoTaggedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	} else {
		self.thumbnailView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		geoTaggedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	}
	
	[self.imageArray addObject:(UIImage *)geoTaggedImage];

	//Image 관련 데이터 저장 /////////////////////////////////////////////
	imageContext = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryImage" inManagedObjectContext:managedObjectContext];
	
	// Set the image for the image managed object.
	[imageContext setValue:geoTaggedImage forKey:@"image"];
    [imageContext setValue:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
    [imageContext setValue:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
    
	[self.imageContextArray addObject:imageContext];
    
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
//		[cameralButton setTitle:@"사진" forState:UIControlStateNormal];
	} else {
		Debug(@"findLocation : isLocation NO==============================================");
		wasFound = NO;
		
//		[activityIndicator startAnimating];
//		[cameralButton setTitle:@"위치 정보 검색 중..." forState:UIControlStateNormal];
		[locManager startUpdatingLocation];
	}
	
	isLocation = !isLocation;
}

#pragma mark -
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	Debug(@"didFailWithError");
	[geocoder cancel];
	[geocoder autorelease];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	Debug(@"didFindPlacemark");
	NSString *str = @"";
    NSString *str2 = @"";
	
	self.administrativeArea = @"";
	self.subAdministrativeArea = @"";
	self.locality = @"";
	self.subLocality = @"";
	self.thoroughfare = @"";
	self.subThoroughfare = @"";
    //	str = [str stringByAppendingFormat:@"%@", placemark.country];
    //	country = placemark.country;
	
	if([placemark.administrativeArea length] > 0)
	{
//		str = [str stringByAppendingFormat:@" "];
		str = [str stringByAppendingFormat:@"%@", placemark.administrativeArea];
        str2 = [str2 stringByAppendingFormat:@" "];
		str2 = [str2 stringByAppendingFormat:@"%@", placemark.administrativeArea];
		self.administrativeArea = placemark.administrativeArea;
	}
	
	if([placemark.subAdministrativeArea length] > 0)
	{
		str = [str stringByAppendingFormat:@" "];
		str = [str stringByAppendingFormat:@"%@", placemark.subAdministrativeArea];
        str2 = [str2 stringByAppendingFormat:@" "];
		str2 = [str2 stringByAppendingFormat:@"%@", placemark.subAdministrativeArea];
		self.subAdministrativeArea = placemark.subAdministrativeArea;
	}
	
	if([placemark.locality length] > 0)
	{
		str = [str stringByAppendingFormat:@" "];
		str = [str stringByAppendingFormat:@"%@", placemark.locality];
        str2 = [str2 stringByAppendingFormat:@" "];
		str2 = [str2 stringByAppendingFormat:@"%@", placemark.locality];
		self.locality = placemark.locality;
	}
	
	if([placemark.subLocality length] > 0)
	{
		str = [str stringByAppendingFormat:@" "];
		str = [str stringByAppendingFormat:@"%@", placemark.subLocality];
        str2 = [str2 stringByAppendingFormat:@" "];
		str2 = [str2 stringByAppendingFormat:@"%@", placemark.subLocality];
		self.subLocality = placemark.subLocality;
	}
	
	if([placemark.thoroughfare length] > 0)
	{
		str = [str stringByAppendingFormat:@" "];
		str = [str stringByAppendingFormat:@"%@", placemark.thoroughfare];
        str2 = [str2 stringByAppendingFormat:@" "];
		str2 = [str2 stringByAppendingFormat:@"%@", placemark.thoroughfare];
		self.thoroughfare = placemark.thoroughfare;
	}
	
	if([placemark.subThoroughfare length] > 0)
	{
		str = [str stringByAppendingFormat:@" "];
		str = [str stringByAppendingFormat:@"%@", placemark.subThoroughfare];
		self.subThoroughfare = placemark.subThoroughfare;
	}
	
	self.reverseAddr = str;    // 최종 주소
    //	if (str != nil && !isFindLocation && !isProccessFileSave) {
    //		[self insertGPSData];
    //	}
	
	if (str != nil && ![str isEqualToString:@""]) {
		self.locField.text = str2;
		
        //		if (!isGetWeatherEnd) {
        if ([[[NSLocale currentLocale] identifier] isEqualToString:@"ko_KR"]) {
            //				if ([self.locality isEqualToString:@"서울특별시"] ||
            //					[self.locality isEqualToString:@"부산광역시"] ||
            //					[self.locality isEqualToString:@"인천광역시"] ||
            //					[self.locality isEqualToString:@"대구광역시"] ||
            //					[self.locality isEqualToString:@"광주광역시"] ||
            //					[self.locality isEqualToString:@"대전광역시"] ||
            //					[self.locality isEqualToString:@"울산광역시"]) {
            //					postalCode = [enCityNameDic objectForKey:self.locality];
            //				} else {
            NSString *tempLocal = [enCityNameDic objectForKey:self.locality];
            
            Debug(@"postalCode = %@ : tempLocal = %@", self.postalCode, tempLocal);
            
            if (![tempLocal isEqualToString:self.postalCode]) {
                self.postalCode = tempLocal;
                [self refreshWeatherClicked];
            } else {
                self.postalCode = tempLocal;
            }
            
            //				}
        } else {
            NSString *tempLocal = [NSString stringWithFormat:@"%@,%@",self.locality, self.administrativeArea?self.administrativeArea:@""];
            
            if (![tempLocal isEqualToString:self.postalCode]) {
                self.postalCode = tempLocal;
                [self refreshWeatherClicked];
            } else {
                self.postalCode = tempLocal;
            }
            
            self.postalCode = tempLocal;
        }
        
        Debug(@"postalCode = %@", self.postalCode);
        
        if (!isFirstWeatherGet) {
            Debug(@"First Weather Check Start!!!");
            [self getWOEID];
            isFirstWeatherGet = YES;
        }
        //		}
		self.locField.text = str2;//self.reverseAddr;
		[geocoder release];
	}
    
	Debug(@"reversAddr = %@", reverseAddr);
}

#pragma mark -
#pragma mark Get weather info from google

- (void) getWOEID {
	Debug(@"getWOEID");
	Debug(@"getWOEID postalCode = http://www.google.co.kr/ig/api?weather=%@", self.postalCode);
	NSString* weatherURLString = nil;
	if ([[[NSLocale currentLocale] identifier] isEqualToString:@"ko_KR"]) {
		weatherURLString = [NSString stringWithFormat:@"http://www.google.co.kr/ig/api?weather=%@", self.postalCode];
	} else {
		weatherURLString = [NSString stringWithFormat:@"http://www.google.com/ig/api?weather=%@", self.postalCode];
	}
    
    weatherURLString = [weatherURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSURL *weatherURL = [NSURL URLWithString:weatherURLString];
	NSError *error = nil;
	NSString *tempForWeather = [NSString stringWithContentsOfURL:weatherURL encoding:-2147481280 error:&error];
	Debug(@"tempForWeather = %@", tempForWeather);
	[self loadUnknownXML:tempForWeather];
	/*
	 http://www.google.co.kr/ig/api?weather=	 
     NSString* woeidURLString = [NSString stringWithFormat:@"http://www.geomojo.org/cgi-bin/reversegeocoder.cgi?long=%f&lat=%f", longitude, latitude];
     NSURL *woeidURL = [NSURL URLWithString:woeidURLString];
     NSString *tempForwoeid = [NSString stringWithContentsOfURL:woeidURL];
     Debug(@"tempForwoeid = %@", tempForwoeid);
     TBXML* woeidXML = [[TBXML alloc] initWithXMLString:tempForwoeid];
     TBXMLElement *woeid = [TBXML childElementNamed:@"woeid" parentElement:woeidXML.rootXMLElement];
     NSString *woeidStr = [TBXML textForElement:woeid];
     Debug(@"woeidStr = %@", woeidStr);
     [woeidXML release];
     
     NSString* weatherURLString = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",woeidStr];
     NSURL *weatherURL = [NSURL URLWithString:weatherURLString];
     NSString *tempForWeather = [NSString stringWithContentsOfURL:weatherURL];
     Debug(@"tempForWeather = %@", tempForWeather);
     
     [self loadUnknownXML:tempForWeather];
     */
	
	
    //	TBXMLElement *condition = [TBXML childElementNamed:@"yweather" parentElement:woeidXML.rootXMLElement];
    //	[self traverseElement:condition];
    //	woeidXML = [[TBXML alloc] initWithXMLString:tempForWeather];
    //	TBXMLElement *condition = [TBXML childElementNamed:@"yweather:condition" parentElement:woeidXML.rootXMLElement];
    //	NSString *attrVal = [TBXML valueOfAttributeNamed:@"text" forElement:condition];
    //	Debug(@"attrVal = %@", attrVal);
	isGetWeatherEnd = YES;
	repeatCnt = 0;
	iconRepeatCnt = 0;
	currCondCnt = 0;
}

- (void)loadUnknownXML:(NSString *)xmlString {
	// Load and parse the books.xml file
	lowTemp = @"";
	highTemp = @"";
	
	TBXML *tbxml = [[TBXML tbxmlWithXMLString:xmlString] retain];
	
	// If TBXML found a root node, process element and iterate all children
	if (tbxml.rootXMLElement) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
		[self traverseElement:tbxml.rootXMLElement];
//		[self saveWeatherInfo];
	}
	
	// release resources
	[tbxml release];
    //	[locManager stopUpdatingLocation];
}

- (void) traverseElement:(TBXMLElement *)element {
    //	ShootingMyDayAppDelegate *appDelegate = (ShootingMyDayAppDelegate *)[[UIApplication sharedApplication] delegate];
	do {
		// Display the name of the element
        //		NSLog(@"%@",[TBXML elementName:element]);
		
		if ([[[NSLocale currentLocale] identifier] isEqualToString:@"ko_KR"]) {
			if ([[TBXML elementName:element] isEqualToString:@"temp_c"]) {
				Debug(@"temp_c");
				// Obtain first attribute from element
				TBXMLAttribute * attribute = element->firstAttribute;
				
				// if attribute is valid
				while (attribute) {
					// Display name and value of attribute to the log window
					//				NSLog(@"%@->%@ = %@",
					//					  [TBXML elementName:element],
					//					  [TBXML attributeName:attribute],
					// 					  [TBXML attributeValue:attribute]);
					
					if ([[TBXML attributeName:attribute] isEqualToString:@"data"]) {
						//℉
						int tempc = [[TBXML attributeValue:attribute] integerValue];
												
						self.currTemp = [NSString stringWithFormat:@"%d℃", tempc];
                        //						appDelegate.currentTemp = [NSString stringWithFormat:@"%@℃", [TBXML attributeValue:attribute]];
					}
					// Obtain the next attribute
					attribute = attribute->next;
				}
				
			}
		} else {
			if ([[TBXML elementName:element] isEqualToString:@"temp_f"]) {
				Debug(@"temp_c");
				// Obtain first attribute from element
				TBXMLAttribute * attribute = element->firstAttribute;
				
				// if attribute is valid
				while (attribute) {
					// Display name and value of attribute to the log window
					//				NSLog(@"%@->%@ = %@",
					//					  [TBXML elementName:element],
					//					  [TBXML attributeName:attribute],
					// 					  [TBXML attributeValue:attribute]);
					
					if ([[TBXML attributeName:attribute] isEqualToString:@"data"]) {
						
						int tempc = round(([[TBXML attributeValue:attribute] integerValue] - 32) / 1.8);
						
						
						
						//℉
						self.currTemp = [NSString stringWithFormat:@"%@℉", [TBXML attributeValue:attribute]];
                        //						appDelegate.currentTemp = [NSString stringWithFormat:@"%@℉", [TBXML attributeValue:attribute]];
					}
					// Obtain the next attribute
					attribute = attribute->next;
				}
				
			}
		}
        
		if ([[TBXML elementName:element] isEqualToString:@"condition"]) {
			Debug(@"city");
			// Obtain first attribute from element
			TBXMLAttribute * attribute = element->firstAttribute;
			
			// if attribute is valid
			while (attribute) {
				// Display name and value of attribute to the log window
				//				NSLog(@"%@->%@ = %@",
				//					  [TBXML elementName:element],
				//					  [TBXML attributeName:attribute],
				//					  [TBXML attributeValue:attribute]);
				
				if ([[TBXML attributeName:attribute] isEqualToString:@"data"] && currCondCnt == 0) {
					//℉
					if ([TBXML attributeValue:attribute] != nil && ![[TBXML attributeValue:attribute] isEqualToString:@""]) {
						self.currCondition = [TBXML attributeValue:attribute];
						//					appDelegate.weatherDesc = [TBXML attributeValue:attribute];
						currCondCnt++;
					}
					
				}
				// Obtain the next attribute
				attribute = attribute->next;
			}
			
		} else if ([[TBXML elementName:element] isEqualToString:@"city"]) {
			Debug(@"city");
			// Obtain first attribute from element
			TBXMLAttribute * attribute = element->firstAttribute;
			
			// if attribute is valid
			while (attribute) {
				// Display name and value of attribute to the log window
                //				NSLog(@"%@->%@ = %@",
                //					  [TBXML elementName:element],
                //					  [TBXML attributeName:attribute],
                //					  [TBXML attributeValue:attribute]);
				
				if ([[TBXML attributeName:attribute] isEqualToString:@"data"]) {
					//℉
                    Debug(@"self.locality = %@", self.locality);
					self.city = self.locality;//[TBXML attributeValue:attribute];
				}
				// Obtain the next attribute
				attribute = attribute->next;
			}
			
		} else if ([[TBXML elementName:element] isEqualToString:@"low"] && repeatCnt < 2) {
			Debug(@"low");
			// Obtain first attribute from element
			TBXMLAttribute * attribute = element->firstAttribute;
			
			// if attribute is valid
			while (attribute) {
				// Display name and value of attribute to the log window
                //				NSLog(@"%@->%@ = %@",
                //					  [TBXML elementName:element],
                //					  [TBXML attributeName:attribute],
                //					  [TBXML attributeValue:attribute]);
				
				if ([[TBXML attributeName:attribute] isEqualToString:@"data"]) {
					//℉
                    //				if ([[[NSLocale currentLocale] identifier] isEqualToString:@"ko_KR"]) {
                    //					NSInteger f = [[TBXML attributeValue:attribute] integerValue];
                    //					NSInteger c = round((f - 32) / 1.8);
                    //					lowTemp = [NSString stringWithFormat:@"%d", c];
                    //				} else {
                    lowTemp = [TBXML attributeValue:attribute];
                    //				}
                    
					
					repeatCnt++;
                    //					Debug(@"lowTemp = %@ : repeatCnt = %d", lowTemp, repeatCnt);
				}
				// Obtain the next attribute
				attribute = attribute->next;
			}
			
		} else if ([[TBXML elementName:element] isEqualToString:@"high"] && repeatCnt < 2) {
			Debug(@"high");
			// Obtain first attribute from element
			TBXMLAttribute * attribute = element->firstAttribute;
			
			// if attribute is valid
			while (attribute) {
				// Display name and value of attribute to the log window
                //				NSLog(@"%@->%@ = %@",
                //					  [TBXML elementName:element],
                //					  [TBXML attributeName:attribute],
                //					  [TBXML attributeValue:attribute]);
				
				if ([[TBXML attributeName:attribute] isEqualToString:@"data"]) {
					//℉
                    //				if ([[[NSLocale currentLocale] identifier] isEqualToString:@"ko_KR"]) {
                    //					NSInteger f = [[TBXML attributeValue:attribute] integerValue];
                    //					NSInteger c = round((f - 32) / 1.8);
                    //					highTemp = [NSString stringWithFormat:@"%d", c];
                    //				} else {
                    highTemp = [TBXML attributeValue:attribute];
                    //				}
					
					repeatCnt++;
                    //					Debug(@"highTemp = %@ : repeatCnt = %d", highTemp, repeatCnt);
				}
				// Obtain the next attribute
				attribute = attribute->next;
			}
			
		} else if ([[TBXML elementName:element] isEqualToString:@"icon"] && iconRepeatCnt == 0) {
			Debug(@"icon");
			// Obtain first attribute from element
			TBXMLAttribute * attribute = element->firstAttribute;
			Debug(@"icon2");			// if attribute is valid
			while (attribute) {
				// Display name and value of attribute to the log window
				//				NSLog(@"%@->%@ = %@",
				//					  [TBXML elementName:element],
				//					  [TBXML attributeName:attribute],
				//					  [TBXML attributeValue:attribute]);
				Debug(@"icon3");
				if ([[TBXML attributeName:attribute] isEqualToString:@"data"]) {
					Debug(@"icon4");
					NSString* iconURLString = [TBXML attributeValue:attribute]; //[NSString stringWithFormat:@"http://www.google.com%@", [TBXML attributeValue:attribute]];
					
					Debug(@"iconURLString = %@", iconURLString);
					if (iconURLString != nil && ![iconURLString isEqualToString:@""]) {
						NSRange fStart = [iconURLString rangeOfString:@"/" options:NSBackwardsSearch];
						NSString* iconName = [iconURLString substringFromIndex:fStart.location + 1];
						NSRange fEnd = [iconName rangeOfString:@"." options:NSBackwardsSearch];
						//					Debug(@"iconName = %@", iconName);
						//					Debug(@"only nam = %@", [iconName substringToIndex:fEnd.location]);
						self.weatherIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [iconName substringToIndex:fEnd.location]]];
						//					NSString* img4 = [NSString stringWithFormat:@"<html><head></head><body style=\"margin:0\"><image src='%@' width=40 height=40 margin=0 padding=0></body></html>",iconURLString];
						//					[weatherIcon setScalesPageToFit:NO];
						//					weatherIcon.contentMode = UIViewContentModeScaleToFill;
						//					[weatherIcon loadHTMLString:img4 baseURL:nil];
						self.wIconName = [NSString stringWithFormat:@"%@.png", [iconName substringToIndex:fEnd.location]];
						
						iconRepeatCnt++;
					}
					
				}
                
				// Obtain the next attribute
				attribute = attribute->next;
			}
			
		}
        
		// if the element has child elements, process them
		if (element->firstChild) 
            [self traverseElement:element->firstChild];
		
		// Obtain next sibling element
	} while ((element = element->nextSibling));  
	Debug(@"set HL start");
	Debug(@"lowTemp = %@ : highTemp = %@", lowTemp, highTemp);
	
	if ([[[NSLocale currentLocale] identifier] isEqualToString:@"ko_KR"]) {
		self.tempHL = [NSString stringWithFormat:@"L:%@℃  H:%@℃", lowTemp, highTemp];
	} else {
		self.tempHL = [NSString stringWithFormat:@"L:%@℉  H:%@℉", lowTemp, highTemp];
	}
    
    if (!modifyMode) {
        self.weatherDesc.text = [NSString stringWithFormat:@"%@  %@", self.currCondition, self.currTemp];
    }
    
	Debug(@"set HL end");
}

/*
- (void) saveWeatherInfo {
	Debug(@"Save WeatherInfo");
	WeatherData *wData = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherData" inManagedObjectContext:self.managedObjectContext];
	
	NSDate *now = [NSDate date];
	
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy. MM. dd."];
	NSString *conditionDate = [formatter stringFromDate:now];
    
    [formatter setDateFormat:@"yyyy. MM."];
	NSString *sectionDate = [formatter stringFromDate:now];
	
    [formatter release];
	
	[wData setValue:now forKey:@"weatherDate"];
	[wData setValue:sectionDate forKey:@"sectionDate"];
	[wData setValue:conditionDate forKey:@"conditionDate"];
	[wData setValue:self.city.text forKey:@"area"];
	[wData setValue:self.currTemp.text forKey:@"currentTemparature"];
	[wData setValue:self.tempHL.text forKey:@"lhTemparature"];
	[wData setValue:wIconName forKey:@"iconURL"];
	[wData setValue:self.currCondition.text forKey:@"weatherDescription"];
	
	NSError	*error = nil;
	if (![self.managedObjectContext save:&error]) {

        //		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}
*/

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
				
//				[imageContext setValue:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
//				[imageContext setValue:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
				[self.imageArray addObject:(NSManagedObjectContext *)imageContext];
			}
			
//			[self mapViewUpdateLat:loc.latitude andLon:loc.longitude];
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
				
//				[self mapViewUpdateLat:latitude andLon:longitude];
				setCoord = YES;
				break;
			}
		}
		
//		if (!setCoord) {
//			[self mapViewUpdateLat:loc.latitude andLon:loc.longitude];
//		}
		isLocation = YES;
		wasFound = YES;
//		Debug(@"setDiaryDataFields : lat = %f. lon = %f", shareLoc.latitude, shareLoc.longitude);
//		Debug("[[imageContext valueForKey:latitude] doubleValue] = %f, [[imageContext valueForKey:@longitude] doubleValue] = %f", [[imageContext valueForKey:@"latitude"] doubleValue], [[imageContext valueForKey:@"longitude"] doubleValue]);
//		Debug("shareLoc.latitude = %f, shareLoc.longitude = %f", shareLoc.latitude, shareLoc.longitude);
		
		
	}
    reversGeo = [[MKReverseGeocoder alloc] initWithCoordinate:shareLoc];
    reversGeo.delegate = self;
    [reversGeo start];
//	[locManager stopUpdatingLocation];

	
//	[activityIndicator stopAnimating];
//	[cameralButton setTitle:@"사진" forState:UIControlStateNormal];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//	[activityIndicator stopAnimating];
	
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
    [locManager stopUpdatingLocation];
}

/*
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
*/
 
/*
- (IBAction)viewLargeMap {
	Debug(@"viewLargeMap : lat = %f. lon = %f", latitude,longitude);
	
	DiaryMapViewController *mapViewController = [[DiaryMapViewController alloc] initWithLatitude:latitude andLongitude:longitude andAnnotation:annotation];
	[self.navigationController pushViewController:mapViewController animated:YES];
}


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
	
	doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 242, 48.0, 25.0)];

	[doneButton setBackgroundImage:[UIImage imageNamed:@"btnDismissKeyboard.png"] forState:UIControlStateNormal];	
	[doneButton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchDown];
	doneButton.titleLabel.font = [UIFont systemFontOfSize: 16];
	[self.view addSubview:doneButton];
	[doneButton release];

    [scrollView setContentOffset:CGPointMake(0.0, kbSize.height - 80) animated:YES];
    self.contentView.frame = CGRectMake(14, 148, 291, 210);
	
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
	self.contentView.frame = CGRectMake(14, 148, 291, 260);
    [doneButton removeFromSuperview];
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
#pragma mark IBAction

- (IBAction) refreshWeatherClicked {
	Debug(@"refreshWeatherClicked");
	if (isGetWeatherEnd) {
		isGetWeatherEnd = NO;
	}
//	isFindLocation = YES;
	
	if (postalCode != nil) {
		[self getWOEID];
	} else {
		[locManager startUpdatingLocation];
	}
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
	
//	diaryData.image = [[NSMutableSet alloc] initWithArray:imageArray];
	
	diaryData.tag = self.titleField.text;
	diaryData.content = self.contentView.text;
    diaryData.reverseAddr = self.locField.text;
    diaryData.latitude = [NSNumber numberWithDouble:latitude];
    diaryData.longitude = [NSNumber numberWithDouble:longitude];
    diaryData.weatherDesc = self.weatherDesc.text;
    diaryData.weatherIcon = self.wIconName;
    
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
		
		NSSet *imageSet = [[NSSet alloc] initWithArray:self.imageContextArray];
		[diaryData setValue:imageSet forKey:@"image"];
		
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
	diaryData.thumbnailImage = self.thumbnailView.image;
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
	
    [locManager stopUpdatingLocation];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) cancel {
//	NSString *newDateString = nil;
//	if (modifyMode) {
//		newDateString = [diaryData valueForKey:@"sectionDate"];
//		[delegate reloadTableView:newDateString];
//	}
	[locManager stopUpdatingLocation];
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
	self.photoZone  = nil;
    self.thumbnailView = nil;
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
    
    self.doneButton = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[photoZone release];
    [thumbnailView release];
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
	
	[geoTaggedImage release];
	[locManager release];
	
	[imageArray release];
    [imageContextArray release];
	[childData release];
	[diaryData release];
	
	[fetchedResultsController release];
	[managedObjectContext release];
	[imageViewButton release];
	[dateFormatter release];
	
	[photoSlideController release];
	[imageContext release];
    
    [wIconName release];
    
    [reverseAddr release];
	[country release];
	[administrativeArea release];
	[subAdministrativeArea release];
	[locality release];
	[subLocality release];
	[thoroughfare release];
	[subThoroughfare release];
	[postalCode release];
    
    [locField release];
    
    [weatherIcon release];
	[tempHL release];
	[currCondition release];
	[currTemp release];
	[city release];
	[lowTemp release];
	[highTemp release];
	[refreshWeather release];
    [weatherDesc release];
    [dateTime release];
    
    [doneButton release];

	[super dealloc];
}


@end
