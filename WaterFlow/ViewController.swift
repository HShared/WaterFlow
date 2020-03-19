//
//  ViewController.swift
//  WaterFlow
//
//  Created by ATH on 2020/3/19.
//  Copyright © 2020 sco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var waterFlowSimpleView:WaterFlowSimpleView?
    override func viewDidLoad() {
        super.viewDidLoad()
          let screenSize = UIScreen.main.bounds.size
        waterFlowSimpleView = WaterFlowSimpleView(frame: CGRect(x:10,y:80,width: screenSize.width-20,height:screenSize.height-100))
        view.addSubview(waterFlowSimpleView!)
    }


}

