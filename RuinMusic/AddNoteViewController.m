//
//  AddNoteViewController.m
//  RuinMusic
//
//  Created by hk on 14-12-11.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import "AddNoteViewController.h"
#import "LocalViewController.h"

@interface AddNoteViewController (){
    UIDatePicker *datePicker;
}

@end

@implementation AddNoteViewController

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
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/todo",NSHomeDirectory()];
    if (!self.todoDB) {
        self.todoDB = [[TodoDB alloc]initWithFileName:filePath];
        [self.todoDB read];
    }
    
    [self addDoneButton];
    
    self.desc.layer.borderWidth = 1.0f;
    self.desc.layer.cornerRadius = 10.0f;
    self.desc.backgroundColor = [UIColor clearColor];
    self.save.layer.cornerRadius = 10.0f;
    
    
    //date and picker 代理和初始化
    self.date.delegate =  self;
    [self.date setEnabled:NO];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 320, 320, 50)];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back3.jpg"]];
    [datePicker insertSubview:image atIndex:0];
    
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.todo) {
        self.sub.text = self.todo.subject;
        self.date.text = self.todo._date;
        self.desc.text = self.todo.todoDescription;
    }
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Save:(id)sender {
    if (!self.todo) {
        self.todo = [[Todo alloc]initWithTodo:self.sub.text andtodoDescription:self.desc.text andstr:@"a" anddate:self.date.text];
        [self.todoDB addToDo:self.todo];
        [self.todoDB write];
    }else {
        self.todo.subject = self.sub.text;
        self.todo.todoDescription = self.desc.text;
        self.todo.str = @"a";
        self.todo._date = self.date.text;
        [self.todoDB write];
    }
    //LocalViewController *local = [[LocalViewController alloc]init];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)datepicker:(id)sender {
    static BOOL flag = YES;
    if (flag) {
        
        [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
        [datePicker setHidden:NO];
        flag = NO;
    } else {
        //[self.view sendSubviewToBack:datePicker];
        [datePicker setHidden:YES];
        flag = YES;
    }
    
    
}

- (void)datePickerValueChanged {
    NSDateFormatter *fm = [[NSDateFormatter alloc]init];
    [fm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.date.text = [fm stringFromDate:datePicker.date];
}

//添加键盘Done键
- (void)addDoneButton {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    toolBar.items = @[flexibleSpace, doneItem];
    self.desc.inputAccessoryView = toolBar;
    self.sub.inputAccessoryView = toolBar;
    self.date.inputAccessoryView = toolBar;
}

- (void)dismissKeyboard:(id)sender {
    [self.desc resignFirstResponder];
    [self.sub resignFirstResponder];
    [self.date resignFirstResponder];
}




@end
