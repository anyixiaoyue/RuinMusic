//
//  LocalViewController.h
//  RuinMusic
//
//  Created by hk on 14-12-11.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoDB.h"

@interface LocalViewController : UITableViewController <UISearchBarDelegate>

@property(retain, nonatomic)TodoDB *todoDB;

@end
