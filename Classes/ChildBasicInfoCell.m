//
//  ChildBasicInfoCell.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 31..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "ChildBasicInfoCell.h"
#import "AddChildViewController.h"
#import "EXFLogging.h"

@implementation ChildBasicInfoCell

@synthesize photoViewButton;
@synthesize nameField;
//@synthesize nickName;
@synthesize birthDay;
@synthesize birthDate;
@synthesize isLunar;

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.contentView.backgroundColor = [UIColor clearColor];
		
		nameField.returnKeyType = UIReturnKeyDone;
//		nickName.returnKeyType = UIReturnKeyDone;
		birthDay.returnKeyType = UIReturnKeyDone;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction) photoViewButtonClicked {
//	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//		Debug(@"photoViewButtonClicked");
//		[self.delegate showArgString:@"TEST"];
//		Debug(@"photoViewButtonClicked2");
		[self.delegate showActionSheet]; 
//	}
}

- (IBAction) movePickerView {
	[delegate movePickerView:self];
}

/*
- (void)showActionSheet {
	UIActionSheet *photoSelector = [[UIActionSheet alloc]
									initWithTitle:@"사진 선택" 
									delegate:self 
									cancelButtonTitle:@"취 소" 
									destructiveButtonTitle:nil 
									otherButtonTitles:@"사진 새로 찍기", @"찍은 사진 가져오기", nil];
	[photoSelector showInView:self.view];
	//	[photoSelector release];
}
*/

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//	Debug(@"textFieldShouldBeginEditing : textField.placeholder = %@", textField.placeholder);
//	if (textField.placeholder == @"생년월일") {
		return NO;
//	} else {
//		return YES;
//	}

}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
	[photoViewButton release];
	[nameField release];
//	[nickName release];
	[isLunar release];
	[birthDay release];
}


@end
