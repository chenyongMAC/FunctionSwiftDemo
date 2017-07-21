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
    
    init(_ key: [Element]) {
        if let (head, tail) = key.decompose {
            let children = [head: Trie(tail)]
            self = Trie(isElement: false, children: children)
        } else {
            self = Trie(isElement: true, children: [:])
        }
    }
}

extension Trie {
    //将字典树展平(flatten)为一个包含全部元素的数组
    var elements: [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map{[key] + $0}
        }
        return result
    }
}

extension Trie {
    //遍历，逐一确定对应的键是否存储在树中
    func lookup(key: [Element]) -> Bool {
        guard let (head, tail) = key.decompose else {
            return isElement
        }
        guard let subtrie = children[head] else {
            return false
        }
        return subtrie.lookup(key: tail)
    }
    
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

extension Trie {
    //插入元素
    func insert(key: [Element]) -> Trie<Element> {
        guard let (head, tail) = key.decompose else {
            return Trie(isElement: true, children: children)
        }
        var newChildren = children
        if let nextTrie = children[head] {
            newChildren[head] = nextTrie.insert(key: tail)
        } else {
            newChildren[head] = Trie(tail)
        }
        return Trie(isElement: true, children: newChildren)
    }
}

extension Array {
    var decompose: (Element, [Element])? {
        return isEmpty ? nil : (self[startIndex], Array(self.dropFirst()))
    }
}

func buildStringTrie(_ words: [String]) -> Trie<Character> {
    let emptyTrie = Trie<Character>()
    return words.reduce(emptyTrie, { (trie, word) -> Trie<Character> in
        trie.insert(key: Array(word.characters))
    })
}

func autocompleteString(knownWords: Trie<Character>, word: String) -> [String] {
    let chars = Array(word.characters)
    let completed = knownWords.autocomplete(key: chars)
    return completed.map { chars in
        word + String(chars)
    }
}


//test
let contents = ["cat", "car", "cart", "dog"]
let trieOfWords = buildStringTrie(contents)
autocompleteString(knownWords: trieOfWords, word: "car")





