//
//  AnniversaryModel.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 29..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AnniversaryModel.h"

@implementation AnniversaryModel

@synthesize annData;

#pragma mark -
#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:(NSMutableDictionary *)annData forKey:kDataKey];
}

- (void)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		self.annData = (NSMutableDictionary *)[aDecoder decodeObjectForKey:kDataKey];
	}
	
	return self;
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	AnniversaryModel *annModel = [[[self class] allocWithZone: zone] init];
	annModel.annData = (NSMutableDictionary *)[[self.annData copyWithZone:zone] autorelease];
}
@end
