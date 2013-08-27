// =============================================================================
//    WSDLElement.h
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

#import <Foundation/Foundation.h>

@interface WSDLElement : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) Class type;
@property (nonatomic, copy) NSString *typeNamespaceUri;
@property (nonatomic, copy) NSString *minOccurs;
@property (nonatomic, copy) NSString *maxOccurs;
@property (nonatomic, retain) NSString *targetNamespace;
@property (nonatomic, retain) NSDictionary *namespaces;
@property (nonatomic, retain) NSMutableDictionary *childElements;

-      (id)init:(NSString *)name
targetNamespace:(NSString *)targetNamespace
     namespaces:(NSDictionary *)namespaces;

-      (id)init:(NSString *)name
           type:(NSString *)type
      minOccurs:(NSString *)minOccurs
      maxOccurs:(NSString *)maxOccurs
targetNamespace:(NSString *)targetNamespace
     namespaces:(NSDictionary *)namespaces;


@end
