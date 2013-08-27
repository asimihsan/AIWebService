// =============================================================================
//    WSDLSchema.m
//
//    Project: AIWebService
// =============================================================================
//    Created by Asim Ihsan on 2013-08-26.
//    Version 0.1
//
//    Copyright 2013 Asim Ihsan
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
// =============================================================================

#import "WSDLSchema.h"
#import "WSDLElement.h"
#import "ConciseKit/ConciseKit.h"

@implementation WSDLSchema

- (NSString *)description
{
    return $str(@"{WSDLSchema. targetNamespace=%@, elements=%@}",
                self.targetNamespace, self.elements);
}

- (id)init:(NSString *)targetNamespace
namespaces:(NSDictionary *)namespaces
{
    if (!(self = [super init]))
        return nil;
    self.targetNamespace = targetNamespace;
    self.namespaces = namespaces;
    self.elements = [[NSMutableDictionary alloc] init];
    return self;
}

@end
