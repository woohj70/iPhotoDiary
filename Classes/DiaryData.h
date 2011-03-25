//
//  DiaryData.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 11. 3. 24..
//  Copyright (c) 2011 Mazdah.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChildData, DiaryImage;

@interface DiaryData : NSManagedObject {
@private
}
@property (nonatomic, retain) id thumbnailImage;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * childname;
@property (nonatomic, retain) NSString * sectionDate;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDate * writedate;
@property (nonatomic, retain) NSString * conditionDate;
@property (nonatomic, retain) NSString * weatherDesc;
@property (nonatomic, retain) NSString * weatherIcon;
@property (nonatomic, retain) NSString * reverseAddr;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet* image;
@property (nonatomic, retain) ChildData * child;

@end

@interface DiaryData (CoreDataGeneratedAccessors)
- (void)addImageObject:(DiaryImage *)value;
- (void)removeImageObject:(DiaryImage *)value;
- (void)addImage:(NSSet *)value;
- (void)removeImage:(NSSet *)value;

@end