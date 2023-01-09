//
//  LessonCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct LessonCell: View {
    
    let model: SubjectModel
    
    private let progressHeight: CGFloat = 50
    private let cornerRadius: CGFloat = 12
    private let padding: CGFloat = 16
    private let gap: CGFloat = 2
    private let imageHeight: CGFloat = 64
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImageView(withURL: model.photo ?? "", width: imageHeight, height: imageHeight)
                .background(Color.primaryBackground)
                .cornerRadius(cornerRadius)
            VStack(alignment: .leading, spacing: 1) {
                Text(model.subject ?? "")
                    .font(.appSubTitle)
                Text(LocalizedStringKey(model.completed ? "main.child.home.completed" : "main.child.home.notcompleted"))
                    .font(.appBody)
                    .foregroundColor(model.completed ? .primaryGreen : .primaryDescription)
            }
            Spacer()
            if model.completed || model.questionsCount <= 0 {
                Image.Common.roundedCheckmark
            } else {
                ZStack(alignment: .leading) {
                    SegmentedProgressView(segmentsCount: model.questionsCount, filledSegments: model.completedCount)
                        .frame(width: 48)
                        .rotationEffect(Angle(degrees: -90))
                    Text("\(model.completedCount)/\(model.questionsCount)")
                        .font(.appBody)
                        .foregroundColor(.primaryDescription)
                        .padding(7)
                }
            }
        }
        .padding(padding)
        .background(Color.appWhite)
        .cornerRadius(cornerRadius)
    }
}

struct LessonCell_Previews: PreviewProvider {
    static var previews: some View {
        LessonCell(model: SubjectModel(dto: SubjectDto(id: 0, subject: "Math", photo: "English", questionsCount: 5, completedCount: 5, correctAnswersCount: 3, completed: false)))
    }
}
