//
//  TodoDB.m
//  Note
//
//  Created by hk on 14-10-30.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import "TodoDB.h"

@implementation TodoDB


-(id)initWithFileName:(NSString *)aFileName
{
    if (self = [super init]) {
    self.fileName = [[NSString alloc]initWithString:aFileName];
    self.todoList = [[TodoList alloc]init];
    }
    return self;
}

-(void)addToDo:(Todo *)aToDo
{
    [self.todoList addToDo:aToDo];
    NSLog(@"22");
}

-(void)write
{
    [NSKeyedArchiver archiveRootObject:self.todoList toFile:self.fileName];
}

-(NSMutableArray*)read;
{
    TodoList* list = [NSKeyedUnarchiver unarchiveObjectWithFile:self.fileName];
    if (list != nil) {
        self.todoList = list;
    }
    return self.todoList.todolistArray;
}

//copy
- (id)copyWithZone:(NSZone *)zone
{
	TodoDB* db=[[TodoDB allocWithZone:zone] initWithFileName:self.fileName];
	[db setTodoList:self.todoList];
	return db;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.fileName forKey:@"FileName"];
	[aCoder encodeObject:self.todoList forKey:@"todolist"];
}

//解档
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self=[super init])
	{
		self.fileName=[aDecoder decodeObjectForKey:@"FileName"] ;
		self.todoList=[aDecoder decodeObjectForKey:@"todolist"];
	}
	return self;
}

-(Todo*)todoAtIndex:(NSUInteger)aIndex;
{
    return [self.todoList todoAtIndex:aIndex];
}

-(void)insertTodo:(Todo*)aTodo atIndex:(NSUInteger)aIndex;
{
    [self.todoList insertToDo:aTodo atIndex:aIndex];
}

-(NSUInteger)indexOfToDo:(Todo*)aToDo;
{
    return [self.todoList indexOfToDo:aToDo];
}

-(NSUInteger)count;
{
    return [self.todoList count];
}

-(void)removeToDo:(NSUInteger)aIndex;
{
    [self.todoList removeToDo:aIndex];
}

-(void)removeAll;
{
    [self.todoList removeAll];
}

-(void)sortStr;
{
    [self.todoList sortStr];
}

-(void)sortSubject;
{
    [self.todoList sortSubject];
}

-(void)sortDate;
{
    [self.todoList sortDate];
}

-(NSString*)description
{
    NSString* temp = [NSString stringWithFormat:@"FileName: %@, contents:%@",self.fileName, self.todoList];
    return temp;
}

@end
