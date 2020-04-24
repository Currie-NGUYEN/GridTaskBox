//
//  ViewController.swift
//  gridBoxCalendar
//
//  Created by Currie on 4/20/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var gridView: GridView!
    
    var listTask:[Task] = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.delegate = self
        gridView.datasource = self
        
        self.genarateData()
    }
    
    func genarateData() {
        for index in 0...50{
            let startTime = CGFloat.random(in: 7...16.5)
            var endTime: CGFloat?
            repeat {
                endTime = CGFloat.random(in: 7...17)
            } while (endTime! - 0.5 < startTime);
            
            let task = Task(startTime: startTime, endTime: endTime!, indexDay: Int.random(in: 0...6), color: UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1), level: 0, title: "Task \(index)", des: "Here is demo description task.")
            listTask.append(task)
        }
        gridView.reload()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.gridView.reload()
    }
}

extension ViewController: GridDelegate, GridDatasource {
    func didTouchTask(task: UIView) {
        
    }
    
    func heightTaskView(in view: GridView) -> CGFloat {
        return 100
    }
    
    func startTime(in view: GridView) -> CGFloat {
        return 6.0
    }
    
    func endTime(in view: GridView) -> CGFloat {
        return 18.0
    }
    
    func dataTask(in view: GridView) -> [Task] {
        return listTask
    }
    
    
}
