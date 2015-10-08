//
//  Web1ViewController.m
//  RuinMusic
//
//  Created by hk on 14-12-16.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import "Web1ViewController.h"

@interface Web1ViewController ()

@end

@implementation Web1ViewController

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
    //设置代理
    self.webview.delegate = self;
    //默认加载
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://music.baidu.com"]]];
    
    [self addDoneButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.webtext resignFirstResponder];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"yes webview");
    return YES;
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"load start");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"ending load");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息" message:@"网络链接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

//添加键盘Done键
- (void)addDoneButton {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    toolBar.items = @[flexibleSpace, doneItem];
    self.webtext.inputAccessoryView = toolBar;
}

- (void)dismissKeyboard:(id)sender {
    [self.webtext resignFirstResponder];
}

// 刷新
- (IBAction)refresh:(id)sender {
     [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://music.baidu.com"]]];
}

//前往网址
- (IBAction)GO:(id)sender {
    NSString *str = [NSString stringWithFormat:@"http://%@", self.webtext.text];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}
@end
