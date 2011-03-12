//
//  AppMainView.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 22..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildData.h"
#import "EXFLogging.h"

#import "AddChildViewController.h"
#import "AddNewChildViewController.h"
#import "ChildListViewController.h"

#import "KLCalendarModel.h"
#import "MCLunarDate.h"
#import "MCSolarDate.h"

#import "TodayEventTableViewController.h"

@interface AppMainViewController : UIViewController<NSFetchedResultsControllerDelegate, UIAlertViewDelegate> {
	UIImageView *childPhotoView;
	UIImageView *backgroundImageView;
	
	UILabel *childName;
	UILabel *ddi;
	UILabel *childBirthday;
	UILabel *childYear;
	UILabel *zodiac;
	UILabel *jewelry;
	UILabel *childGender;
	
	UIButton *birthLabel;
	BOOL isLunarOrSolar;
	
	NSMutableArray *childButtons;
//	UITableView *todaysEventTable;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	NSEntityDescription *entityDescription;
	ChildData *childData;
	NSArray *childDatas;
	
	ChildListViewController *childList;
	NSDateFormatter *dateFormatter;
	
	NSString *childButtonName;
	
	UIImageView *genderImageView;
	UIImageView *ddiImageView;
	UIImageView *zodiacImageView;
	UIImageView *jewelryImageView;
	
	TodayEventTableViewController *todayEvent;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) ChildData *childData;
@property (nonatomic, retain) NSEntityDescription *entityDescription;
@property (nonatomic, retain) NSArray *childDatas;
@property (nonatomic, retain) ChildListViewController *childList;

@property (nonatomic, retain) IBOutlet UIImageView *childPhotoView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UILabel *childName;
@property (nonatomic, retain) IBOutlet UILabel *ddi;
@property (nonatomic, retain) IBOutlet UILabel *childBirthday;
@property (nonatomic, retain) IBOutlet UILabel *childYear;
@property (nonatomic, retain) IBOutlet UILabel *zodiac;
@property (nonatomic, retain) IBOutlet UILabel *jewelry;
@property (nonatomic, retain) IBOutlet UILabel *childGender;
@property (nonatomic, retain) IBOutlet UIButton *birthLabel;
//@property (nonatomic, retain) IBOutlet UITableView *todaysEventTable;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSString *childButtonName;

@property (nonatomic, retain) IBOutlet UIImageView *ddiImageView;
@property (nonatomic, retain) IBOutlet UIImageView *zodiacImageView;
@property (nonatomic, retain) IBOutlet UIImageView *jewelryImageView;
@property (nonatomic, retain) IBOutlet UIImageView *genderImageView;

+ (NSString *)selectedChildName;
+ (NSMutableArray *)childrenArray;

- (IBAction)buttonPressed:(UIButton *)childButton;
- (IBAction)goChildAddView;
- (IBAction)toggleLunarAndSolar;

- (void)selectChild:(UIButton *)sender;

@end
