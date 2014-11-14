//
//  NSMutableArrayWithQueue.h
//  pronama
//
//  Created by 大翼 on 2012/10/08.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArrayWithQueue : NSMutableArray {
    NSMutableArray *queue;
    int count, max;
}

- (id)dequeue;
- (void)enqueue:(id)obj;
- (int)getCount;
- (int)getMaxCount;

@end
