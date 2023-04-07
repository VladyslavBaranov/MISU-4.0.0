//
//  SleepCardDescriptionPage.swift
//  CoronaVirTracker
//
//  Created by VladyslavMac on 28.09.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

private struct _PointedText: View {
	let text: String
	var body: some View {
		HStack {
			VStack {
				Circle()
					.fill(Color(red: 0.36, green: 0.61, blue: 0.97, opacity: 0.5))
					.frame(width: 7, height: 7, alignment: .top)
					.offset(x: 0, y: 6)
				Spacer()
			}
			
			Text(text)
				.multilineTextAlignment(.leading)
				.font(.system(size: 16))
			Spacer()
		}
		.fixedSize(horizontal: false, vertical: true)
	}
}

struct SleepCardDescriptionPage: View {
	
	let item: SleepCardItem
	
	@Environment(\.presentationMode) var mode
	
	var body: some View {
		VStack(spacing: 0) {
			Color.clear
				.frame(height: 30)
			ZStack {
				HStack {
					Button {
						mode.wrappedValue.dismiss()
					} label: {
						Image("orange_back")
							.font(.system(size: 24))
					}
					Spacer()
				}
			}
			.padding(EdgeInsets(top: 30, leading: 16, bottom: 20, trailing: 16))
			.background(Color.white)
			.foregroundColor(.black)
			
			ScrollView {
				ZStack {
					RoundedRectangle(cornerRadius: 12, style: .continuous)
						.fill(LinearGradient(colors: item.gradient, startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)))
					Image(item.icon)
						.resizable()
						.scaledToFit()
						.frame(width: 100, height: 100)
				}
				.frame(height: 150)
				.padding(16)
				
				switch item.index {
				case 0:
					makeItem1Text()
				case 1:
					makeItem2Text()
				case 2:
					makeItem3Text()
				default:
					makeItem4Text()
				}
			}
		}
		.navigationBarHidden(true)
		.ignoresSafeArea()
	}
	
	private func makeItem1Text() -> some View {
		VStack(alignment: .leading, spacing: 20) {
			Text("Рекомендований графік сну")
				.font(CustomFonts.createInter(weight: .bold, size: 22))
			Text("Якщо Ви мало спите, намагайтеся спати частіше протягом дня. Найкраще мати денний сон в обід тривалістю від однієї години.\n\nНе нехтуйте сном! Хороший відпочинок допоможе організму бути сильнішим та краще боротися з хворобами, а продуктивність зросте в рази."
			)
				.font(CustomFonts.createInter(weight: .regular, size: 16))
			Text("Після пробудження рекомендовано рухатися і розминатися:")
				.font(CustomFonts.createInter(weight: .semiBold, size: 16))
			_PointedText(text: "Зробити фізичні вправи;")
			_PointedText(text: "Вийти на пробіжку;")
			_PointedText(text: "Поплавати в басейні")
			Text("Активність після сну придасть заряду енергії на цілий день.\n\nНормальний сон повинен тривати від 7 до 9 годин в залежності від ваших особливостей.")
				.font(CustomFonts.createInter(weight: .regular, size: 16))
		}
		.padding(16)
		
	}
	
	private func makeItem2Text() -> some View {
		VStack(alignment: .leading, spacing: 20) {
			Text("Лягаєте спати занадто пізно або рано?")
				.font(CustomFonts.createInter(weight: .bold, size: 22))
			Text("Для того, щоб сон був якісний і максимально ефективний, важливо дотримуватися режиму. Необхідно лягати спати і вставати в один і той самий час. Засинати найкраще між 22:00 та 00:00."
			)
				.font(CustomFonts.createInter(weight: .regular, size: 16))
			Text("Налаштувати себе на легке засинання можна, дотримуючись простих рекомендацій:")
				.font(CustomFonts.createInter(weight: .semiBold, size: 16))
			_PointedText(text: "Провітрюйте приміщення перед сном;")
			_PointedText(text: "Відмовтесь від гаджетів за 1 годину до сну;")
			_PointedText(text: "Вечеряйте не менше, ніж за 2 години до сну та не переїдайте;")
			_PointedText(text: "Світло від невеличних свічок допоможе мозку розслабитись та налаштуватись на сон")
		}
		.padding(16)
		
	}
	
	private func makeItem3Text() -> some View {
		VStack(alignment: .leading, spacing: 20) {
			Text("Більше снів!")
				.font(CustomFonts.createInter(weight: .bold, size: 22))
			Text("Майже всі сни, які бачить людина, припадають на фазу швидкого сну. Для того, щоб бачити більше снів, дотримуйтесь простих рекомендацій:"
			)
				.font(CustomFonts.createInter(weight: .regular, size: 16))
			_PointedText(text: "Поставте короткий будильник за 1,5-2 години до того, як плануєте прокинутися вранці;")
			_PointedText(text: "Поставьте в приміщенні для сну або поруч з Вами річ, що має приємний аромат (аромат для дому тощо);")
			_PointedText(text: "Концентруйтеся на тому, що Ви хотіли б побачити уві сні;")
			_PointedText(text: "Перед сном на годиннику зафіксуйте увагу на проміжку часу 1,5-2 години до запланованого пробудженняналаштуватись на сон")
		}
		.padding(16)
		
	}
	
	private func makeItem4Text() -> some View {
		VStack(alignment: .leading, spacing: 20) {
			Text("Відчуваєте себе невиспаними після сну?")
				.font(CustomFonts.createInter(weight: .bold, size: 22))
			Text("Намагайтеся відмовитися від стимуляторів та заспокійливих. Вони негативно впливають на загальний сон, його якість та седативний ефект.\n\nЗа годину до сну не відволікайтесь на гаджети, а надайте перевагу спокійному проведенню часу, наприклад:"
			)
				.font(CustomFonts.createInter(weight: .regular, size: 16))
			_PointedText(text: "читанню книги;")
			_PointedText(text: "спілкуванню з сім’єю;")
			_PointedText(text: "проведенню часу на свіжому повітрі")
			Text("За 2 години до сну краще утриматись від смачненького. Саме фаза глибокого сну допомагає нам відчувати себе бадьорими та сповненими сил.")
				.font(CustomFonts.createInter(weight: .regular, size: 16))
		}
		.padding(16)
		
	}
}

