//
//  DiaryData.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 18..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ChildData;

@interface DiaryData :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * writedate;
@property (nonatomic, retain) NSString * sectionDate;
@property (nonatomic, retain) NSString * conditionDate;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) UIImage *thumbnailImage;
@property (nonatomic, retain) NSSet* image;
@property (nonatomic, retain) ChildData * child;
@property (nonatomic, retain) NSString * childname;

@end


@interface DiaryData (CoreDataGeneratedAccessors)
- (void)addImageObject:(NSManagedObject *)value;
- (void)removeImageObject:(NSManagedObject *)value;
- (void)addImage:(NSSet *)value;
- (void)removeImage:(NSSet *)value;

@end

