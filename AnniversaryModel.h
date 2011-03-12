//
//  AnniversaryModel.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 29..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDataKey	@"dicData"

@interface AnniversaryModel : NSObject<NSCoding, NSCopying> {
	NSMutableDictionary *annData;
}

@property(nonatomic, retain) NSMutableDictionary *annData;

@end
