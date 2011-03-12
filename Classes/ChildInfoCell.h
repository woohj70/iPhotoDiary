//
//  ChildInfoCell.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 31..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChildInfoCellDelegate;

@interface ChildInfoCell : UITableViewCell {
	NSString *valueStr;
	UILabel *labelField;
	UITextField *valueField;
	id<ChildInfoCellDelegate> delegate;

}

@property(nonatomic,retain) IBOutlet UILabel *labelField;
@property(nonatomic,retain) IBOutlet UITextField *valueField;

@property(nonatomic,retain) NSString *valueStr;

@property(nonatomic, assign) id<ChildInfoCellDelegate> delegate;

- (IBAction)beginEditing;
- (IBAction)endEditing;

@end

@protocol ChildInfoCellDelegate <NSObject>

- (void)scrollNewPosition:(ChildInfoCell *)cell;
@end