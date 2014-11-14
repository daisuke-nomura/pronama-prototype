//
//  NicoLive.h
//  pronama
//
//  Created by 大翼 on 2012/10/07.
//
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "Setting.h"

#define PRONAMA_COMMUNITY_ID @"co9320"
#define NICO_LIVE_GETPLAYER_STATUS_URL @"http://watch.live.nicovideo.jp/api/getplayerstatus?v=%@"
#define NICO_LIVE_DETAIL_STATUS_URL @"http://live.nicovideo.jp/api/getplayerstatus?v=%@"

@interface NicoLive : NSObject

+ (NSArray *)readData;
+ (NSDictionary *)readData:(NSString *)community_id;
+ (NSDictionary *)readLiveData:(NSString *)live_id;

@end
