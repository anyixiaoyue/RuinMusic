//
//  MenuViewController.m
//  RuinMusic
//
//  Created by hk on 14-11-26.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import "MenuViewController.h"
#import "TestAppDelegate.h"
#import "MainViewController.h"
#import "LocalViewController.h"
#import "AddNoteViewController.h"
#import "Web1ViewController.h"
#import "AboutViewController.h"


@interface MenuViewController (){
    UINavigationController *nagationController;
}

@end

@implementation MenuViewController

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
    // Do any additional setup after loading the view from its nib.
    
    TestAppDelegate *appdelegate = (TestAppDelegate *)[UIApplication sharedApplication].delegate;
    nagationController = (UINavigationController *)appdelegate.window.rootViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)main:(id)sender {
    MainViewController *main = [[ MainViewController alloc]init];
    [nagationController pushViewController:main animated:YES];
    main.navigationController.toolbarHidden = YES;
    main.navigationItem.title = @"我的音乐";
}

- (IBAction)local:(id)sender {
    LocalViewController *local = [[LocalViewController alloc]init];
    [nagationController pushViewController:local animated:YES];
    local.navigationController.toolbarHidden = YES;
    local.navigationItem.title = @"音乐笔记";
}

- (IBAction)web:(id)sender {
    Web1ViewController * web = [[Web1ViewController alloc]init];
    [nagationController pushViewController:web animated:YES];
    web.navigationController.toolbarHidden  = YES;
    web.navigationItem.title = @"网络";
}

- (IBAction)addnote:(id)sender {
    AddNoteViewController * add = [[AddNoteViewController alloc]init];
    [nagationController pushViewController:add animated:YES];
    add.navigationController.toolbarHidden = YES;
    add.navigationItem.title = @"添加笔记";
}

- (IBAction)about:(id)sender {
    AboutViewController *about = [[AboutViewController alloc]init];
    [nagationController pushViewController:about animated:YES];
    about.navigationController.toolbarHidden = YES;
    about.navigationItem.title = @"关于";
}
@end
