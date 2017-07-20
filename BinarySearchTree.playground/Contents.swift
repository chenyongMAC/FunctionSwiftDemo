//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

indirect enum BinarySearchTree<Element: Comparable> {
    case Leaf
    case Node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}

extension BinarySearchTree {
    init() {
        self = .Leaf
    }
    
    init(_ value: Element) {
        self = .Node(.Leaf, value, .Leaf)
    }
}

//计算二叉搜索树里存储的值的数量
extension BinarySearchTree {
    var count: Int {
        switch self {
        case .Leaf:
            return 0
        case let .Node(left, _, right):
            return 1 + left.count + right.count
        }
    }
}

//返回树中所有元素组成的数组
extension BinarySearchTree {
    var elements: [Element] {
        switch self {
        case .Leaf:
            return []
        case let .Node(left, value, right):
            return left.elements + [value] + right.elements
        }
    }
}

//判断是否为空
extension BinarySearchTree {
    var isEmpty: Bool {
        if case .Leaf = self {
            return true
        }
        return false
    }
}

//判断是否为搜索二叉树
extension BinarySearchTree {
    var isBST: Bool {
        switch self {
        case .Leaf:
            return true
        case let .Node(left, x, right):
            return left.elements.all{y in y < x}
            && right.elements.all{y in y > x}
            && right.isBST
            && left.isBST
        }
    }
}

//判断元素是否在二叉树中
extension BinarySearchTree {
    func contains(x: Element) -> Bool {
        switch self {
        case .Leaf:
            return false
        case let .Node(_, y, _) where y == x:
            return true
        case let .Node(left, y, _) where x < y:
            return left.contains(x: x)
        case let .Node(_, y, right) where x > y:
            return right.contains(x: x)
        default:
            fatalError("The impossible occured")
        }
    }
}

//插入元素
extension BinarySearchTree {
    mutating func insert(x: Element) {
        switch self {
        case .Leaf:
            self = BinarySearchTree(x)
        case .Node(var left, let y, var right):
            if x < y {
                left.insert(x: x)
            }
            if x > y {
                right.insert(x: x)
            }
            self = .Node(left, y, right)
        }
    }
}

extension Sequence {
    func all(predicate: (Iterator.Element) -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
}



//test
let myTree: BinarySearchTree<Int> = BinarySearchTree()
var copies = myTree
copies.insert(x: 5)
(myTree.elements, copies.elements)


