//
//  Web1ViewController.h
//  RuinMusic
//
//  Created by hk on 14-12-16.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Web1ViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate>
- (IBAction)refresh:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *webtext;
- (IBAction)GO:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webview;


@end
