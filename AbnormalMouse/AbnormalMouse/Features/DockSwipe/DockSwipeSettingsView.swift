import ComposableArchitecture
import SwiftUI

struct DockSwipeSettingsScreen: View {
    let store: DockSwipeDomain.Store

    var body: some View {
        DockSwipeSettingsView(store: store)
            .lifeCycleWithViewStore(store, onAppear: { viewStore in
                viewStore.send(.appear)
            })
    }
}

private struct DockSwipeSettingsView: View {
    let store: DockSwipeDomain.Store

    var body: some View {
        ScrollView {
            DockSwipeView(store: store)
            Spacer()
        }
    }
}

private struct DockSwipeView: View {
    let store: DockSwipeDomain.Store

    var body: some View {
        SettingsSectionView(
            showSeparator: false,
            title: { Text(_L10n.View.title) },
            introduction: { Text(_L10n.View.introduction) },
            content: {
                WithViewStore(
                    store.scope(
                        state: \.dockSwipeActivator,
                        action: DockSwipeDomain.Action.dockSwipe
                    )
                ) {
                    viewStore in
                    SettingsKeyCombinationInput(
                        keyCombination: viewStore.binding(
                            get: { $0.keyCombination },
                            send: { .setKeyCombination($0) }
                        ),
                        numberOfTapsRequired: viewStore.binding(
                            get: { $0.numberOfTapsRequired },
                            send: { .setNumberOfTapsRequired($0) }
                        ),
                        hasConflict: viewStore.hasConflict,
                        invalidReason: viewStore.invalidReason,
                        title: { Text(_L10n.View.activationKeyCombinationTitle) }
                    )
                }

                horizontalDirectionPicker

                SettingsTips {
                    Text(_L10n.View.Tips.usage).tipsTitle(_L10n.TipsTitle.usage)
                    EmptyView()
                }
            }
        )
    }

    private var horizontalDirectionPicker: some View {
        WithViewStore(store.scope(state: \.horizontalDirection)) { viewStore in
            SettingsPicker(
                title: Text(_L10n.View.horizontalDirectionTitle),
                selection: viewStore.binding(
                    get: { $0.rawValue },
                    send: DockSwipeDomain.Action.setHorizontalDirection
                )
            ) {
                ForEach(DockSwipeHorizontalDirection.allCases, id: \.rawValue) { direction in
                    Text(
                        direction == .rightDragMovesRight
                            ? _L10n.View.rightDragMovesRight
                            : _L10n.View.rightDragMovesLeft
                    )
                    .tag(direction.rawValue)
                }
            }
        }
    }
}

private enum _L10n {
    typealias View = L10n.DockSwipeSettings.View
    typealias TipsTitle = L10n.Shared.TipsTitle
}

struct DockSwipeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DockSwipeSettingsView(store: .init(
            initialState: .init(),
            reducer: DockSwipeDomain.reducer,
            environment: .live(environment: .init(
                persisted: .init(),
                featureHasConflict: { _ in true },
                checkKeyCombinationValidity: { _ in nil }
            ))
        ))
    }
}
