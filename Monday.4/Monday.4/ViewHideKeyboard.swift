//
//  ViewHideKeyboard.swift
//  Monday.4
//
//  Created by  KoudaTakuma       on 2026/06/15.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
    }
}
