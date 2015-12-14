//
//  KMLocationManager.h
//  3GSW
//
//  Created by MissionHealth on 15/10/8.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^KMGeocodeCompletionHandler)(NSString *address);


@interface KMLocationManager : NSObject

/// 存放解析好的地址
@property (nonatomic, copy, readonly) NSString *address;

+ (instancetype)locationManager;
- (void)startLocationWithLocation:(CLLocation *)location
                      resultBlock:(KMGeocodeCompletionHandler)addressBlock;

@end
