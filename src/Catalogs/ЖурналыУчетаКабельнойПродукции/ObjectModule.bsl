
Процедура ПриЗаписи(Отказ)

	УстановитьВладелецКабельнымЛиниям();
	
КонецПроцедуры

Процедура УстановитьВладелецКабельнымЛиниям()

	Для Каждого ТекКабельнаяЛиния Из КабельныеЛинии Цикл
		ОбъектЛиния = ТекКабельнаяЛиния.КабельнаяЛиния.ПолучитьОбъект();
		ОбъектЛиния.Владелец = Ссылка;
		ОбъектЛиния.Записать();
	КонецЦикла;
	
КонецПроцедуры
