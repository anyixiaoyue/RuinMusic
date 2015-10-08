//
//  Todo.h
//  Note
//
//  Created by hk on 14-10-22.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Todo : NSObject<NSCopying, NSCoding>{
    NSString *subject;
    NSString *todoDescription;
    NSString *str;
    NSString *date;
}
@property (nonatomic, copy)NSString *subject;
@property (nonatomic, copy)NSString *todoDescription;
@property (nonatomic, copy)NSString *str;
@property (nonatomic, copy)NSString *_date;

- (id)initWithTodo:(NSString *)newsubject
andtodoDescription :(NSString *)newtodoDescription
andstr:(NSString  *)newstr
anddate:(NSString *)newdate;

- (NSComparisonResult) compareSubject : (id) element;

- (NSComparisonResult) compareStr:(id)element;

- (NSComparisonResult)compareDate:(id)element;

@end
