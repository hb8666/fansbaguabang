//
//  NSString+URLEncoding.h
//  beijing-city
//
//  Created by 绍轩 孙 on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef beijing_city_NSString_URLEncoding_h
#define beijing_city_NSString_URLEncoding_h

@interface NSString (URLEncodingAdditions)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
@end


#endif
