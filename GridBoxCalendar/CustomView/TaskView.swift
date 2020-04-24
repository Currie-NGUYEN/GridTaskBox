//
//  TaskView.swift
//  GridBoxCalendar
//
//  Created by Currie on 4/21/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

protocol TaskDelegate {
    func didTapTask(_ view: UIView)
}

class TaskView: UIView {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var des: UITextView!
    
    var delegate: TaskDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let view = loadNib()
        view.backgroundColor = .clear
        let touchTask = UITapGestureRecognizer(target: self, action: #selector(self.didTouchTask(_:)))
        view.addGestureRecognizer(touchTask)

        self.layer.cornerRadius = 25    
        self.clipsToBounds = true
        self.des.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    @objc func didTouchTask(_ sender: AnyObject){
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { (done) in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.delegate?.didTapTask(self)
        })
    }
    
    func loadNib() -> UIView{
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "TaskView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        addSubview(view)
        return view
    }
}
