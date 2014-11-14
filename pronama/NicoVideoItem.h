//
//  NicoVideoItem.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NicoVideoItem : NSObject {
    NSString *videoTitle, *videoLink, *videoType;
    NSData *videoDescription;
    int viewCount, commentCount, mylistCount;
}

@end
