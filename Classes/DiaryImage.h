//
//  DiaryImage.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 24..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DiaryData;

@interface DiaryImage :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) DiaryData * diary;

@end



