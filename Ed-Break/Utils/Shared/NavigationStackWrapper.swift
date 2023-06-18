//
//  NavigationStackWrapper.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.06.23.
//

import SwiftUI
import NavigationBackport

public struct NavigationStackWrapper<T: View>: View {
  
  let content: () -> T
  
  public init(content: @escaping () -> T) {
    self.content = content
  }
   
  public var body: some View {
    if #available(iOS 16, *) {
      NavigationStack(root: content)
    } else {
      NBNavigationStack(root: content)
    }
  }
  
}

public extension View {
  
  func navigationDestinationWrapper<V>(isPresented: Binding<Bool>, @ViewBuilder destination: () -> V) -> some View where V: View {
    if #available(iOS 16, *) {
      return self
        .navigationDestination(isPresented: isPresented, destination: destination)
    } else {
      return self
        .nbNavigationDestination(isPresented: isPresented, destination: destination)
    }
  }
  
}

