//
//  Processor.m
//  Winterpix
//
//  Created by SSC on 2014/04/12.
//  Copyright (c) 2014年 SSC. All rights reserved.
//

#import "Processor.h"

@implementation Processor

static Processor* sharedProcessor = nil;

+ (Processor*)instance {
	@synchronized(self) {
		if (sharedProcessor == nil) {
			sharedProcessor = [[self alloc] init];
		}
	}
	return sharedProcessor;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedProcessor == nil) {
			sharedProcessor = [super allocWithZone:zone];
			return sharedProcessor;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone*)zone {
	return self;  // シングルトン状態を保持するため何もせず self を返す
}



@end
