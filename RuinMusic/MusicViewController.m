//
//  MusicViewController.m
//  RuinMusic
//
//  Created by hk on 14-11-19.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import "MusicViewController.h"
#import "MenuViewController.h"
#import "LocalViewController.h"
#import "WebViewController.h"
#import "MainViewController.h"
#import "PlayViewController.h"
#import "AddNoteViewController.h"


@interface MusicViewController (){

    NSArray *segmentedArray;
    MainViewController *main;
    MenuViewController *menu;
    LocalViewController *local;
    WebViewController *web;
    PlayViewController * play;
    UIBarButtonItem *Space;
    UIBarButtonItem *item1;
    UIBarButtonItem *item2;
    UIBarButtonItem *item3;
    UIBarButtonItem *item4;
    BOOL flag;
    UIImageView *imageview0;
    UIImageView *imageview1;
    UIImage *image0;
    UIImage *image1;

}

@end

@implementation MusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    main = [[MainViewController alloc]init];
    menu = [[MenuViewController alloc]init];
    local = [[LocalViewController alloc]init];
    web = [[WebViewController alloc]init];
    play = [[PlayViewController alloc]initWithNibName:@"PlayViewController" bundle:nil];
    
    //导航条
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(seach)];
    
    //toolbar
    [self.navigationController setToolbarHidden:NO];
    Space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    item1 = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"%@",[play.musicArray [play.musicArrayNumber] name]] style:UIBarButtonItemStylePlain target:self action:@selector(playMusic)];
    imageview0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    image0 = [UIImage imageNamed:@"play1.png"];
    [imageview0 setImage:image0];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play)];
    [imageview0 addGestureRecognizer:tap1];
    
    imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    image1 = [UIImage imageNamed:@"pause1.png"];
    [imageview1 setImage:image1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play)];
    [imageview1 addGestureRecognizer:tap2];
    //item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    //item3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(play)];
    item2 = [[UIBarButtonItem alloc]initWithCustomView:imageview0];
    item3 = [[UIBarButtonItem alloc]initWithCustomView:imageview1];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImage *image = [UIImage imageNamed:@"next1.png"];
    [imageview setImage:image];
    item4 = [[UIBarButtonItem alloc]initWithCustomView:imageview];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(next)];
    [imageview addGestureRecognizer:tap];
    //item4 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    [self setToolbarItems:[NSArray arrayWithObjects:item1, Space, Space,  item2, item4,nil]];

//segment
    segmentedArray  = [[NSArray alloc]initWithObjects:@"☁️菜单",@"💧我的音乐",@"🎵音乐笔记",@"🔍网络", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 64, 320, 25);
    segmentedControl.selectedSegmentIndex = 1;
    self.navigationItem.title = @"我的音乐";
   // segmentedControl.tintColor= [ UIColor redColor];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];

    //页面加载
    [main.view setFrame:CGRectMake(0, 89, 320, 435)];
    [main.view setBackgroundColor:[UIColor lightGrayColor]];
    [menu.view setFrame:CGRectMake(0, 89, 320, 435)];
    [menu.view setBackgroundColor:[UIColor redColor]];
    [local.view setFrame:CGRectMake(0, 89, 320, 435)];
    //[local.view setBackgroundColor:[UIColor greenColor]];

    [web.view setFrame:CGRectMake(0, 89, 320, 465)];
    //[web.view setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:menu.view];
    [self.view addSubview:local.view];
    [self.view addSubview:web.view];
    [self.view addSubview:main.view];
    
    //音乐路径
    play.musicArrayNumber = 0;
    NSString *path = [[NSBundle mainBundle]pathForResource:[play.musicArray [play.musicArrayNumber] name] ofType:@"mp3"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    flag = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:NO];
}

//播放暂停
-(void)play{
    if (flag) {
        [self.audioPlayer pause];
        [self setToolbarItems:[NSArray arrayWithObjects:item1, Space, Space,  item2, item4,nil]];
        //item2 = [[UIBarButtonItem alloc]initWithCustomView:imageview1];
        flag = NO;
    }else{
        
        [self.audioPlayer play];
        [self setToolbarItems:[NSArray arrayWithObjects:item1, Space, Space,  item3, item4,nil]];
       // item2 = [[UIBarButtonItem alloc]initWithCustomView:imageview0];
        flag = YES;
    }
}

//下一首
- (void)next{
    if (play.musicArrayNumber < ([play.musicArray count] - 1)) {
        play.musicArrayNumber++;
    } else {
        play.musicArrayNumber = 0;
    }
    
    item1.title = [NSString stringWithFormat:@"%@",[play.musicArray [play.musicArrayNumber] name]] ;
    NSString *path = [[NSBundle mainBundle]pathForResource:[play.musicArray [play.musicArrayNumber] name] ofType:@"mp3"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    if (flag) {
        
        [self.audioPlayer play];

        [self setToolbarItems:[NSArray arrayWithObjects:item1, Space, Space,  item3, item4,nil]];
    } else {
         [self.audioPlayer pause];
        
        [self setToolbarItems:[NSArray arrayWithObjects:item1, Space, Space,  item2, item4,nil]];
    }
   }

//播放界面跳转
-(void)playMusic{
        [self.navigationController pushViewController:play animated:YES];
}


//导航界面跳转
- (void)selectview:(id)view {
    NSInteger index = [self.view.subviews indexOfObject:view];
    NSInteger lastindex = [self.view.subviews count] - 1;
    [self.view exchangeSubviewAtIndex:index withSubviewAtIndex:lastindex];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [self selectview:menu.view];
            [self.navigationController setToolbarHidden:NO];
            self.navigationItem.title = @"菜单";
            
            break;
        case 1:
            [self selectview:main.view];
            [self.navigationController setToolbarHidden:NO];
            self.navigationItem.title = @"我的音乐";

            break;
       
        case 2:
            [self selectview:local.view];
            [self.navigationController setToolbarHidden:NO];
            self.navigationItem.title = @"音乐笔记";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加笔记" style:UIBarButtonSystemItemAdd target:self action:@selector(Add)];
                //
            break;
        case 3:
            [self selectview:web.view];
             [self.navigationController setToolbarHidden:YES];
            self.navigationItem.title = @"网络";
            break;
        default:
            break;
    }
}

//列表
-(void)seach{
    //MenuViewController *menu = [[MenuViewController alloc]init];
    //[self.navigationController pushViewController:menu animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加笔记
- (void)Add{
    AddNoteViewController *add = [[AddNoteViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}
@end
