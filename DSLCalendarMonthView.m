/*
 DSLCalendarMonthView.m
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */



#import "DSLCalendarDayView.h"
#import "DSLCalendarMonthView.h"
#import "DSLCalendarRange.h"
#import "NSDate+DSLCalendarView.h"


@interface DSLCalendarMonthView ()

@property (nonatomic, strong) NSMutableDictionary *dayViewsDictionary;

@end


@implementation DSLCalendarMonthView {
    
    CGFloat _dayViewHeight;
    __strong Class _dayViewClass;
    int *count;
    int *i;
    int *nextcount;
    NSString *previouskey;
    NSString *previousdata;
    NSString *key1;
    NSInteger*navigationCount;
  
    
}


#pragma mark - Memory management



#pragma mark - Initialisation

// Designated initialiser
- (id)initWithMonth:(NSDateComponents*)month width:(CGFloat)width dayViewClass:(Class)dayViewClass dayViewHeight:(CGFloat)dayViewHeight WithEvents:(NSDictionary *)EventsInfo{
    
    
    
    self = [super initWithFrame:CGRectMake(0, 0, width, dayViewHeight)];
    if (self != nil) {

        _month = [month copy];
        _dayViewHeight = dayViewHeight;
        _dayViewsDictionary = [[NSMutableDictionary alloc] init];
        _dayViewClass = dayViewClass;
        //NSLog(@"Month View Called Here::-%@",EventsInfo);
        
        [self createDayViewsWithEvents:EventsInfo];
    }

    return self;
}



- (void)createDayViewsWithEvents:(NSDictionary*)Events {
    
    
    
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"calenderthemecolordetail"];
    UIButton*btnJobDetail;
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        NSInteger const numberOfDaysPerWeek = 7;
        
        NSDateComponents *day = [[NSDateComponents alloc] init];
        day.calendar = self.month.calendar;
        day.day = 1;
        day.month = self.month.month;
        day.year = self.month.year;
        
        NSDate *firstDate = [day.calendar dateFromComponents:day];
        day = [firstDate dslCalendarView_dayWithCalendar:self.month.calendar];
        

        NSInteger numberOfDaysInMonth = [day.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[day date]].length;
        

        NSInteger startColumn = day.weekday - day.calendar.firstWeekday;
        if (startColumn < 0) {
            startColumn += numberOfDaysPerWeek;
        }

        NSArray *columnWidths = [self calculateColumnWidthsForColumnCount:numberOfDaysPerWeek];
        CGPoint nextDayViewOrigin = CGPointZero;
        for (NSInteger column = 0; column < startColumn; column++) {
            nextDayViewOrigin.x += [[columnWidths objectAtIndex:column] floatValue];
        }

        do {
            for (NSInteger column = startColumn; column < numberOfDaysPerWeek; column++) {
                if (day.month == self.month.month) {
                    CGRect dayFrame = CGRectZero;
                    dayFrame.origin = nextDayViewOrigin;
                    dayFrame.size.width = [[columnWidths objectAtIndex:column] floatValue];
                    dayFrame.size.height = _dayViewHeight;
                    
                    DSLCalendarDayView *dayView = [[DSLCalendarDayView alloc] initWithFrame:dayFrame];
                    dayView.day = day;
                    
                      NSLog(@"%@",Events);
                    for (NSString *key in [Events allKeys]) {
                        NSLog(@"%@",key);
                        
                        if ([key isEqualToString:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)day.day,(long)day.month,(long)day.year]]) {
                            dayView.Event=[NSString stringWithFormat:@"%@",[Events valueForKey:key]];
                            dayView.backgroundColor=[UIColor redColor];
                            dayView.selectionState=DSLCalendarDayViewEventSelection;
                            
                            
                        }
                      
                        
                    }
                    
                  //  NSLog(@"%@",dayView.day);
            
                    switch (column) {
                        case 0:
                            dayView.positionInWeek = DSLCalendarDayViewStartOfWeek;
                            break;
                            
                        case numberOfDaysPerWeek - 1:
                            dayView.positionInWeek = DSLCalendarDayViewEndOfWeek;
                            break;
                            
                        default:
                            dayView.positionInWeek = DSLCalendarDayViewMidWeek;
                            break;
                    }
                    
                    [self.dayViewsDictionary setObject:dayView forKey:[self dayViewKeyForDay:day]];
                    [self addSubview:dayView];
                }
                
                day.day = day.day + 1;
                
                nextDayViewOrigin.x += [[columnWidths objectAtIndex:column] floatValue];
            }
            
            nextDayViewOrigin.x = 0;
            nextDayViewOrigin.y += _dayViewHeight;
            startColumn = 0;
        } while (day.day <= numberOfDaysInMonth);
        
        CGRect fullFrame = CGRectZero;
        fullFrame.size.height = nextDayViewOrigin.y;
        for (NSNumber *width in columnWidths) {
            fullFrame.size.width += width.floatValue;
        }
        self.frame = fullFrame;
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        
        
        NSInteger const numberOfDaysPerWeek = 7;
        
        NSDateComponents *day = [[NSDateComponents alloc] init];
        day.calendar = self.month.calendar;
        day.day = 1;
        day.month = self.month.month;
        day.year = self.month.year;
            
        
        NSDate *firstDate = [day.calendar dateFromComponents:day];
        day = [firstDate dslCalendarView_dayWithCalendar:self.month.calendar];
        

        NSInteger numberOfDaysInMonth = [day.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[day date]].length;
        

        NSInteger startColumn = day.weekday - day.calendar.firstWeekday;
        if (startColumn < 0) {
            startColumn += numberOfDaysPerWeek;
        }

        NSArray *columnWidths = [self calculateColumnWidthsForColumnCount:numberOfDaysPerWeek];
        CGPoint nextDayViewOrigin = CGPointZero;
        for (NSInteger column = 0; column < startColumn; column++) {
            nextDayViewOrigin.x += [[columnWidths objectAtIndex:column] floatValue];
        }

        do {
            for (NSInteger column = startColumn; column < numberOfDaysPerWeek; column++) {
                if (day.month == self.month.month) {
                    
                    
                    
                    CGRect dayFrame = CGRectZero;
                    dayFrame.origin = nextDayViewOrigin;
                    dayFrame.size.width = [[columnWidths objectAtIndex:column] floatValue];
                    dayFrame.size.height = _dayViewHeight;
                    
                    DSLCalendarDayView *dayView = [[DSLCalendarDayView alloc] initWithFrame:dayFrame];
                    dayView.day = day;
                    
                    NSMutableArray* colorArray = [[NSMutableArray alloc] init];
                    NSMutableArray* colorArray2 = [[NSMutableArray alloc] init];
                    if ( count == 0)
                    {
                        
                    }

                    else
                    {
                        colorArray =  colorArray2;
                    }
                    
                    btnJobDetail=[UIButton buttonWithType:UIButtonTypeCustom];
                    btnJobDetail.frame=CGRectMake(2, 2, 18, 18);

                    [btnJobDetail setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
                    [btnJobDetail addTarget:self action:@selector(jobDetail:) forControlEvents:UIControlEventTouchUpInside];
                    
              
               
         for (NSString *key in [Events allKeys])
             
                    {
                        
                        NSMutableDictionary *Eventsdic1  =  [key substringWithRange:NSMakeRange(0,8)];
                        NSMutableDictionary *Eventsdic2  =  [key substringWithRange:NSMakeRange(0,9)];
                        NSString *prefixdata = Eventsdic1;
                        NSString *prefixdata2= Eventsdic2;
                    
                        if ([prefixdata isEqualToString:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)day.day,(long)day.month,(long)day.year]]) {
                            dayView.Event=[NSString stringWithFormat:@"%@",[Events valueForKey:key]];
                
                            dayView.backgroundColor=[UIColor orangeColor];
                            dayView.selectionState=DSLCalendarDayViewEventSelection;
                            
                            
                        }
                        
                        if ([prefixdata2 isEqualToString:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)day.day,(long)day.month,(long)day.year]]) {
                            dayView.Event=[NSString stringWithFormat:@"%@",[Events valueForKey:key]];
                
                            dayView.backgroundColor=[UIColor orangeColor];
                            dayView.selectionState=DSLCalendarDayViewEventSelection;
                            
                            
                        }
                      
                        
                    }
                      
                        
                         
               
            
                    switch (column) {
                        case 0:
                            dayView.positionInWeek = DSLCalendarDayViewStartOfWeek;
                            break;
                            
                        case numberOfDaysPerWeek - 1:
                            dayView.positionInWeek = DSLCalendarDayViewEndOfWeek;
                            break;
                            
                        default:
                            dayView.positionInWeek = DSLCalendarDayViewMidWeek;
                            break;
                    }
                    
                    [self.dayViewsDictionary setObject:dayView forKey:[self dayViewKeyForDay:day]];
                    [self addSubview:dayView];
                }
                
                day.day = day.day + 1;
                
                nextDayViewOrigin.x += [[columnWidths objectAtIndex:column] floatValue];
            }
            
            nextDayViewOrigin.x = 0;
            nextDayViewOrigin.y += _dayViewHeight;
            startColumn = 0;
        } while (day.day <= numberOfDaysInMonth);
        
        CGRect fullFrame = CGRectZero;
        fullFrame.size.height = nextDayViewOrigin.y;
        for (NSNumber *width in columnWidths) {
            fullFrame.size.width += width.floatValue;
        }
        self.frame = fullFrame;
    }
    
    }


-(void)jobDetail:(UIButton *)sender
{
    UIEvent* event;
//    [self createDayViewsWithEvents:(NSDictionary *)event];

    
}

- (void)updateDaySelectionStatesForRange:(DSLCalendarRange*)range andEvents:(NSDictionary *)Events
{
    
    for (DSLCalendarDayView *dayView in self.dayViews) {
        if ([range containsDate:dayView.dayAsDate]) {
            BOOL isStartOfRange = [range.startDay isEqual:dayView.day];
            BOOL isEndOfRange = [range.endDay isEqual:dayView.day];
            
            if (isStartOfRange && isEndOfRange) {
                dayView.selectionState = DSLCalendarDayViewWholeSelection;
            }
            else if (isStartOfRange) {
                dayView.selectionState = DSLCalendarDayViewStartOfSelection;
            }
            else if (isEndOfRange) {
                dayView.selectionState = DSLCalendarDayViewEndOfSelection;
            }
            else {
                dayView.selectionState = DSLCalendarDayViewWithinSelection;
            }
        }
        
        else {
            
 
            NSDateComponents *day = [[NSDateComponents alloc] init];
            day.calendar = self.month.calendar;
            day.day = 1;
            day.month = self.month.month;
            day.year = self.month.year;
            
            NSDate *firstDate = [day.calendar dateFromComponents:day];
            day = [firstDate dslCalendarView_dayWithCalendar:self.month.calendar];
            
            
               dayView.selectionState = DSLCalendarDayViewNotSelected;
            
          
            
      
            for (NSString *key in [Events allKeys]) {
                
                NSLog(@"DAteMAtch-->%@",key);
                NSLog(@"%d/%d/%d",(int)day.day,(int)day.month,(int)day.year);
                
                if ([key isEqualToString:[NSString stringWithFormat:@"%d/%d/%d",(int)day.day,(int)day.month,(int)day.year]]) {
           
                    dayView.selectionState=DSLCalendarDayViewEventSelection;
                    
                  
                    
                    
                }
           
            }
            
          
            
        }
    }
}




- (NSArray*)calculateColumnWidthsForColumnCount:(NSInteger)columnCount {
    static NSCache *widthsCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        widthsCache = [[NSCache alloc] init];
    });
    
    NSMutableArray *columnWidths = [widthsCache objectForKey:@(columnCount)];
    if (columnWidths == nil) {
        CGFloat width = floorf(self.bounds.size.width / (CGFloat)columnCount);
        
        columnWidths = [[NSMutableArray alloc] initWithCapacity:columnCount];
        for (NSInteger column = 0; column < columnCount; column++) {
            [columnWidths addObject:@(width)];
        }
        
        CGFloat remainder = self.bounds.size.width - (width * columnCount);
        CGFloat padding = 1;
        if (remainder > columnCount) {
            padding = ceilf(remainder / (CGFloat)columnCount);
        }
        
        for (NSInteger column = 0; column < columnCount; column++) {
            [columnWidths replaceObjectAtIndex:column withObject:@(width + padding)];
            
            remainder -= padding;
            if (remainder < 1) {
                break;
            }
        }
        
        [widthsCache setObject:columnWidths forKey:@(columnCount)];
    }
    
    return columnWidths;
}


#pragma mark - Properties

- (NSSet*)dayViews {
    return [NSSet setWithArray:self.dayViewsDictionary.allValues];
}



- (NSString*)dayViewKeyForDay:(NSDateComponents*)day
{
    
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    });

    return [formatter stringFromDate:[day date]];
}

- (DSLCalendarDayView*)dayViewForDay:(NSDateComponents*)day {
    
    return [self.dayViewsDictionary objectForKey:[self dayViewKeyForDay:day]];
}

@end
