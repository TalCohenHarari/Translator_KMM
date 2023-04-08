import SwiftUI
import shared


// ignoresSafeArea = ignore the status bar
struct ContentView: View {
    
    private let appMpdule = AppModule()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            TranslateScreen(
                historyDatasouece: appMpdule.historyDataSource,
                translateUseCase: appMpdule.translateUseCase
            )
        }
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
