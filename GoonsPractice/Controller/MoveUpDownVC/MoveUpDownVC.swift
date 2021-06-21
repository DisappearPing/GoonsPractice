//
//  MoveUpDownVC.swift
//  GoonsPractice
//
//  Created by billHsiao on 2021/6/21.
//

import UIKit

class MoveUpDownVC: UIViewController {
    
    // MARK: - Property
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    private var statusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private var viewPropertyAnimator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.6, curve: .easeInOut, animations: nil)
    
    private var bottomViewMaxY = CGFloat.zero
    private var bottomViewMinY = CGFloat.zero
    private var bottomViewOriginHeight = CGFloat.zero

    private enum BottomDragViewSituation {
        case bottom
        case top
        case moving(location: CGPoint)
    }
    
    private var bottomDragViewSituation: BottomDragViewSituation = .bottom {
        
        didSet {
            
            switch bottomDragViewSituation {
            case .top :
                bottomMoveUpDownView.transform = CGAffineTransform(translationX: 0, y: -(bottomViewMaxY - bottomViewMinY))
                bottomMoveUpDownView.transform = CGAffineTransform(scaleX: 1, y: 1 + ((bottomViewMaxY - bottomViewMinY)/bottomViewOriginHeight) * 2)
                bottomMoveUpDownView.layer.maskedCorners = []
                
                topDogImageView.transform = CGAffineTransform(translationX: 0, y: -(bottomViewMaxY - bottomViewMinY))
                
                topNavBarView.alpha = 1
                
                onDogImageViewFirstLabel.alpha = 0
                onDogImageViewSecondLabel.alpha = 0
                
                self.statusBarStyle = .darkContent

            case .moving(location: let location):
            let diffY = bottomViewMaxY - location.y
            let ratio = (diffY / (bottomViewMaxY - bottomViewMinY))

        bottomMoveUpDownView.transform = CGAffineTransform(translationX: 0, y: -diffY)
        bottomMoveUpDownView.transform = CGAffineTransform(scaleX: 1, y: 1 + ((diffY)/bottomMoveUpDownView.bounds.height) * 2)
        
        bottomMoveUpDownView.layer.cornerRadius = 24 - (24 * ratio)
        bottomMoveUpDownView.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        topDogImageView.transform = CGAffineTransform(translationX: 0, y: -diffY)
        
        topNavBarView.alpha = ratio
                
                onDogImageViewFirstLabel.alpha = 1 - ratio
                onDogImageViewSecondLabel.alpha = 1 - ratio
                
            case .bottom:
                bottomMoveUpDownView.transform = .identity
                
                bottomMoveUpDownView.layer.cornerRadius = 24
                bottomMoveUpDownView.layer.maskedCorners = [.layerMaxXMinYCorner]
                
                topDogImageView.transform = .identity
                
                topNavBarView.alpha = 0
                
                onDogImageViewFirstLabel.alpha = 1
                onDogImageViewSecondLabel.alpha = 1
                
                self.statusBarStyle = .lightContent

            }
            
        }
        
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var bottomMoveUpDownView: UIView!
    
    @IBOutlet weak var topNavBarView: UIView!
    @IBOutlet weak var topDogImageView: UIImageView!
    @IBOutlet weak var onDogImageViewFirstLabel: UILabel!
    @IBOutlet weak var onDogImageViewSecondLabel: UILabel!
    
    // MARK: - Init
    
    convenience init(){
        self.init(nibName: Self.identifier, bundle: nil)
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bottomMoveUpDownView.layer.cornerRadius = 24
        bottomMoveUpDownView.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.bottomViewMaxY = bottomMoveUpDownView.frame.minY
        self.bottomViewMinY = topNavBarView.frame.maxY
        self.bottomViewOriginHeight = bottomMoveUpDownView.frame.height

    }
    
    // MARK: - IBAction

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bottomViewDragGestureAction(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            
          break
            
        case .changed:
            
            let translationInView = sender.location(in: self.view)
            print(translationInView)
            
            if translationInView.y <= bottomViewMinY {
                
                self.bottomDragViewSituation = .top
                
            } else if  translationInView.y < bottomViewMaxY && translationInView.y > bottomViewMinY {
                    
                self.bottomDragViewSituation = .moving(location: translationInView)

            } else if translationInView.y >= bottomViewMaxY  {
                    
                self.bottomDragViewSituation = .bottom

            }
            
        case .ended:
           
            let translationInView = sender.location(in: self.view)
            print(translationInView)

            let diffY = bottomViewMaxY - translationInView.y

            let ratio = (diffY / (bottomViewMaxY - bottomViewMinY))

            switch ratio {
            case 0.51...1 :

                self.bottomDragViewSituation = .top

            default:

                self.bottomDragViewSituation = .bottom

            }

        break
        default:
            break
        }
        
    }
    
}
