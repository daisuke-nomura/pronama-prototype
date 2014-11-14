//
//  Feed.m
//  pronama
//
//  Created by 大翼 野村 on 12/01/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Feed.h"

@implementation Feed

+ (NSMutableArray *)readData {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSURL *url = [[NSURL alloc] initWithString:FEED_URL];
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    
    if (!error) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    
        if (!error) {
            for (GDataXMLNode *item in [document nodesForXPath:FEED_XML_XPATH error:&error]) {
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
