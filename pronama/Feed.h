//
//  Feed.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

#define FEED_URL @"http://pronama.wordpress.com/feed/"
#define FEED_XML_XPATH @"//rss/channel/item"

@interface Feed : NSObject

+ (NSMutableArray *)readData;

@end
