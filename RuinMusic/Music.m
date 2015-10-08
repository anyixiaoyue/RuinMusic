//
//  Music.m
//  RuinMusic
//
//  Created by hk on 14-12-10.
//  Copyright (c) 2014年 anyixiaoyue. All rights reserved.
//

#import "Music.h"

@implementation Music
@synthesize name,type;

- (id)initWithName:(NSString *)_name andType:(NSString *)_type{
    if (self = [super init]) {
        self.name = _name;
        self.type = _type;
    }
    return self;
}

@end
