//
//  AddNoteViewController.h
//  RuinMusic
//
//  Created by hk on 14-12-11.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoDB.h"

@interface AddNoteViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *sub;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextView *desc;
- (IBAction)Save:(id)sender;
- (IBAction)datepicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *save;

@property (retain, nonatomic)TodoDB *todoDB;
@property (retain, nonatomic)Todo *todo;
@end
