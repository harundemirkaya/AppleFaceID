//
//  ViewController.swift
//  FaceID
//
//  Created by Harun Demirkaya on 4.04.2023.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    // MARK: Define

    private let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "FaceID App"
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Futura", size: 20)
        return lbl
    }()
    
    private let btnAuthorize: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemGreen
        btn.setTitle(" Authorize ", for: .normal)
        return btn
    }()
    
    private let deviceType = LAContext().biometricType
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        self.setupViews()
        
        print(deviceType.rawValue)
        
    }
    
    private func setupViews(){
        lblDescription.lblDescriptionConstraints(view)
        btnAuthorize.btnAuthorizeConstraints(view, lblDescription: lblDescription)
        
        btnAuthorize.addTarget(self, action: #selector(authenticateTapped), for: .touchUpInside)
    }
    
    @objc private func authenticateTapped() {
        let context = LAContext()
        var error: NSError?
        var reason = ""
        
        switch deviceType{
        case .faceID:
            reason = "Scan Your Face to Login"
        case .touchID:
            reason = "Scan Your Fingerprint to Login"
        default:
            print("No Support")
        }
        
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        if deviceType != .none{
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.lblDescription.text = "Authorize Success!"
                    } else {
                        self?.lblDescription.text = "Authorize Failed!"
                    }
                }
            }
        } else{
            lblDescription.text = "Your Device Doesn't Have Enough Versions for Verification Operations"
        }
    }
}

private extension UIView{
    func lblDescriptionConstraints(_ view: UIView){
        view.addSubview(self)
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func btnAuthorizeConstraints(_ view: UIView, lblDescription: UILabel){
        view.addSubview(self)
        topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: 10).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
