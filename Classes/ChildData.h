//
//  ChildData.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 7. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DiaryData;
@class EventData;
@class TreatmentData;
@class VaccinationData;

@interface ImageToDataTransformer : NSValueTransformer {
}
@end

@interface ChildData :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * doctor;
@property (nonatomic, retain) UIImage *thumbnailImage;
@property (nonatomic, retain) NSString * childname;
@property (nonatomic, retain) NSString * idnum;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * hospital;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSSet* treatment;
@property (nonatomic, retain) NSSet* diary;
@property (nonatomic, retain) NSManagedObject * image;
@property (nonatomic, retain) NSSet* vaccin;
@property (nonatomic, retain) NSSet* events;
@property (nonatomic, retain) NSNumber * islunar;
@property (nonatomic, retain) NSString * birthdayLunar;
@property (nonatomic, retain) NSString * birthdaySolar;

@end


@interface ChildData (CoreDataGeneratedAccessors)
- (void)addTreatmentObject:(TreatmentData *)value;
- (void)removeTreatmentObject:(TreatmentData *)value;
- (void)addTreatment:(NSSet *)value;
- (void)removeTreatment:(NSSet *)value;

- (void)addDiaryObject:(DiaryData *)value;
- (void)removeDiaryObject:(DiaryData *)value;
- (void)addDiary:(NSSet *)value;
- (void)removeDiary:(NSSet *)value;

- (void)addVaccinObject:(VaccinationData *)value;
- (void)removeVaccinObject:(VaccinationData *)value;
- (void)addVaccin:(NSSet *)value;
- (void)removeVaccin:(NSSet *)value;

- (void)addEventsObject:(EventData *)value;
- (void)removeEventsObject:(EventData *)value;
- (void)addEvents:(NSSet *)value;
- (void)removeEvents:(NSSet *)value;

@end

