//
//  ContentView.swift
//  TestDemo
//
//  Created by kchankc on 2022/10/3.
//

import SwiftUI

// MARK: - StringIdentifiable

struct StringIdentifiable: Identifiable, Equatable {
    var id: String {
        string
    }

    let string: String
}

// MARK: - ContentView

struct ContentView: View {

    @State private var showSheet: Bool = false
    @State private var showSheetItem: StringIdentifiable? = nil
    @State private var showSheetItemChangeText: String = "origin"

    @State private var scrollable: Bool = true
    @State private var dismissable: Bool = true

    @State private var dismissTimes: Int = 0

    var body: some View {
        VStack {
            Button("Open sheet bool") {
                showSheet.toggle()
            }
            Button("Open sheet item") {
                showSheetItem = .init(string: "item show sheet")
            }
            .padding(.top)

            Color.clear.frame(height: 50)

            Button {
                scrollable.toggle()
            } label: {
                Text(scrollable ? "Scrollable Content" : "Fixed Content")
            }
            Button {
                dismissable.toggle()
            } label: {
                Text(dismissable ? "Allow Dismiss" : "Disallow Dismiss")
            } 
        }
        .fitBottomSheet(
            isPresented: $showSheet,
            allowDismiss: dismissable,
            scrollable: scrollable,
            onDismiss: {
                dismissTimes += 1
                print("dismiss callback: \(dismissTimes)")
            }
        ) {
            SheetView(scrollable: $scrollable, isPresented: $showSheet)
        }
        .fitBottomSheet(
            item: $showSheetItem,
            allowDismiss: dismissable,
            scrollable: scrollable,
            onDismiss: {
                dismissTimes += 1
                print("dismiss callback: \(dismissTimes)")
            }
        ) { a in
            SheetView(scrollable: $scrollable, isPresented: $showSheet, item: a.string)
        }
    }
}

// MARK: - SheetView

struct SheetView: View {

    @Binding var scrollable: Bool

    @Binding var isPresented: Bool

    @State private var title: String = "Title"
    
    @State private var showingItem: String? = nil
    
    init(scrollable: Binding<Bool>, isPresented: Binding<Bool>, item: String? = nil) {
        _scrollable = scrollable
        _isPresented = isPresented
        
        _showingItem = .init(wrappedValue: item)
    }

    var body: some View {
        origin
    }

    @ViewBuilder
    var origin: some View {
        if scrollable {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack {
                    sheetContent

                    ForEach(1 ..< 60) { index in
                        Text("Row \(index)")
                            .padding()
                    }
                    .padding([.leading, .trailing])
                }
            }
        } else {
            VStack {
                sheetContent
            }
        }
    }

    @ViewBuilder
    var sheetContent: some View {
        Text(title)
            .padding(.top, 24)
            .onTapGesture {
                title = "Changed Title"
            }
        Text("Some very long text ...")
        
        Divider()
        
        Text("Item: \(String(describing: showingItem))" + " (click to change)")
            .foregroundColor(.blue)
            .onTapGesture {
                showingItem = "changed item"
            }
        
        Color.red
            .frame(width: 200, height: 200)
            .onTapGesture {
                // presentationMode.wrappedValue.dismiss()
                isPresented = false
            }
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
