//
//  Devote_Widget.swift
//  Devote Widget
//
//  Created by kenjimaeda on 28/12/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), configuration: ConfigurationIntent())
	}
	
	func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), configuration: configuration)
		completion(entry)
	}
	
	func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		var entries: [SimpleEntry] = []
		
		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate, configuration: configuration)
			entries.append(entry)
		}
		
		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

struct SimpleEntry: TimelineEntry {
	let date: Date
	let configuration: ConfigurationIntent
}

struct Devote_WidgetEntryView : View {
	//MARK: - Properties
	var entry: Provider.Entry
	@Environment(\.widgetFamily) var widgetFamily
	
	var fontFamily: Font.TextStyle {
		return widgetFamily == .systemSmall ? .footnote : .headline
	}
	
	
	var body: some View {
		
		GeometryReader { geometry in
			ZStack {
				
				colorBackground
				Image("rocket-small")
					.resizable()
					.scaledToFit()
				
				Image("logo")
					.resizable()
					.scaledToFit()
					.frame( width: widgetFamily == .systemSmall  ? 32 : 40,
									height: widgetFamily == .systemSmall ? 32 : 40)
					.offset(x: (geometry.size.width / 2) - 30, y: (geometry.size.height / -2) + 30)
				
				HStack {
					Text("Just Do It")
						.font(.system(fontFamily,design: .rounded))
						.foregroundColor(.white)
						.padding(.vertical,  widgetFamily == .systemSmall  ? 5 : 8)
						.padding(.horizontal, widgetFamily == .systemSmall  ? 5 : 8)
						.background(
							Color.black
								.opacity(0.7)
								.blendMode(.overlay)
						)
						.clipShape(Capsule())
						.offset(y: (geometry.size.height / 2) - 23 )
					
					if  widgetFamily != .systemSmall {
						Spacer()
						
					}
					
					
				}// Hstack
				.padding(.horizontal,20)
				
				
			}
		}// Zstack
		
	}
}

@main
struct Devote_Widget: Widget {
	let kind: String = "Devote_Widget"
	
	var body: some WidgetConfiguration {
		IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
			Devote_WidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Devote Widget")
		.description("This is deveto widget")
	}
}

struct Devote_Widget_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			Devote_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
				.previewContext(WidgetPreviewContext(family: .systemSmall))
			
			Devote_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
				.previewContext(WidgetPreviewContext(family: .systemMedium))
			
			Devote_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
				.previewContext(WidgetPreviewContext(family: .systemLarge))
			
		}// Group
		
	}
}
