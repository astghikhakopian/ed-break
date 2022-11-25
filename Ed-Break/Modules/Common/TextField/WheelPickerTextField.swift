//
//  WheelPickerTextField.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 25.11.22.
//

import SwiftUI

class WheelPickerTextField<C>: UITextField, UIPickerViewDataSource, UIPickerViewDelegate where C: PickerItem {

    let title: String
    @Binding var data: [C]
    @Binding var selection: C

    init(title: String, data: Binding<[C]>, selection: Binding<C>) {
        self.title = title
        self._data = data
        self._selection = selection
        super.init(frame: .zero)

        self.inputView = pickerView
        self.inputAccessoryView = toolbar
        self.tintColor = .clear

        guard let selectionIndex = data.wrappedValue.firstIndex(of: selection.wrappedValue) else {
            return
        }

        self.pickerView.selectRow(selectionIndex, inComponent: 0, animated: true)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        
        let title = UIBarButtonItem(
            title: NSLocalizedString(self.title, comment: ""),
            style: .done,
            target: self,
            action: nil
        )
        title.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 13)!,
            NSAttributedString.Key.foregroundColor: UIColor(Color.appBlack)],
            for: .normal)
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(donePressed)
        )
        doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 13)!,
            NSAttributedString.Key.foregroundColor: UIColor(Color.primaryPurple)],
            for: .normal)

        toolbar.setItems([title, flexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        toolbar.tintColor = .white
        toolbar.backgroundColor = .white
        return toolbar
    }()

    // MARK: - Private methods
    @objc
    private func donePressed() {
        let selectedIndex = self.pickerView.selectedRow(inComponent: 0)
        guard data.count > selectedIndex else { return }
        self.selection = self.data[selectedIndex]
        self.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedIndex = row
        guard data.count > selectedIndex else { return }
        selection = data[selectedIndex]
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = data[row].name
        let myTitle = NSAttributedString(
            string: titleData,
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 15)!,
            ])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .center
       return pickerLabel
    }
}

import SwiftUI
    
struct WheelPickerRepresentableField<C>: UIViewRepresentable where C: PickerItem {
    // MARK: - Public properties
    
    @Binding var selection: C
    @Binding var datasource: [C]
    
    private let title: String
    private var placeholder: String?
    private let textField: WheelPickerTextField<C>

    // MARK: - Initializers
    init(title: String, placeholder: String? = nil, datasource: Binding<[C]>, selection: Binding<C>) where C: PickerItem {
        self.title = title
        self.placeholder = placeholder
        self._datasource = datasource
        self._selection = selection

        textField = WheelPickerTextField(title: title, data: datasource, selection: selection)
        
        textField.font = UIFont(name: "Poppins-Medium", size: 12)
    }

    // MARK: - Public methods
    func makeUIView(context: UIViewRepresentableContext<WheelPickerRepresentableField>) -> UITextField {
        textField.placeholder = placeholder
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<WheelPickerRepresentableField>) {
        uiView.text = selection.name
    }
}

struct WheelPickerField<C>: View where C: PickerItem {
    
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
            HStack {
                WheelPickerRepresentableField(title: title, datasource: $datasource, selection: $selection)
                Spacer()
                Image.Common.dropdownArrow
            }.accentColor(.appBlack)
                .padding(padding)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.border, lineWidth: borderWidth)
                )
        }
    }
}
