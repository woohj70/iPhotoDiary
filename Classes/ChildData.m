// 
//  ChildData.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 7. 16..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "ChildData.h"

#import "DiaryData.h"
#import "EventData.h"
#import "TreatmentData.h"
#import "VaccinationData.h"

@implementation ChildData 

@dynamic doctor;
@dynamic thumbnailImage;
@dynamic childname;
@dynamic idnum;
@dynamic weight;
@dynamic birthday;
@dynamic height;
@dynamic hospital;
@dynamic location;
@dynamic nickname;
@dynamic gender;
@dynamic treatment;
@dynamic diary;
@dynamic image;
@dynamic vaccin;
@dynamic events;
@dynamic islunar;
@dynamic birthdayLunar;
@dynamic birthdaySolar;

@end

@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return [uiImage autorelease];
}


@end