//
//  ViewController.m
//  Coursera
//
//  Created by Kostya on 06.10.2017.
//  Copyright © 2017 SKS. All rights reserved.
//
//task~1

@import CoreLocation;
@import MapKit;

#import "ViewController.h"

@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapKitView;
@property (weak, nonatomic) IBOutlet UILabel *geocodeLabel;
@property (strong,nonatomic) CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet UIImageView *pinIcon;
@property (assign,nonatomic) BOOL lookingUp;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.geocoder = [[CLGeocoder alloc]init];
    self.geocodeLabel.text = nil;
    self.geocodeLabel.alpha = 0.5;
    self.lookingUp = NO;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self executeTheLookUp];
}
- (CLLocationCoordinate2D)locatCentreMV
{
    CGPoint centreOfPin = CGPointMake(CGRectGetMidX(self.pinIcon.bounds),CGRectGetMidY(self.pinIcon.bounds));
    return [self.mapKitView convertPoint:centreOfPin toCoordinateFromView:self.pinIcon];
}

-(void)executeTheLookUp
{
    if(self.lookingUp == NO)
    {
        self.lookingUp = YES;
        CLLocationCoordinate2D coord = [self locatCentreMV];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
   
        [self startReverseGeocodeLocation:loc];
    }
}

- (void)startReverseGeocodeLocation:(CLLocation *)loction
{
    [self.geocoder reverseGeocodeLocation:loction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error)
        {
            NSLog(@"error");
            return;
        }
        NSMutableSet *mappedPlaceD = [NSMutableSet new];
        for(CLPlacemark *p in placemarks)
        {
            if(p.name != nil)
                [mappedPlaceD addObject:p.name];
            if(p.administrativeArea != nil)
                [mappedPlaceD addObject:p.administrativeArea];
            if(p.country != nil)
                [mappedPlaceD addObject:p.country];
            [mappedPlaceD addObjectsFromArray:p.areasOfInterest];
        }
        self.geocodeLabel.text = [[mappedPlaceD allObjects] componentsJoinedByString:@"\n"];
        self.geocodeLabel.alpha = 1.0;
        self.lookingUp =  NO;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
