//
//  NSTimeSpan.m
//  pronama
//
//  Created by 大翼 on 2012/10/08.
//
//

#import "NSTimeSpan.h"

@implementation NSTimeSpan

- (id)init {
    if (self)
        self = [super init];
    
    time = 0;
    
    return self;
}

- (void)dealloc {
}

- (void)setHours:(long)len {
    time = len * 60 * 24;
}

- (void)setMinutes:(long)len {
    time *= len * 60;
}

- (void)setSeconds:(long)len {
    time = len;
}

- (ushort)getHours {
    return (ushort)(time / 60 / 24);
}

- (ushort)getMinutes {
    return (ushort)(time / 60);
}

- (ushort)getSeconds {
    return (ushort)time;
}

@end
