//
//  iPhotoDiaryAppDelegate.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 4. 23..
//  Copyright Mazdah.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class CalendarViewController;
@class DiaryListViewController;
@class CalendarViewController;
@class AppMainViewController;
@class CalendarGridViewController;
@class DiaryListViewController;
@class EventListViewController;

@interface iPhotoDiaryAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
//	ConfigViewController *configController;
	AppMainViewController *appMainViewController;
	CalendarGridViewController *calendarView;
	DiaryListViewController *diaryListController;
	EventListViewController *eventListController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//@property (nonatomic, retain) IBOutlet ConfigViewController *configController;
@property (nonatomic, retain) IBOutlet AppMainViewController *appMainViewController;
@property (nonatomic, retain) IBOutlet CalendarGridViewController *calendarView;
@property (nonatomic, retain) IBOutlet DiaryListViewController *diaryListController;
@property (nonatomic, retain) IBOutlet EventListViewController *eventListController;

@end
