
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Статус = Перечисления.СтатусыКабельныхЛиний.Подписан Тогда		
		ДобавитьЗаписиПоРегиструЗадания();
	КонецЕсли;	
	
	ДобавитьЗаписиПоРегиструЖурналКабели();
	
КонецПроцедуры  

Процедура ДобавитьЗаписиПоРегиструЗадания()

	Движения.ДанныеПоЗаданиямПоПрокладкеКабелей.Записывать = Истина;
	
	НоваяЗапись                           = Движения.ДанныеПоЗаданиямПоПрокладкеКабелей.Добавить();
	НоваяЗапись.Период                    = Дата;
	НоваяЗапись.ЖурналУчетаКабельнойЛинии = ЖурналУчетаКабельнойПродукции;    
	НоваяЗапись.Подрядчик                 = Подрядчик;
	НоваяЗапись.Статус                    = Перечисления.СтатусыЗаданийНаЗакупку.Выполнено;
	
КонецПроцедуры   

Процедура ДобавитьЗаписиПоРегиструЖурналКабели()

	Движения.ДанныеПоЖурналамКабельнойПродукции.Записывать = Истина;
	
	НоваяЗапись                           = Движения.ДанныеПоЖурналамКабельнойПродукции.Добавить();
	НоваяЗапись.Период                    = Дата;
	НоваяЗапись.ЖурналУчетаКабельнойЛинии = ЖурналУчетаКабельнойПродукции;
	НоваяЗапись.Статус                    = Статус;   
	НоваяЗапись.ДлинаАннулировано         = ДлинаАннулировано;
	
КонецПроцедуры


