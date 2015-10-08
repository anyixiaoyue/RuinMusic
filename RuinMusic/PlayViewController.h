//
//  PlayViewController.h
//  RuinMusic
//
//  Created by hk on 14-11-26.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Music.h"


@interface PlayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (retain, nonatomic)AVAudioPlayer *audioPlayer;


@property (weak, nonatomic) IBOutlet UISlider *sound;
- (IBAction)soundChange:(id)sender;
- (IBAction)silent:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *silent;
- (IBAction)addsound:(id)sender;
- (IBAction)minussound:(id)sender;


@property (strong, nonatomic)UISlider *slider;
- (IBAction)Play:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *Playbutton;
- (IBAction)above:(id)sender;
- (IBAction)next:(id)sender;

- (IBAction)circle:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *circle;


@property (weak, nonatomic) IBOutlet UITableView *LRCTbaleView;

@property (retain, nonatomic)NSMutableArray *musicArray;
@property (nonatomic)NSUInteger musicArrayNumber;

@end
