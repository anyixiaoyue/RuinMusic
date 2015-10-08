//
//  TodoDB.h
//  Note
//
//  Created by hk on 14-10-30.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoList.h"

@interface TodoDB : NSObject<NSCopying,NSCoding>

@property(nonatomic, copy)NSString* fileName;
@property(nonatomic, retain)TodoList* todoList;

-(id)initWithFileName:(NSString*)aFileName;
-(void)addToDo:(Todo*)aToDo;
-(void)write;
-(NSMutableArray*)read;
-(Todo*)todoAtIndex:(NSUInteger)aIndex;
-(void)insertTodo:(Todo*)aTodo atIndex:(NSUInteger)aIndex;
-(NSUInteger)indexOfToDo:(Todo*)aToDo;
-(NSUInteger)count;
-(void)removeToDo:(NSUInteger)aIndex;
-(void)removeAll;
-(void)sortStr;
-(void)sortSubject;
-(void)sortDate;
@end
