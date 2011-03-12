//
//  AddNewChildViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 13..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddChildViewController.h"
#import "ChildData.h"
#import "DataPickerViewController.h"

@class AppMainViewController;

@interface AddNewChildViewController : UIViewController<AddChildViewControllerDelegate, UINavigationControllerDelegate, 
									UIActionSheetDelegate, UIImagePickerControllerDelegate> {
	AddChildViewController *childViewController;
	NSManagedObjectContext *managedObjectContext;
	
	ChildBasicInfoCell *childBasicInfoCell;
	ChildInfoCell *childInfoCell;
	
	ChildData *childData;
	
	NSManagedObject *imageContext;
	UIImage *originalImage;
	UIImage *thumbnail;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) ChildBasicInfoCell *childBasicInfoCell;
@property (nonatomic, retain) ChildData *childData;

@property (nonatomic, retain) NSManagedObject *imageContext;
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *thumbnail;

@end
