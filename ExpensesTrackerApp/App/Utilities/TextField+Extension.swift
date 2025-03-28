//
//  TextField+Extension.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/25/25.
//

import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}

