//
//  NSTimeSpan.h
//  pronama
//
//  Created by 大翼 on 2012/10/08.
//
//

#import <Foundation/Foundation.h>

@interface NSTimeSpan : NSObject {
    long time;
}

- (void)setHours:(long)len;
- (void)setMinutes:(long)len;
- (void)setSeconds:(long)len;
- (ushort)getHours;
- (ushort)getMinutes;
- (ushort)getSeconds;

@end
