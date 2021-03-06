//
//  MPRewardedAdManager+Testing.m
//
//  Copyright 2018-2021 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

#import "MPRewardedAdManager+Testing.h"
#import "MPFullscreenAdAdapterMock.h"

@interface MPRewardedAdManager() <
    MPAdAdapterFullscreenEventDelegate,
    MPAdAdapterRewardEventDelegate
>

// Properties and methods from MPRewardedVideoAdManager redeclared here so we can access these private items.
@property (nonatomic, strong) MPAdConfiguration *configuration;
@property (nonatomic, assign) BOOL ready;
@property (nonatomic, assign) BOOL playedAd;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"

@implementation MPRewardedAdManager (Testing)
@dynamic communicator;
@dynamic adapter;

- (void)loadWithConfiguration:(MPAdConfiguration *)config {
    MPFullscreenAdAdapterMock *mock = [MPFullscreenAdAdapterMock new];
    mock.configuration = config;
    mock.adapterDelegate = self;

    self.adapter = mock;
    self.configuration = config;
    self.ready = YES;
    self.playedAd = NO;
}

@end

#pragma clang diagnostic pop
