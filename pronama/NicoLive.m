//
//  NicoLive.m
//  pronama
//
//  Created by 大翼 on 2012/10/07.
//
//

#import "NicoLive.h"

@implementation NicoLive

+ (NSArray *)readData {
    //プロ生の生放送履歴の解析
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([Setting getSessionKey] != nil || [Setting deepLogin]) {
        NSURL *url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:NICO_LIVE_GETPLAYER_STATUS_URL, PRONAMA_COMMUNITY_ID]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSError *error = nil;

        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];

        if (!error) {
            for (GDataXMLNode *item in [document nodesForXPath:@"//getplayerstatus/stream" error:&error]) {
                NSMutableDictionary *elements = [NSMutableDictionary dictionary];
                for (GDataXMLNode *child in [item children]) {
                    [elements setObject:[child stringValue] forKey:[child name]];
                }
                [array addObject:elements];
            }
        }
        
        document = nil;
    }
    
    return [[NSArray alloc] initWithArray:array];
}

+ (NSDictionary *)readData:(NSString *)community_id {
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    NSURL *url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:NICO_LIVE_GETPLAYER_STATUS_URL, community_id]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSError *error = nil;
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    
    if (!error) {
        for (GDataXMLNode *item in [document nodesForXPath:@"//getplayerstatus/stream" error:&error]) {
            NSMutableDictionary *elements = [NSMutableDictionary dictionary];
            for (GDataXMLNode *child in [item children]) {
                [elements setObject:[child stringValue] forKey:[child name]];
            }
            
            dictionary = [[NSDictionary alloc] initWithDictionary:elements];
        }
    }
    
    document = nil;
    error = nil;
    data = nil;
    url = nil;
    
    return dictionary;
}

+ (NSDictionary *)readLiveData:(NSString *)live_id {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSString *str = [[NSString alloc] initWithFormat:NICO_LIVE_DETAIL_STATUS_URL, live_id];
    NSURL *url = [[NSURL alloc] initWithString:str];
    NSURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    NSURLResponse *res = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    
    if (!error) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
        
        if (!error) {
            for (GDataXMLNode *item in [document nodesForXPath:@"//getplayerstatus/ms" error:&error]) {
                for (GDataXMLNode *child in [item children]) {
                    [dictionary setValue:[child stringValue] forKey:[child name]];
                }
            }
        }
        
        document = nil;
    }

    return dictionary;
}

@end
