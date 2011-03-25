//
//  DiaryData.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 11. 3. 24..
//  Copyright (c) 2011 Mazdah.com. All rights reserved.
//

#import "DiaryData.h"
#import "ChildData.h"
#import "DiaryImage.h"


@implementation DiaryData
@dynamic thumbnailImage;
@dynamic content;
@dynamic childname;
@dynamic sectionDate;
@dynamic tag;
@dynamic writedate;
@dynamic conditionDate;
@dynamic weatherDesc;
@dynamic weatherIcon;
@dynamic reverseAddr;
@dynamic subject;
@dynamic latitude;
@dynamic longitude;
@dynamic image;
@dynamic child;


- (void)addImageObject:(DiaryImage *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"image" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"image"] addObject:value];
    [self didChangeValueForKey:@"image" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeImageObject:(DiaryImage *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"image" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"image"] removeObject:value];
    [self didChangeValueForKey:@"image" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addImage:(NSSet *)value {    
    [self willChangeValueForKey:@"image" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"image"] unionSet:value];
    [self didChangeValueForKey:@"image" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeImage:(NSSet *)value {
    [self willChangeValueForKey:@"image" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"image"] minusSet:value];
    [self didChangeValueForKey:@"image" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
