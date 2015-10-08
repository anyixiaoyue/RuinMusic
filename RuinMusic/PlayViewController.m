//
//  PlayViewController.m
//  RuinMusic
//
//  Created by hk on 14-11-26.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController (){
    NSTimer *timer;
    UILabel *label1;
    UILabel *label2;
    BOOL isCircle;
    BOOL isSingleCircle;
    BOOL israndomPlay;
    BOOL single;
    BOOL isPlay;
    BOOL tage;
   // NSMutableArray *musicArray;
   // NSUInteger musicArrayNumber;
    //Music *currentMusic;
    
    NSMutableDictionary *LRCDictionary;
    NSMutableArray *timeArray;
    NSUInteger lrcLineNumber;
    
}


@end

@implementation PlayViewController
@synthesize musicArray,musicArrayNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initDate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化要加载的曲目
    //musicArrayNumber = 0;
    NSString *path = [[NSBundle mainBundle]pathForResource:[musicArray [musicArrayNumber] name] ofType:@"mp3"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    //currentMusic = musicArray[musicArrayNumber];
    self.navigationItem.title = [musicArray[musicArrayNumber] name];

    //播放进度
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(50, 480, 220, 40)];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = self.audioPlayer.duration;
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderThumb_small.png"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderThumb_small.png"] forState:UIControlStateHighlighted];
    [self.slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    
    //播放时间
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 480, 50, 40)];
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(270, 480, 270, 40)];
    label1.text = @"00:00";

    //更新播放
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sliderValueUpdate) userInfo:nil repeats:YES];
    [timer fire];
    [self.view addSubview:self.slider];
    
    //初始化音量和音量进度条
    self.audioPlayer.volume = 0.1;
    self.sound.value = self.audioPlayer.volume;
    [self.sound setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateNormal];
    [self.sound setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateHighlighted];

    //循环
    isCircle = YES;
    isPlay = YES;
    isSingleCircle = YES;
    israndomPlay = YES;
    single = YES;
    [self.circle setImage:[UIImage imageNamed:@"circleClose.png"] forState:UIControlStateNormal];
    
    //初始化歌词词典
    timeArray = [[NSMutableArray alloc]initWithCapacity:10];
    LRCDictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
    
    //[self initLRC];
    
    //tableview 代理
    self.LRCTbaleView.delegate = self;
    self.LRCTbaleView.dataSource = self;
    
    //手势初始化
    tage = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Swipe)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Swipe1)];
    swipe1.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe1];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
    [self initLRC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 音量控制
//音量改变
- (IBAction)soundChange:(id)sender {
    self.audioPlayer.volume = self.sound.value;
}

//静音
- (IBAction)silent:(id)sender {
    static BOOL flag = YES;
    static float i;
    if (flag) {
        i = self.sound.value;
        self.audioPlayer.volume = 0;
        self.sound.value = self.audioPlayer.volume;
        [self.silent setImage:[UIImage imageNamed:@"silent"] forState:UIControlStateNormal];
        flag = NO;
    }else{
        self.audioPlayer.volume = i;
        self.sound.value = self.audioPlayer.volume;
        [self.silent setImage:[UIImage imageNamed:@"volume_down"] forState:UIControlStateNormal];
        flag = YES;
    }
}

//音量+
- (IBAction)addsound:(id)sender {
    self.audioPlayer.volume = self.sound.value + 0.1;
    self.sound.value = self.audioPlayer.volume;
}

//音量-
- (IBAction)minussound:(id)sender {
    self.audioPlayer.volume = self.sound.value - 0.1;
    self.sound.value = self.audioPlayer.volume;
}

#pragma mark 播放控制
//播放进度改变
-(void)sliderValueChange{
    self.audioPlayer.currentTime = self.slider.value;
}

#pragma mark 0.1秒一次更新 播放时间 播放进度条 歌词 歌曲 自动播放下一首
//播放时间更新
-(void)sliderValueUpdate{
    int totalseconds = self.audioPlayer.duration;
    int second = totalseconds % 60;
    int  minute = totalseconds / 60;
    
    
    label2.text = [NSString stringWithFormat:@"%02d:%02d",minute, second];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    
    self.slider.value = self.audioPlayer.currentTime;
    int totalseconds1 = self.audioPlayer.currentTime;
    int second1= totalseconds1 % 60;
    int  minute1 = totalseconds1 / 60;
    label1.text = [NSString stringWithFormat:@"%02d:%02d",minute1 , second1];
    
    //调用歌词函数
    [self displaySoundword:self.audioPlayer.currentTime];
  
    
    //如果播放完，调用自动播放下一首
    if (self.audioPlayer.currentTime > (self.audioPlayer.duration - 0.1)) {
        [self autoPlay];
    }
}

//播放，暂停
- (IBAction)Play:(id)sender {
    if (isPlay) {
        [self.audioPlayer play];
        [self.Playbutton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        isPlay = NO;
    }else{
        [self.audioPlayer pause];
        [self.Playbutton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        isPlay = YES;
    }

}

//上一曲
- (IBAction)above:(id)sender {
    if (musicArrayNumber == 0) {
        musicArrayNumber = musicArray.count;
    }
    musicArrayNumber --;
    
    [self updatePlayerSetting];
}

//下一曲
- (IBAction)next:(id)sender {
   /* if (musicArrayNumber == musicArray.count - 1) {
        musicArrayNumber = -1;
    }
    musicArrayNumber++;
    
    [self updatePlayerSetting];*/
    if (isCircle) {
        if (isSingleCircle) {
            if (israndomPlay) {
                //[self.circle setImage:[UIImage imageNamed:@"circleClose.png"] forState:UIControlStateNormal];
                [self.audioPlayer play];
                [self.Playbutton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
                isPlay = NO;
                [self updatePlayerSetting];
            } else {
                //[self.circle setImage:[UIImage imageNamed:@"randomOpen.png"] forState:UIControlStateNormal];
                int x = arc4random() % ([musicArray count]);
                musicArrayNumber = x;
                NSLog(@"%d",x);
                
                [self updatePlayerSetting];
                
            }
        }else {
            //[self.circle setImage:[UIImage imageNamed:@"SinglecircleOpen.png"] forState:UIControlStateNormal];
            NSLog( @"1");
            [self updatePlayerSetting];
            
        }
    } else {
        //[self.circle setImage:[UIImage imageNamed:@"circleOpen.png"] forState:UIControlStateNormal];
        if (musicArrayNumber == musicArray.count - 1) {
            musicArrayNumber = -1;
        }
        musicArrayNumber ++;
        NSLog(@"2");
        [self updatePlayerSetting];
        
    }

}


//循环
- (IBAction)circle:(id)sender {
    if (isCircle) {
        if (isSingleCircle) {
            if (israndomPlay) {
                [self.circle setImage:[UIImage imageNamed:@"randomOpen.png"] forState:UIControlStateNormal];
                israndomPlay = NO;
            } else {
                [self.circle setImage:[UIImage imageNamed:@"SinglecircleOpen.png"] forState:UIControlStateNormal];
                isSingleCircle = NO;
                //single = NO;
                }
        }else {
            [self.circle setImage:[UIImage imageNamed:@"circleOpen.png"] forState:UIControlStateNormal];
                isCircle = NO;
        }
        //self.circle.alpha = 0.5;
       // isCircle = NO;
    } else {
         [self.circle setImage:[UIImage imageNamed:@"circleClose.png"] forState:UIControlStateNormal];
        isCircle = YES;
        isSingleCircle = YES;
        israndomPlay = YES;
        single = YES;
    }
}


//更新播放器设置
- (void)updatePlayerSetting{
    //更新播放按钮状态
    //[self.Playbutton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    //isPlay = NO;
    
    //更新曲目
    NSString *path = [[NSBundle mainBundle]pathForResource:[musicArray [musicArrayNumber] name] ofType:@"mp3"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    //currentMusic = musicArray[musicArrayNumber];
    
    self.navigationItem.title = [musicArray[musicArrayNumber] name];
    //更新载入歌词词典
    timeArray = [[NSMutableArray alloc]initWithCapacity:10];
    LRCDictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
    [self initLRC];
    if (isPlay) {
        [self.audioPlayer pause];
        [self.Playbutton setBackgroundImage:[UIImage imageNamed:@"paly.png"] forState:UIControlStateNormal];
    } else {
        [self.audioPlayer play];
        [self.Playbutton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];

    }
}

#pragma mark 循环切换
- (void)autoPlay{
    if (isCircle) {
        if (isSingleCircle) {
            if (israndomPlay) {
                //[self.circle setImage:[UIImage imageNamed:@"circleClose.png"] forState:UIControlStateNormal];
                [self.audioPlayer pause];
                //[self.Playbutton setBackgroundImage:[UIImage imageNamed:@"paly.png"] forState:UIControlStateNormal];
                isPlay = YES;
                [self updatePlayerSetting];
            } else {
                //[self.circle setImage:[UIImage imageNamed:@"randomOpen.png"] forState:UIControlStateNormal];
                int x = arc4random() % ([musicArray count]);
                musicArrayNumber = x;
                NSLog(@"%d",x);
                
                [self updatePlayerSetting];
                
            }
        }else {
            //[self.circle setImage:[UIImage imageNamed:@"SinglecircleOpen.png"] forState:UIControlStateNormal];
            NSLog( @"1");
            [self updatePlayerSetting];
            
        }
    } else {
        //[self.circle setImage:[UIImage imageNamed:@"circleOpen.png"] forState:UIControlStateNormal];
        if (musicArrayNumber == musicArray.count - 1) {
            musicArrayNumber = -1;
        }
        musicArrayNumber ++;
        NSLog(@"2");
        [self updatePlayerSetting];
        
    }
}
    //
    /*if (isCircle) {
        if (musicArrayNumber == musicArray.count - 1) {
            musicArrayNumber = -1;
        }
        musicArrayNumber ++;
        
        [self updatePlayerSetting];
    } else {
        [self.audioPlayer play];
        [self.Playbutton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        isPlay = NO;
    }
}
*/
#pragma mark 载入歌曲数组
- (void)initDate{
    Music *music1 = [[Music alloc] initWithName:@"梁静茹-偶阵雨" andType:@"mp3"];
    Music *music2 = [[Music alloc] initWithName:@"林俊杰-背对背拥抱" andType:@"mp3"];
    Music *music3 = [[Music alloc] initWithName:@"情非得已" andType:@"mp3"];
    Music *music4 = [[Music alloc] initWithName:@"喜欢你" andType:@"mp3"];
    Music *music5 = [[Music alloc] initWithName:@"荷塘月色" andType:@"mp3"];
    //Music *music6 = [[Music alloc] initWithName:@"情非得已" andType:@"mp3"];
    
    
    musicArray = [[NSMutableArray alloc]initWithCapacity:5];
    [musicArray addObject:music1];
    [musicArray addObject:music2];
    [musicArray addObject:music3];
    [musicArray addObject:music4];
    [musicArray addObject:music5];
    
    
}

#pragma mark 得到歌词
- (void)initLRC{
    NSString *LRCPath = [[NSBundle mainBundle]pathForResource:[musicArray[musicArrayNumber] name]   ofType:@"lrc"];
    NSString *contentStr = [NSString stringWithContentsOfFile:LRCPath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *array = [contentStr componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [array count]; i++) {
        NSString *linStr = [array objectAtIndex:i];
        NSArray *lineArray = [linStr componentsSeparatedByString:@"]"];
        if ([lineArray[0] length] > 8) {
            NSString *str1 = [linStr substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [linStr substringWithRange:NSMakeRange(6, 1)];
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                NSString *lrcStr = [lineArray objectAtIndex:1];
                NSString *timeStr = [[lineArray objectAtIndex:0]substringWithRange:NSMakeRange(1, 5)];//分割区间求歌词时间
                //把时间和歌词加入词典
                [LRCDictionary setObject:lrcStr forKey:timeStr];
                [timeArray addObject:timeStr];//timeArray 的count就是行数
            }
        }
    }
}

#pragma mark 动态显示歌词
- (void)displaySoundword:(NSUInteger)time{
    for (int i = 0; i < [timeArray count]; i++) {
        NSArray *array = [timeArray[i] componentsSeparatedByString:@":"];//把时间转换成秒
        NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
        if (i == [timeArray count] - 1) {
            //求最后一句歌词的时间点
            NSArray *array1 = [timeArray[timeArray.count -1] componentsSeparatedByString:@":"];
            NSUInteger currentTime1 = [array1[0] intValue] * 60 + [array1[1] intValue];
            if (time > currentTime1) {
                [self updateLrcTableView:i];
                break;
            }
        } else {
            //求出第一句的时间点，在第一句显示前的时间内一直加载第一句
            NSArray *array2 = [timeArray[0] componentsSeparatedByString:@":"];
            NSUInteger currentTime2 = [array2[0] intValue] *60 + [array2[1]intValue];
            if (time < currentTime2) {
                [self updateLrcTableView:0];
                
                break;
            }
            //求出下一步的歌词时间点，然后计算区间
            NSArray *array3 = [timeArray[i + 1] componentsSeparatedByString:@":"];
            NSUInteger currentTime3 = [array3[0] intValue] * 60 + [array3[1] intValue];
            if (time >= currentTime && time <= currentTime3) {
                [self updateLrcTableView:i];
                break;
            }
        }
    }
}

#pragma mark 动态更新歌词表歌词
- (void)updateLrcTableView:(NSUInteger)lineNumber{
    //重新载入歌词列表lrcTabView
    lrcLineNumber = lineNumber;
    [self.LRCTbaleView reloadData];
    
    //使被选中的行移到中间
    if (tage) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lineNumber inSection:0];
        [self.LRCTbaleView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
}

#pragma mark 手势控制
- (void)Swipe{
    if (tage) {
        tage = NO;
    } else {
        tage = YES;
    }
}

- (void)Swipe1{
    if (tage) {
        tage = NO;
    } else {
        tage = YES;
    }
}

#pragma mark 加载tableview表视图
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tage) {
        return [timeArray count];
    } else {
    return [musicArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Celldentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Celldentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Celldentifier];
            }
    if (tage) {
        cell.textLabel.text = [LRCDictionary objectForKey:[timeArray objectAtIndex:indexPath.row]];
        [cell.textLabel setFont:[UIFont fontWithName:nil size:12.0f]];
    } else {
        cell.textLabel.text = [[musicArray objectAtIndex:indexPath.row] name];
        [cell.textLabel setFont:[UIFont fontWithName:nil size:18.0f]];
    }
    //cell.textLabel.text = [LRCDictionary objectForKey:[timeArray objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tage) {
        return 20;
    } else {
        return 30;
    }
    
}

@end
