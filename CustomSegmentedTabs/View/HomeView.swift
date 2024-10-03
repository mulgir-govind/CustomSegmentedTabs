import SwiftUI

struct HomeView: View {
    @State private var tabs: [TabModel]
    @State private var activeTab: TabModel
    @State private var activeTabContentViewId: String?
    @State private var activeTabId: String?
    
    init() {
        let initialTabs = [
            TabModel(name: "Starred"),
            TabModel(name: "Daily"),
            TabModel(name: "Weekly"),
            TabModel(name: "Biweekly"),
            TabModel(name: "Monthly"),
            TabModel(name: "Quarterly"),
            TabModel(name: "Semi-annual"),
            TabModel(name: "Annual")
        ]
        _tabs = State(initialValue: initialTabs)
        _activeTab = State(initialValue: initialTabs[0]) // Now that tabs is initialized, we can safely use initialTabs[0].
    }

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()

            CustomTabBarView()
                .frame(maxHeight: 100)

            GeometryReader { proxy in
                let size = proxy.size
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(tabs) { tab in
                            TaskListView(taskCategory: tab.name)
                                .frame(width: size.width,
                                       height: size.height)
                                .background(.ultraThinMaterial)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled(true)
                .safeAreaPadding(.horizontal)
                .scrollPosition(id: $activeTabContentViewId, anchor: .center)
                .onChange(of: activeTabContentViewId) { oldValue, newValue in
                    withAnimation(.snappy) {
                        activeTabContentViewId = newValue
                        if let selectedTab = tabs.first(where: { $0.id == newValue }) {
                            activeTab = selectedTab
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func HeaderView() -> some View {
        Text("My tasks")
    }

    @ViewBuilder
    func CustomTabBarView() -> some View {
        HStack(spacing: 10) {
            Button(action: {
                withAnimation(.linear(duration: 0.5)) {
                    let newTab = TabModel(name: "New tab \(tabs.count)")
                    tabs.append(newTab)
                    //                    activeTab = newTab
                    //                    activeTabId = newTab.id
                    activeTabContentViewId = newTab.id
                }
            }, label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
            })
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(.borderedProminent)
            .controlSize(.mini)

            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(tabs) { tab in
                        Button(action: {
                            withAnimation(.snappy) {
                                activeTab = tab
                                activeTabContentViewId = tab.id
                                activeTabId = tab.id
                            }
                        }, label: {
                            Text(tab.name)
                                .padding(.vertical)
                                .foregroundStyle(activeTab.id == tab.id ? .primary : Color.gray)
                                .contentShape(.rect)
                        })
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(
                id: .init(get: { return activeTabId }, set: { _ in}),
                anchor: .center)
            .scrollIndicators(.hidden)
            .safeAreaPadding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}

struct TaskListView: View {
    let taskCategory: String
    var body: some View {
        GeometryReader { proxy in
            let availableMaxWidth = proxy.size.width - 64
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(taskCategory)
                        .font(.largeTitle)

                    Divider()
                    
                    Text("Pending tasks:")
                    VStack(alignment: .leading) {
                        ForEach(1 ..< 5) { item in
                            HStack(spacing: 20) {
                                Image(systemName: "circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Task \(item)")
                                Spacer()
                            }
                            .frame(width: availableMaxWidth)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black.opacity(0.2))
                    )
                    
                    Text("Completed tasks:")
                    VStack(alignment: .leading) {
                        ForEach(1 ..< 5) { item in
                            HStack(spacing: 20) {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Task \(item)")
                                    .strikethrough()
                                Spacer()
                            }
                            .frame(width: availableMaxWidth)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black.opacity(0.2))
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
}
