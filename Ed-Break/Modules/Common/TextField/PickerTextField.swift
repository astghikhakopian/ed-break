//
//  PickerTextField.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 02.10.22.
//

import SwiftUI

enum Grade: String, CaseIterable, PickerItem {
    case first  = "GRADE_1"
    case second = "GRADE_2"
    case third  = "GRADE_3"
    
    var name: String {
        switch self {
        case .first:    return "Grade 1"
        case .second:   return "Grade 2"
        case .third:    return "Grade 3"
        }
    }
    
    var key: String {
        switch self {
        case .first:    return "GRADE_1"
        case .second:   return "GRADE_2"
        case .third:    return "GRADE_3"
        }
    }
}

struct PickerTextField<C>: View where C: PickerItem {
    
    let title: String
    @Binding var selection: C
    @Binding var datasource: [C]
    
    private let padding = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
    private let cornerRadius = 12.0
    private let borderWidth = 1.0
    private let spacing = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(LocalizedStringKey(title))
                .font(.appHeadline)
                .foregroundColor(.primaryDescription)
            Spacer().frame(height: 4)
            Menu {
                Picker(selection: $selection) {
                    ForEach(datasource, id: \.self) {
                        Text($0.name).font(.appHeadline)
                    }.font(.appHeadline)
                } label: { }
            } label: {
                Text(selection.name).font(.appHeadline)
                Spacer()
                Image.Common.dropdownArrow
            }
            
            .accentColor(.appBlack)
            .padding(padding)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.border, lineWidth: borderWidth)
            )
        }
    }
}

struct PickerTextField_Previews: PreviewProvider {
    
    @State static var text = "Emma"
    @State static var selection = Grade.first
    @State static var datasource = Grade.allCases
    
    static var previews: some View {
        PickerTextField(title: "Child name", selection: $selection, datasource: $datasource)
    }
}

protocol PickerItem: Hashable {
    var name: String { get }
}
