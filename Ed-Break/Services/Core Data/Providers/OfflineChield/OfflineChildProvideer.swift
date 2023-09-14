//
//  OfflineChildProvideer.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.08.23.
//

import UIKit
import CoreData
import Combine

protocol OfflineChildProvideerProtocol {
    
    var fetchedResultsController: NSFetchedResultsController<OfflineChildMO> { get set }
    var viewContext: NSManagedObjectContext { get }
    
    func fetch(in context: NSManagedObjectContext) -> AnyPublisher<OfflineChildMO, Error>
    func addChild(_ contactModel: OfflineChildModel, in context: NSManagedObjectContext, shouldSave: Bool) -> AnyPublisher<Bool, Error>
    func update(childMO: OfflineChildMO, by contact: OfflineChildModel, shouldSave: Bool) -> AnyPublisher<Bool, Error>
    func update(date: Date?, shouldSave: Bool, in context: NSManagedObjectContext) -> AnyPublisher<Bool, Error>
    func update(model: OfflineChildModel, shouldSave: Bool, in context: NSManagedObjectContext) -> AnyPublisher<Bool, Error>
    func delete(child: OfflineChildMO, shouldSave: Bool) -> AnyPublisher<Bool, Error>
}

class OfflineChildProvideer: OfflineChildProvideerProtocol {
    
    private(set) var persistentContainer: NSPersistentContainer
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<OfflineChildMO> = {
        let fetchRequest: NSFetchRequest<OfflineChildMO> = OfflineChildMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Schema.OfflineChild.id.rawValue, ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        
        return controller
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(with persistentContainer: NSPersistentContainer,
         fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?) {
        self.persistentContainer = persistentContainer
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }
    
    
    // MARK: - Public Methods
    
    public func fetch(inContext context: NSManagedObjectContext) throws -> [OfflineChildMO] {
        let fetchRequest: NSFetchRequest<OfflineChildMO> = OfflineChildMO.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    public func fetch(in context: NSManagedObjectContext) -> AnyPublisher<OfflineChildMO, Error> {
        return Future { [weak self] promise in
            do {
                let children = try self?.fetch(inContext: context).first
                guard let child = children else {
                    return promise(.failure(RequestServiceError(message: "Not Found", httpStatus: "")))
                }
                return promise(.success(child))
            }
            catch {
                return promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    public func addChild(_ contactModel: OfflineChildModel, in context: NSManagedObjectContext, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            context.perform { [weak self] in
                self?.childMO(from: contactModel, in: context)
                
                if shouldSave {
                    context.save(with: .addContact)
                }
                return promise(.success(true))
            }
        }.eraseToAnyPublisher()
    }
    
    public func update(childMO: OfflineChildMO, by child: OfflineChildModel, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            guard let context = childMO.managedObjectContext else {
                fatalError("###\(#function): Failed to retrieve the context from: \(child)")
            }
            context.perform { [weak self] in
                self?.update(childMO: childMO, from: child, in: context)
                
                if shouldSave {
                    context.save(with: .updateContact)
                }
                return promise(.success(true))
            }
        }.eraseToAnyPublisher()
    }
    
    func update(date: Date?, shouldSave: Bool = true, in context: NSManagedObjectContext) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let childMO = try? self?.fetch(inContext: context).first else {
                return promise(.failure(RequestServiceError(message: "Not Found", httpStatus: "")))
            }
            context.perform { [weak self] in
                self?.update(childMO: childMO, breakStartDatetime: date, in: context)
                
                if shouldSave {
                    context.save(with: .updateContact)
                }
                return promise(.success(true))
            }
        }.eraseToAnyPublisher()
    }
    
    func update(model: OfflineChildModel, shouldSave: Bool = true, in context: NSManagedObjectContext) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let childMO = try? self?.fetch(inContext: context).first else {
                return promise(.failure(RequestServiceError(message: "Not Found", httpStatus: "")))
            }
            context.perform { [weak self] in
                self?.update(childMO: childMO, model: model, in: context)
                
                if shouldSave {
                    context.save(with: .updateContact)
                }
                return promise(.success(true))
            }
        }.eraseToAnyPublisher()
    }
    
    public func delete(child: OfflineChildMO, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            guard let context = child.managedObjectContext else {
                print("###\(#function): Failed to retrieve the context from: \(child)")
                return
            }
            context.perform {
                context.delete(child)
                
                if shouldSave {
                    context.save(with: .deleteContact)
                }
                return promise(.success(true))
            }
        }.eraseToAnyPublisher()
    }
    
    
    // MARK: - Private Methods
    
    // child
    private func childMO(from child: OfflineChildModel, in context: NSManagedObjectContext) {
        let contactMO = OfflineChildMO(context: context)
        contactMO.id = Int16(child.id)
        update(childMO: contactMO, from: child, in: context)
    }
    
    private func update(
        childMO: OfflineChildMO,
        from child: OfflineChildModel,
        in context: NSManagedObjectContext
    ) {
        childMO.id = Int16(child.id)
        
        childMO.name = child.name
        childMO.restrictionTime = child.restrictionTime == nil ? -1 : Int16(child.restrictionTime!)
        childMO.breakStartDatetime =  child.breakStartDatetime
        childMO.wrongAnswersTime = child.wrongAnswersTime
        childMO.restrictions = child.restrictions
        childMO.interruption = child.interruption == nil ? -1 : Int16(child.interruption!)
        childMO.childSubjects = NSOrderedSet(array: child.childSubjects.map { subjectMO(from: $0, in: context) })
        
        // return childMO
    }
    
    private func update(
        childMO: OfflineChildMO,
        breakStartDatetime: Date?,
        in context: NSManagedObjectContext
    ) {
        childMO.breakStartDatetime =  breakStartDatetime?.toGMTTime().toString(format: .custom("yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
    }
    
    private func update(
        childMO: OfflineChildMO,
        model: OfflineChildModel,
        in context: NSManagedObjectContext
    ) {
        childMO.breakStartDatetime = model.breakStartDatetime
        childMO.wrongAnswersTime = model.wrongAnswersTime
    }
    
    // subject
    private func subjectMO(
        from subject: OfflineSubjectModel,
        in context: NSManagedObjectContext
    ) -> OfflineSubjectMO {
        let subjectMO = OfflineSubjectMO(context: context)
        return update(subjectMO: subjectMO, from: subject, in: context)
    }
    
    private func update(
        subjectMO: OfflineSubjectMO,
        from subject: OfflineSubjectModel,
        in context: NSManagedObjectContext
    ) -> OfflineSubjectMO {
        subjectMO.id = Int16(subject.id)
        
        subjectMO.subject = subject.subject
        subjectMO.photo = subject.photo
        subjectMO.questions = NSOrderedSet(array: subject.questions.map { questionMO(from: $0, in: context) })
        
        return subjectMO
    }
    
    // question
    private func questionMO(
        from question: OfflineQusetionModel,
        in context: NSManagedObjectContext
    ) -> OfflineQusetionMO {
        let questionMO = OfflineQusetionMO(context: context)
        return update(questionMO: questionMO, from: question, in: context)
    }
    
    private func update(
        questionMO: OfflineQusetionMO,
        from question: OfflineQusetionModel,
        in context: NSManagedObjectContext
    ) -> OfflineQusetionMO {
        questionMO.id = Int16(question.id)
        
        questionMO.questionText = question.questionText
        questionMO.answers = NSOrderedSet(array: question.answers.map { answerMO(from: $0, in: context) })
        
        return questionMO
    }
    
    // answer
    private func answerMO(
        from answer: OfflineQuestionAnswerModel,
        in context: NSManagedObjectContext
    ) -> OfflineQuestionAnswerMO {
        let answerMO = OfflineQuestionAnswerMO(context: context)
        return update(questionMO: answerMO, from: answer)
    }
    
    private func update(
        questionMO: OfflineQuestionAnswerMO,
        from question: OfflineQuestionAnswerModel
    ) -> OfflineQuestionAnswerMO {
        questionMO.id = Int16(question.id)
        
        questionMO.answer = question.answer
        questionMO.correct = question.correct
        
        return questionMO
    }
}
