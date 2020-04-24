//
//  GridView.swift
//  GridBoxCalendar
//
//  Created by Currie on 4/24/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import UIKit

protocol GridDelegate {
    func didTouchTask(task: UIView)
}

protocol GridDatasource: class {
    func heightTaskView(in view: GridView) -> CGFloat
    func startTime(in view: GridView) -> CGFloat
    func endTime(in view: GridView) -> CGFloat
    func dataTask(in view: GridView) -> [Task]
}

class GridView: UIView
{
    private var path = UIBezierPath()
    
    private var startTime: CGFloat!
    
    var delegate: GridDelegate?
    
    weak var datasource: GridDatasource? {
        didSet{
            self.updateView()
        }
    }
    
    private var endTime: CGFloat!
    
    private var isLandscape: Bool!
    
    private var gridWidthMultiple: CGFloat
    {
        return 8
    }
    
    private var gridWidth: CGFloat
    {
        return bounds.width/CGFloat(gridWidthMultiple)
    }
    
    private var gridHeightDevice: CGFloat
    {
        return bounds.height/CGFloat(endTime - startTime)
    }
    
    private var gridHeight: CGFloat!
    
    private var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    func reload(){
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
    private func updateView(){
        
        // setup gridView
        self.gridHeight = datasource?.heightTaskView(in: self) ?? 50
        self.startTime = datasource?.startTime(in: self) ?? 7.0
        self.endTime = datasource?.endTime(in: self) ?? 17.0
        self.bounds.size.height = (self.endTime - self.startTime + 1) * self.gridHeight
        self.heightAnchor.constraint(equalToConstant: (self.endTime - self.startTime + 1) * self.gridHeight).isActive = true
        var listTask = datasource?.dataTask(in: self) ?? [Task]()
        _ = self.subviews.map({ $0.removeFromSuperview() })
        addTimes(startTime: self.startTime, endTime: self.endTime)
        
        // handle data
        DispatchQueue.main.async {
            if listTask.count > 0{
                
                if UIApplication.shared.statusBarOrientation.isLandscape {
                    self.isLandscape = true
                } else {
                    self.isLandscape = false
                }
                
                listTask.sort { (t1, t2) -> Bool in
                    return (t1.endTime - t1.startTime) > (t2.endTime - t2.startTime)
                }
                
                for index1 in 0..<listTask.count-1 {
                    let task1 = listTask[index1]
                    for index2 in index1+1..<listTask.count {
                        let task2 = listTask[index2]
                        if task2.indexDay == task1.indexDay {
                            if (task2.startTime < task1.endTime && task2.endTime > task1.startTime){
                                task2.level = task1.level + 1
                            }
                        }
                    }
                }
                
                listTask.forEach { (task) in
                    self.addTask(task: task)
                }
            }
        }
        
    }
    
    fileprivate func drawGrid()
    {
        path = UIBezierPath()
        path.lineWidth = 0.5
        
        for index in 1...Int(self.gridWidthMultiple)
        {
            let start = CGPoint(x: CGFloat(index) * self.gridWidth, y: self.gridHeight)
            let end = CGPoint(x: CGFloat(index) * self.gridWidth, y: self.bounds.height)
            
            self.path.move(to: start)
            self.path.addLine(to: end)
        }
        
        for index in 1...Int(self.endTime-self.startTime) + 1
        {
            let start = CGPoint(x: self.gridWidth - 20, y: CGFloat(index) * self.gridHeight)
            let end = CGPoint(x: self.bounds.width, y: CGFloat(index) * self.gridHeight)
            self.path.move(to: start)
            self.path.addLine(to: end)
        }
        
        //Close the path.
        path.close()
        
    }
    
    func addTask(task: Task) -> Void {
        if isLandscape  {
            let widthLandscape = gridWidth
            let taskView = TaskView(frame: CGRect(x: widthLandscape * CGFloat(task.indexDay+1) + CGFloat(10*(task.level)), y: gridHeight * (task.startTime - 6), width: widthLandscape - CGFloat(10*(task.level+1)), height: (task.endTime - task.startTime) * gridHeight))
            taskView.backgroundColor = task.color
            taskView.delegate = self
            taskView.title.text = task.title
            taskView.des.text = task.des
            self.addSubview(taskView)
        } else {
            let taskView = TaskView(frame: CGRect(x: gridWidth * CGFloat(task.indexDay+1) + CGFloat(10*(task.level)), y: gridHeight * (task.startTime - 6), width: gridWidth - CGFloat(10*(task.level+1)), height: (task.endTime - task.startTime) * gridHeight))
            taskView.backgroundColor = task.color
            taskView.delegate = self
            taskView.title.text = task.title
            taskView.des.text = task.des
            self.addSubview(taskView)
        }
    }
    
    func addTimes(startTime: CGFloat, endTime: CGFloat){
        for index in 0...Int(endTime - startTime) {
            let time = UILabel(frame: CGRect(x: 0, y: gridHeight * (CGFloat(index)+1) - gridHeight/2, width: gridWidth, height: gridHeight))
            time.text = startTime + CGFloat(index) > 12 ? "\(Int(startTime + CGFloat(index) - 12)) PM" : "\(Int(startTime + CGFloat(index))) AM"
            self.addSubview(time)
        }
        
        
    }
    
    override func draw(_ rect: CGRect)
    {
        self.drawGrid()
        UIColor.gray.setStroke()
        path.stroke()
    }
    
}

extension GridView: TaskDelegate {
    func didTapTask(_ view: UIView) {
        delegate?.didTouchTask(task: view)
    }
    
}
