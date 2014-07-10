//
//  DHHTMLStringParser.swift
//  DHHTMLStringParser
//
//  Created by Jesse on 2014. 7. 7..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

import Foundation

class DHHTMLStringParser: NSObject, NSXMLParserDelegate {
    class var instance: DHHTMLStringParser {
        struct Singleton {
            static let instance = DHHTMLStringParser()
        }

        return Singleton.instance
    }
    
    func documentWithHTMLString(HTMLString: String) -> TFHpple {
        var item = HTMLString as NSString
        let data = item.dataUsingEncoding(NSUTF8StringEncoding)
        return TFHpple(HTMLData: data)
    }
    
    func itemsWithDocument(document: TFHpple, query: String) -> [TFHppleElement] {
        let queries = query.componentsSeparatedByString(" ")
        let pattern = patternWithQueries(queries)
        var result = document.searchWithXPathQuery(pattern)
        return result as [TFHppleElement]
    }
    
    enum SelectorType {
        case IdSelector, ClassSelector, TagSelector
    }
    
    func selectorTypeWithQuery(query: String) -> SelectorType {
        switch query {
        case let x where x.hasPrefix("#"): return .IdSelector
        case let x where x.hasPrefix("."): return .ClassSelector
        default: return .TagSelector
        }
    }
    
    func patternWithQueries(queries: [String]) -> String {
        var pattern = ""
        
        for var i = 0; i < queries.count; i++ {
            var q = queries[i]
            pattern += ((i == 0 ? "//" : "/") + patternWithQuery(q))
        }
        
        return pattern
    }
    
    func patternWithQuery(query: String) -> String {
        let type = selectorTypeWithQuery(query)
        
        switch type {
        case .IdSelector:
            var idName = query.substringFromIndex(1)
            return patternWithId(idName)
        case .ClassSelector:
            var className = query.substringFromIndex(1)
            return patternWithClassName(className)
        default:
            return patternWithTagName(query)
        }
    }
    
    func patternWithTagName(tagName: String) -> String {
        return "\(tagName)"
    }
    
    func patternWithId(idName: String) -> String {
        return "*[@id=\"\(idName)\"]"
    }
    
    func patternWithClassName(className: String) -> String {
        return "*[contains(concat(\" \", normalize-space(@class), \" \"), \" \(className) \")]"
    }
}

extension String {
    func htmlDocument() -> TFHpple {
        return DHHTMLStringParser.instance.documentWithHTMLString(self)
    }
}

extension TFHpple {
    func itemsWithQuery(query: String) -> [TFHppleElement] {
        return DHHTMLStringParser.instance.itemsWithDocument(self, query: query)
    }
}