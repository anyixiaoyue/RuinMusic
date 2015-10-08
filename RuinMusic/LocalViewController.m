//
//  LocalViewController.m
//  RuinMusic
//
//  Created by hk on 14-12-11.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import "LocalViewController.h"
#import "AddNoteViewController.h"
#import "TestAppDelegate.h"

@interface LocalViewController (){
    UIRefreshControl *refresh;
    NSMutableArray *mutableArray;
    NSMutableArray *array;
    NSMutableArray *add;
}

@end

@implementation LocalViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //沙盒路径
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/todo",NSHomeDirectory()];
    self.todoDB = [[TodoDB alloc]initWithFileName:filePath];
    [self.todoDB read];
    
    // 刷新控制
    refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshValue) forControlEvents:UIControlEventValueChanged];
    mutableArray = [[NSMutableArray alloc]initWithArray:self.todoDB.todoList.todolistArray];
    [self.tableView addSubview:refresh];
    
    //searchbar初始化
    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.tableView.tableHeaderView = search;
    search.delegate = self;
    search.showsCancelButton = YES;
    
    //背景图片
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back1.jpg"]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//下拉刷新
- (void)refreshValue{
    [self performSelector:@selector(endrefresh) withObject:nil afterDelay:2.0f];
}

- (void)endrefresh{
    [refresh endRefreshing];
    [self.todoDB read];
    [mutableArray setArray:self.todoDB.todoList.todolistArray];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [mutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"Cell" owner:self options:nil]lastObject];
    }
    Todo *tmptodo = [mutableArray objectAtIndex:indexPath.row];
    
    UILabel *label1 = (UILabel *)[cell viewWithTag:100];
    UILabel *label2 = (UILabel *)[cell viewWithTag:101];
    UILabel *label3 = (UILabel *)[cell viewWithTag:102];
    
    label1.text = tmptodo.subject;
    label2.text = tmptodo._date;
    label3.text = tmptodo.todoDescription;
    
    cell.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    
    return cell;
    [self.tableView reloadData];
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
//行删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.todoDB removeToDo:[self.todoDB indexOfToDo:[mutableArray objectAtIndex:indexPath.row]]];
        [mutableArray removeObjectAtIndex:indexPath.row];
        [self.todoDB write];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}



// Override to support rearranging the table view.
//行移动
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddNoteViewController *detailViewController = [[AddNoteViewController alloc] init];
    detailViewController.todo = [self.todoDB.todoList.todolistArray objectAtIndex:indexPath.row];
    detailViewController.todoDB = self.todoDB;
    
    TestAppDelegate *appdelegate = (TestAppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nagationController = (UINavigationController *)appdelegate.window.rootViewController;
    [nagationController pushViewController:detailViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark seachbar查找
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [array setArray:add];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [mutableArray removeAllObjects];
    if ([searchText length] > 0) {
        for (Todo *obj in self.todoDB.todoList.todolistArray) {
            if ([obj.subject hasPrefix:searchText]) {
                [mutableArray addObject:obj];
            }
        }
    }else {
        [mutableArray setArray:self.todoDB.todoList.todolistArray];
    }
    [self.tableView reloadData];
}


@end
