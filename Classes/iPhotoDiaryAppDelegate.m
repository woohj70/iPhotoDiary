//
//  iPhotoDiaryAppDelegate.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 4. 23..
//  Copyright Mazdah.com 2010. All rights reserved.
//

#import "iPhotoDiaryAppDelegate.h"
#import "AppMainViewController.h"
#import "CalendarGridViewController.h"
#import "DiaryListViewController.h"
#import "EventListViewController.h"
#import "EXFLogging.h"


@implementation iPhotoDiaryAppDelegate

@synthesize window;
@synthesize tabBarController;
//@synthesize configController;
@synthesize appMainViewController;
@synthesize calendarView;
@synthesize diaryListController;
@synthesize eventListController;

BOOL gLogging = YES;

#pragma mark -
#pragma mark Application lifecycle
/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch.
	return YES;
}
*/

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	Debug(@"applicationDidFinishLaunching");
//	configController.managedObjectContext = self.managedObjectContext;
//	appMainViewController.managedObjectContext = [self managedObjectContext];
	calendarView.managedObjectContext = [self managedObjectContext];
	diaryListController.managedObjectContext = [self managedObjectContext];
	eventListController.managedObjectContext = [self managedObjectContext];
	
	[self writeToPlist];
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
	
//	[self copyDatabaseIfNeeded:@"iPhotoDiary.sqlite"];
}

- (NSString *) getDBPath:(NSString *)dbName {
	Debug(@"getDBPath:");
    NSArray *paths =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:dbName];
}

/*
- (void) copyDatabaseIfNeeded:(NSString *)dbName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath:dbName];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if(!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath]
								   stringByAppendingPathComponent:@"NewIPhotoDiary.sqlite"
								   ];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.",
					  [error localizedDescription]
					  );
    }
}
*/
 
/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	Debug(@"applicationWillTerminate:");
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	Debug(@"managedObjectContext");
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	Debug(@"managedObjectModel");
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
//    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"NewIPhotoDiary" ofType:@"momd"];
	NSURL *momURL = [NSURL fileURLWithPath:path]; 
	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
	
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	Debug(@"persistentStoreCoordinator");
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"NewIPhotoDiary.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"NewIPhotoDiary" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }    
	
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	Debug(@"applicationDocumentsDirectory");
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark copy bundle to Documents

-(void)writeToPlist{
	Debug(@"applicationDocumentsDirectory");
	//Get file path
	NSArray* pArrPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *savePath = [pArrPaths objectAtIndex:0];
	//NSLog(pStrSavePath);
	savePath = [savePath stringByAppendingPathComponent:@"AnnData.plist"];
	NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"AnnData" ofType:@"plist"];
	
	Debug(@"savePath = %@", savePath);
	//Save file path
	NSMutableDictionary* pFileSaveDic = [[NSMutableDictionary alloc] initWithContentsOfFile:savePath];
	if(pFileSaveDic == nil){
		//Write
		//		[pFileSaveDic writeToFile:savePath atomically:YES];
		NSError *error;
		[[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:savePath error:&error];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[appMainViewController release];
	[calendarView release];
	[diaryListController release];
	[eventListController release];
	
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

@implementation UITabBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"tabbar_background.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

//                                  #Lighter r,g,b,a                    #Darker r,g,b,a
#define MAIN_COLOR_COMPONENTS       { 0.153, 0.306, 0.553, 1.0, 0.122, 0.247, 0.482, 1.0 }
#define LIGHT_COLOR_COMPONENTS      { 0.478, 0.573, 0.725, 1.0, 0.216, 0.357, 0.584, 1.0 }

@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
	//    if (imageReady) {
	UIImage *img = [UIImage imageNamed: @"nvaHeader.png"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	
	//    } else {
	// Render yourself instead.
	// You will need to adjust the MAIN_COLOR_COMPONENTS and LIGHT_COLOR_COMPONENTS to match your app
	
	// emulate the tint colored bar
	//		CGContextRef context = UIGraphicsGetCurrentContext();
	//		CGFloat locations[2] = { 0.0, 1.0 };
	//		CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
	
	//		CGFloat topComponents[8] = LIGHT_COLOR_COMPONENTS;
	//		CGGradientRef topGradient = CGGradientCreateWithColorComponents(myColorspace, topComponents, locations, 2);
	//		CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, 0), CGPointMake(0,self.frame.size.height/2), 0);
	//		CGGradientRelease(topGradient);
	
	//		CGFloat botComponents[8] = MAIN_COLOR_COMPONENTS;
	//		CGGradientRef botGradient = CGGradientCreateWithColorComponents(myColorspace, botComponents, locations, 2);
	//		CGContextDrawLinearGradient(context, botGradient,
	//									CGPointMake(0,self.frame.size.height/2), CGPointMake(0, self.frame.size.height), 0);
	//		CGGradientRelease(botGradient);
	
	//		CGColorSpaceRelease(myColorspace);
	
	
	// top Line
	//		CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0);
	//		CGContextMoveToPoint(context, 0, 0);
	//		CGContextAddLineToPoint(context, self.frame.size.width, 0);
	//		CGContextStrokePath(context);
	
	// bottom line
	//		CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
	//		CGContextMoveToPoint(context, 0, self.frame.size.height);
	//		CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
	//		CGContextStrokePath(context);
	//    }
}

@end
