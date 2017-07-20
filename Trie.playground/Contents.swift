//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

struct Trie<Element: Hashable> {
    let isElement: Bool
    let children: [Element: Trie<Element>]
}

extension Trie {
    init() {
        isElement = false
        children = [:]
    }
}

extension Trie {
    var elements: [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map{[key] + $0}
        }
        return result
    }
}

extension Trie {
    func lookup(key: [Element]) -> Bool {
        guard let (head, tail) = key.decompose else {
            return isElement
        }
        guard let subtrie = children[head] else {
            return false
        }
        return subtrie.lookup(key: tail)
    }
}

extension Trie {
    func withPrefix(prefix: [Element]) -> Trie<Element>? {
        guard let (head, tail) = prefix.decompose else {
            return self
        }
        guard let remainder = children[head] else {
            return nil
        }
        return remainder.withPrefix(prefix: tail)
    }
    
    func autocomplete(key: [Element]) -> [[Element]] {
        return withPrefix(prefix: key)?.elements ?? []
    }
}

extension Array {
    var decompose: (Element, [Element])? {
        return isEmpty ? nil : (self[startIndex], Array(self.dropFirst()))
    }
}