//
//  WebViewController.h
//  RuinMusic
//
//  Created by 肖乐 on 14-11-19.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfiled;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)button:(id)sender;
- (IBAction)refresh:(id)sender;

@end
