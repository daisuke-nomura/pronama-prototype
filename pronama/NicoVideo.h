//
//  NicoVideo.h
//  pronama
//
//  Created by 大翼 on 2012/10/07.
//
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "Setting.h"

#define VIDEO_ARRAY_URL @"http://i.nicovideo.jp/V3/video.array?sid=%@&v="
#define MYLIST_RSS_URL @"http://pronama.jp/mylist.xml"

@interface NicoVideo : NSObject

+ (NSMutableArray *)readMylistData:(NSString *)link;
+ (NSMutableArray *)readVideoData:(NSMutableArray *)video_id;
+ (NSMutableArray *)readMylistRSS;

@end
