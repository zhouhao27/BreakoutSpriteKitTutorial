// Playground - noun: a place where people can play

import SpriteKit


let numberOfBlocks = 3
let blockWidth : Float = 100.0
let padding : Float = 20.0

let xOffset = (500.0 - (blockWidth * Float(numberOfBlocks) + padding * (Float(numberOfBlocks-1)))) / 2


let numberOfBlocks2 = 3
let blockWidth2 = 200.0
let padding2 = 20.0

// 2 Calculate the xOffset
var i = 1
let height = 100.0
let width = 200.0
let xOffset2 = 50.0

let position = CGPointMake((Double(i)-0.5)*width + (Double(i)-1)*padding2 + xOffset2,height * 0.8)
