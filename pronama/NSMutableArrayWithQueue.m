//
//  NSMutableArrayWithQueue.m
//  pronama
//
//  Created by 大翼 on 2012/10/08.
//
//

#import "NSMutableArrayWithQueue.h"

@implementation NSMutableArrayWithQueue

- (id)init {
    if (self)
        self = [super init];
    
    queue = [[NSMutableArray alloc] init];
    count = 0;
    
    return self;
}

- (id)initWithCapacity:(NSUInteger)numItems {
    if (self)
        self = [super init];
    
    queue = [[NSMutableArray alloc] initWithCapacity:numItems];
    count = 0;
    max = numItems;
    
    return self;
}

- (void)dealloc {
    queue = nil;
}

- (id)dequeue {
    id res = nil;
    
    if (count > 0) {
        res = [queue objectAtIndex:count - 1];
        [queue removeObjectAtIndex:count - 1];
        count--;
    }
    
    return res;
}

- (void)enqueue:(id)obj {
    [queue insertObject:obj atIndex:0];
    count++;
}

- (int)getCount {
    return count;
}

- (int)getMaxCount {
    return max;
}

@end
