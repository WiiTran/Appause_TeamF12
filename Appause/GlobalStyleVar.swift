//
//  GlobalStyleVar.swift
//  Project190
//
//  Created by Eduardo Mariano on 9/15/23.
//
//  This file holds common variables that are used to style
//  the buttons used for the interface
//
//   - Any var labeled with "path" are only used for the PATH button
//   - All buttons use the btnWidth, btnHeight, and btnAlignment
//   - Buttons excluding the PATH button use the vars that listed after btnAlignment
//   - All buttons use var fontW

import Foundation
import SwiftUI

class Style{
    private var pathColor: Color = Color("BlackWhite")
    private var pathRadius: CGFloat = 100
    private var pathFontColor: Color = Color("WhiteBlack")
    
    private var btnWidth: CGFloat = 300
    private var btnHeight: CGFloat = 20
    private var btnAlignment: Alignment = Alignment.center
    
    private var btnFontColor: Color = Color("BlackWhite")
    private var borderColor: Color = Color("BlackWhite")
    private var borderWidth: CGFloat = 5
    private var btnColor: Color = Color.gray.opacity(0.25)
    private var btnRadius: CGFloat = 6
    
    private var fontW: Font.Weight = .bold
    
    @AppStorage("teacherScheme") private var teacherScheme = 0
    @AppStorage("studentScheme") private var studentScheme = 0
    
}
extension Style{
    
    func setTeacherScheme(){
        if teacherScheme == 0 {
            teacherScheme = 1
        }
        else
        {
            teacherScheme = 0
        }
    }
    
    func getTeacherScheme() -> Int{
        teacherScheme
    }
    
    func setStudentScheme(){
        if studentScheme == 0 {
            studentScheme = 1
        }
        else
        {
            studentScheme = 0
        }
    }
    
    func getStudentScheme() -> Int{
        studentScheme
    }
    func getPathColor() -> Color{
        pathColor
    }
    
    func getPathRadius() -> CGFloat{
        pathRadius
    }
    
    func getPathFontColor()-> Color{
        pathFontColor
    }
    
    func getBorderColor() -> Color{
         borderColor
    }
    
    func getBorderWidth() -> CGFloat{
        borderWidth
    }
    
    func getWidth() -> CGFloat{
        btnWidth
    }
    
    func getHeight() -> CGFloat{
        btnHeight
    }
    
    func getAlignment() -> Alignment{
        btnAlignment
    }
    
    func getBtnFontColor() -> Color{
        btnFontColor
    }
    
    func getBtnColor() -> Color{
        btnColor
    }
    
    func getBtnRadius() -> CGFloat{
        btnRadius
    }
    
    func getFont() -> Font.Weight{
        fontW
    }
    
}

var btnStyle = Style()


