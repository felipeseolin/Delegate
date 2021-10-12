//
//  AlertUtils.swift
//  Delegate
//
//  Created by Felipe Seolin Bento on 11/10/21.
//

import UIKit

class AlertUtils {
    
    public static func invalidFormAlert(title: String = "Formulário inválido", message: String = "Preencha todos os campos corretamente") -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        return alert
    }
}
