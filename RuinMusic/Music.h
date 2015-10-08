//
//  Music.h
//  RuinMusic
//
//  Created by hk on 14-12-10.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject{
    NSString *name;
    NSString *type;
}
@property(retain, nonatomic)NSString *name;
@property(retain, nonatomic)NSString *type;

- (id)initWithName:(NSString *)_name andType:(NSString *)_type;

@end
