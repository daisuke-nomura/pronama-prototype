//
//  NicoVideo.m
//  pronama
//
//  Created by 大翼 on 2012/10/07.
//
//

#import "NicoVideo.h"

@implementation NicoVideo

+ (NSMutableArray *)readMylistData:(NSString *)link {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSURL *url = [[NSURL alloc] initWithString:link];
    NSError *error = nil;
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    
    if (!error) {    
        for (GDataXMLNode *item in [document nodesForXPath:@"//rss/channel/item" error:&error]) {
            NSMutableDictionary *elements = [NSMutableDictionary dictionary];
            for (GDataXMLNode *child in [item children]) {
                [elements setObject:[child stringValue] forKey:[child name]];
            }
            [array addObject:elements];
        }
    }
    
    document = nil;
    url = nil;
    
    return array;
}

+ (NSMutableArray *)readVideoData:(NSMutableArray *)video_array {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:VIDEO_ARRAY_URL, [Setting getSessionKey]];
    
    for (int i = 0; i < [video_array count]; i++) {
        NSString *video_id = [[video_array objectAtIndex:i] valueForKey:@"link"];
        NSString *video = nil;
        
        NSRange match = [video_id rangeOfString:@"sm[0-9]+|nm[0-9]+¥so[0-9]+" options:NSRegularExpressionSearch];
        if (match.location != NSNotFound) {
            video = [video_id substringWithRange:match];
            [str appendFormat:@"%@,", video];
        }
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSURL *url = [[NSURL alloc] initWithString:str];
    NSError *error = nil;
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    
    for (GDataXMLNode *item in [document nodesForXPath:@"//video_info" error:&error]) {
        NSMutableDictionary *elements = [NSMutableDictionary dictionary];
        
        for (GDataXMLNode *child in [item children]) {
            NSMutableDictionary *elements2 = [NSMutableDictionary dictionary];
            
            if (![[child name] isEqualToString:@"tags"]) {
                for (GDataXMLNode *child2 in [child children]) {
                    [elements2 setObject:[child2 stringValue] forKey:[child2 name]];
                }
            }
            else {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (GDataXMLNode *child2 in [child children]) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    
                    for (GDataXMLNode *child3 in [child2 children]) {
                        [dic setValue:[child3 stringValue] forKey:[child3 name]];
                    }
                    
                    [array addObject:dic];
                }
                
                [elements2 setObject:array forKey:@"tag_info"];
            }
            
            [elements setObject:elements2 forKey:[child name]];
        }
        
        [array addObject:elements];
    }
    
    return array;
}

+ (NSMutableArray *)readMylistRSS {
    NSURL *url = [[NSURL alloc] initWithString:MYLIST_RSS_URL];
    NSError *error = nil;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    
    if (!error) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
        
        if (!error) {
            for (GDataXMLNode *item in [document nodesForXPath:@"//lists/list" error:&error]) {
                NSMutableDictionary *elements = [NSMutableDictionary dictionary];
                for (GDataXMLNode *child in [item children]) {
                    [elements setObject:[child stringValue] forKey:[child name]];
                }
                [array addObject:elements];
            }
        }
        
        document = nil;
    }
    
    data = nil;
    error = nil;
    url = nil;
    
    return array;
}

@end
