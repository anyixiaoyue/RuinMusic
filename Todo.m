//
//  Todo.m
//  Note
//
//  Created by hk on 14-10-22.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import "Todo.h"

@implementation Todo
@synthesize subject;
@synthesize todoDescription;
@synthesize str  = str;
@synthesize _date = date;

- (id)initWithTodo:(NSString *)newsubject andtodoDescription:(NSString *)newtodoDescription andstr:(NSString*)newstr anddate:(NSString *)newdate{
    if (self = [super init]) {
        self.subject = newsubject;
        self.todoDescription = newtodoDescription;
        self.str = newstr;
        self._date = newdate;
    }
    return self;
}

- (NSComparisonResult)compareSubject:(id)element{
    return [subject compare:[element subject]];
}

- (NSComparisonResult)compareStr:(id)element{
    return [str compare:[element str]];
}

- (NSComparisonResult)compareDate:(id)element{
    return [date compare:[element _date]];
}

- (id)copyWithZone:(NSZone *)zone{
    Todo *newTodo = [[Todo allocWithZone:zone]initWithTodo:subject andtodoDescription:todoDescription andstr:str anddate:date];
    return newTodo;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:subject forKey:@"subject"];
    [aCoder encodeObject:todoDescription forKey:@"todoDescription"];
    [aCoder encodeObject:str forKey:@"str"];
    [aCoder encodeObject:date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        subject = [aDecoder decodeObjectForKey:@"subject"];
        todoDescription = [aDecoder decodeObjectForKey:@"todoDescription"];
        str = [aDecoder decodeObjectForKey:@"str"];
        date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

- (NSString *)description{
    NSString *tmp = [NSString stringWithFormat:@"subject : %@\ndescription :%@\nstr : %@\ndate : %@\n====================",subject,todoDescription,str,date];
    return tmp;
}
@end
