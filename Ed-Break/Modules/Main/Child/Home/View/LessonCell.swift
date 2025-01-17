//
//  LessonCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI
import Kingfisher

struct LessonCell: View {
    
    let model: SubjectModel
    
    private let progressHeight: CGFloat = 50
    private let cornerRadius: CGFloat = 12
    private let padding: CGFloat = 16
    private let gap: CGFloat = 2
    private let imageHeight: CGFloat = 64
    
    var body: some View {
        HStack(spacing: 12) {
            if let photo = model.photo, let url = URL(string: photo) {
                CachedAsyncImage(urlRequest: URLRequest(url: url), urlCache: .imageCache)
                    .frame(width: imageHeight, height: imageHeight)
                    .background(Color.appWhite)
                    .cornerRadius(cornerRadius)
            }
//            AsyncImageView(withURL: model.photo ?? "", width: imageHeight, height: imageHeight)
//                .background(Color.appWhite)
//                .cornerRadius(cornerRadius)
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
                    SegmentedProgressView(segmentsCount: model.questionsCount, filledSegments: model.answeredQuestionsCount)
                        .frame(width: 48)
                        .rotationEffect(Angle(degrees: -90))
                    Text("\(model.answeredQuestionsCount)/\(model.questionsCount)")
                        .font(.appBody)
                        .foregroundColor(.primaryDescription)
                        .padding(7)
                }
            }
        }
        .padding(.horizontal, padding)
        .padding(.vertical, padding/2)
        .background(Color.primaryCellBackground)
        .cornerRadius(cornerRadius)
    }
}

struct LessonCell_Previews: PreviewProvider {
    static var previews: some View {
        LessonCell(model: SubjectModel(dto: SubjectDto(id: 0, subject: "Math", photo: "English", questionsCount: 5, answeredQuestionsCount: 5, doExercise: false, correctAnswersCount: 3, completed: false)))
    }
}

extension URLCache {
    
    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}
