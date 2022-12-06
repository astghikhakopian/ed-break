//
//  PickerTextField.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 02.10.22.
//

import SwiftUI

enum Grade: Int, CaseIterable, PickerItem, BottomsheetCellModel {
    
    case first  = 1
    case second = 2
    case third  = 3
    case fourth  = 4
    case fifth  = 5
    case sixth  = 6
    case seventh  = 7
    case eightth  = 8
    case nineth  = 9
    
    var name: String {
        switch self {
        case .first:    return "Grade 1"
        case .second:   return "Grade 2"
        case .third:    return "Grade 3"
        case .fourth:   return "Grade 4"
        case .fifth:    return "Grade 5"
        case .sixth:    return "Grade 6"
        case .seventh:  return "Grade 7"
        case .eightth:  return "Grade 8"
        case .nineth:   return "Grade 9"
        }
    }
    
    var key: String {
        switch self {
        case .first:    return "GRADE_1"
        case .second:   return "GRADE_2"
        case .third:    return "GRADE_3"
        case .fourth:   return "GRADE_4"
        case .fifth:    return "GRADE_5"
        case .sixth:    return "GRADE_6"
        case .seventh:  return "GRADE_7"
        case .eightth:  return "GRADE_8"
        case .nineth:   return "GRADE_9"
        }
    }
    
    var id: Int {
        rawValue
    }
    
    var title: String {
        name
    }
    
    var imageUrl: URL? {
        nil
    }
}

enum Interuption: Int, CaseIterable, PickerItem, BottomsheetCellModel {
    
    case i15 = 15
    case i20 = 20
    case i25 = 25
    case i30 = 30
    
    var name: String {
        "\(self.rawValue) minutes"
    }
    
    var key: Int {
        rawValue
    }
    
    var id: Int {
        rawValue
    }
    
    var title: String {
        name
    }
    
    var imageUrl: URL? {
        nil
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
