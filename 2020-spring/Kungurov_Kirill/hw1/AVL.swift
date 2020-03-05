import UIKit

class BinaryTree<T: Comparable>{
    
    var root: Node?
    
    init(_ node: Node? = nil){
        self.root = node
    }
    
    class Node{
        var data: T
        var left: Node?
        var right: Node?
        var height: Int
        
        init(_ data: T, left: Node? = nil, right: Node? = nil, height: Int = 1){
            self.data = data
            self.left = left
            self.right = right
            self.height = height
        }
        
    }
    
    func contains(_ value: T) -> Bool{
        contains(self.root, value)
    }
    
    private func contains(_ rootNode: Node?, _ value: T) -> Bool{
        guard let rootNode = rootNode else {
            return false
        }
        if (value > rootNode.data){
            return contains(rootNode.right, value)
        } else if (value < rootNode.data){
            return contains(rootNode.left, value)
        } else {
            return true
        }
    }
    
    func put(_ value: T){
        self.root = put(self.root, value)
    }
    
    private func put(_ rootNode: Node?,_ value: T) -> Node{
        guard let rootNode = rootNode else {
            return Node(value)
        }
        if (rootNode.data > value){
            rootNode.left = put(rootNode.left, value)
        } else if (rootNode.data < value){
            rootNode.right = put(rootNode.right, value)
        } else{
            rootNode.data = value
            return rootNode
        }
        fixHeight(rootNode)
        return balance(rootNode)
    }
    
    private func min(_ rootNode: Node) -> Node{
        return rootNode.left == nil ? rootNode : min(rootNode.left!)
    }
    
    private func removeMin(_ rootNode: Node?) -> Node?{
        if let rootNode = rootNode{
            if (rootNode.left == nil) {
                return rootNode.right
            }
            rootNode.left = removeMin(rootNode.left)
            fixHeight(rootNode)
            return balance(rootNode)
        } else{
            return nil
        }
    }
    
    func remove(_ value: T) -> Bool{
        if let rootNode = remove(self.root, value) {
            self.root = rootNode
            return true
        } else {
            return false
        }
    }
    
    private func remove(_ rootNode: Node?,_ value: T) -> Node?{
        if let rootNode = rootNode {
            if !contains(rootNode, value) {
                return nil
            }
            if (value < rootNode.data) {
                rootNode.left = remove(rootNode.left, value)
            } else if (value > rootNode.data){
                rootNode.right = remove(rootNode.right, value)
            } else {
                if (rootNode.left == nil){
                    return rootNode.right
                }
                if (rootNode.right == nil) {
                    return rootNode.left
                }
                let tmp = min(rootNode.right!)
                tmp.right = removeMin(rootNode.right!)
                tmp.left = rootNode.left
                return balance(tmp)
                
            }
            fixHeight(rootNode)
            return balance(rootNode)
        }
        return nil
    }
    
    private func height(_ rootNode: Node?) -> Int{
        return rootNode?.height ?? 0
    }
    
    private func balanceFactor(_ rootNode: Node?) -> Int{
        if let rootNode = rootNode{
            return height(rootNode.left) - height(rootNode.right)
        } else{
            return 0
        }
    }
    
    private func fixHeight(_ rootNode: Node){
        rootNode.height = 1 + max(height(rootNode.left), height(rootNode.right))
    }
    
    private func rotateLeft(_ rootNode: Node) -> Node{
        let right = rootNode.right!
        rootNode.right = right.left
        right.left = rootNode
        fixHeight(right)
        fixHeight(rootNode)
        return right
    }
    
    private func rotateRight(_ rootNode: Node) -> Node{
        let left = rootNode.left!
        rootNode.left = left.right
        left.right = rootNode
        fixHeight(left)
        fixHeight(rootNode)
        return left
    }
    
    private func balance(_ rootNode: Node) -> Node{
        if (balanceFactor(rootNode) == -2){
            if (balanceFactor(rootNode.right!) > 0){
                rootNode.right = rotateRight(rootNode.right!)
            }
            return rotateLeft(rootNode)
        }
        if (balanceFactor(rootNode) == 2){
            if (balanceFactor(rootNode.left!) < 0){
                rootNode.left = rotateLeft(rootNode.left!)
            }
            return rotateRight(rootNode)
        }
        return rootNode
    }
}
